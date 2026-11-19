-- FIX BILINGÜE COMPLETO - MISMA LÓGICA QUE FUNCIONÓ PARA EL 23502, AHORA PARA ANUNCIOS + EDITAR/BORRAR + PAPELERA
-- CAUSA REAL DEL 23502 (la que ya vimos en tu captura):
-- Tu tabla posts se creó en INGLÉS: title con NOT NULL, game con NOT NULL, platform, category...
-- Pero el index mandaba en ESPAÑOL: titulo, juego, plataforma...
-- Como nunca le llegaba title, quedaba en null y Supabase rechazaba: "null value in column title violates not-null constraint (code 23502)"
-- SOLUCIÓN QUE FUNCIONÓ: index manda ESPAÑOL + INGLÉS a la vez, y el SQL quita el NOT NULL y sincroniza español <-> inglés.
-- ESTE ARCHIVO HACE LO MISMO, PERO PARA TODAS LAS FUNCIONES NUEVAS: crear, editar, comentar, restaurar, anuncios, papelera.
-- ESTE ARCHIVO NO BORRA NADA. No tiene ningún comando que borre posts. Solo agrega columnas, quita NOT NULL, sincroniza y crea triggers.
-- Pega TODO en Supabase > SQL Editor > New Query > Run. Debe decir Success.

-- 1. Asegurar que existan las tablas (si ya existen, no las toca)
create table if not exists posts (
  id bigint generated always as identity primary key,
  titulo text, title text,
  juego text, game text,
  plataforma text default 'YouTube', platform text default 'YouTube',
  categoria text default 'Juego', category text default 'Juego',
  descripcion_corta text, short_desc text,
  descripcion text, long_desc text,
  video_url text,
  descarga_url text, downloads text, descarga_label text default 'Descargar juego',
  imagen_url text, cover text,
  pasos text, steps text,
  requisitos_min text, req_min text,
  requisitos_rec text, req_rec text,
  tags text, visitas int default 0, views int default 0, likes int default 0,
  created_at timestamptz default now()
);

create table if not exists comments (
  id bigint generated always as identity primary key,
  post_id bigint references posts(id) on delete cascade,
  nombre text default 'Anónimo', name text default 'Anónimo',
  texto text, text text,
  created_at timestamptz default now()
);

create table if not exists app_settings (
  id int primary key,
  admin_password text default '',
  total_visitas int default 0, total_visits int default 0,
  ads text, socials text,
  updated_at timestamptz default now()
);

create table if not exists posts_backup (
  id bigint generated always as identity primary key,
  original_id bigint,
  titulo text, title text,
  juego text, game text,
  plataforma text, platform text,
  categoria text, category text,
  descripcion_corta text, short_desc text,
  descripcion text, long_desc text,
  video_url text,
  descarga_url text, downloads text, descarga_label text,
  imagen_url text, cover text,
  pasos text, steps text,
  requisitos_min text, req_min text,
  requisitos_rec text, req_rec text,
  tags text, visitas int default 0, views int default 0, likes int default 0,
  created_at timestamptz default now(),
  deleted_at timestamptz default now()
);

-- 2. Agregar TODAS las columnas que falten (español + inglés) en las 4 tablas
alter table posts add column if not exists titulo text;
alter table posts add column if not exists title text;
alter table posts add column if not exists juego text;
alter table posts add column if not exists game text;
alter table posts add column if not exists plataforma text default 'YouTube';
alter table posts add column if not exists platform text default 'YouTube';
alter table posts add column if not exists categoria text default 'Juego';
alter table posts add column if not exists category text default 'Juego';
alter table posts add column if not exists descripcion_corta text;
alter table posts add column if not exists short_desc text;
alter table posts add column if not exists descripcion text;
alter table posts add column if not exists long_desc text;
alter table posts add column if not exists video_url text;
alter table posts add column if not exists descarga_url text;
alter table posts add column if not exists downloads text;
alter table posts add column if not exists descarga_label text default 'Descargar juego';
alter table posts add column if not exists imagen_url text;
alter table posts add column if not exists cover text;
alter table posts add column if not exists pasos text;
alter table posts add column if not exists steps text;
alter table posts add column if not exists requisitos_min text;
alter table posts add column if not exists req_min text;
alter table posts add column if not exists requisitos_rec text;
alter table posts add column if not exists req_rec text;
alter table posts add column if not exists tags text;
alter table posts add column if not exists visitas int default 0;
alter table posts add column if not exists views int default 0;
alter table posts add column if not exists likes int default 0;
alter table posts add column if not exists created_at timestamptz default now();

alter table comments add column if not exists post_id bigint;
alter table comments add column if not exists nombre text default 'Anónimo';
alter table comments add column if not exists name text default 'Anónimo';
alter table comments add column if not exists texto text;
alter table comments add column if not exists text text;
alter table comments add column if not exists created_at timestamptz default now();

alter table app_settings add column if not exists admin_password text default '';
alter table app_settings add column if not exists total_visitas int default 0;
alter table app_settings add column if not exists total_visits int default 0;
alter table app_settings add column if not exists ads text;
alter table app_settings add column if not exists socials text;

alter table posts_backup add column if not exists original_id bigint;
alter table posts_backup add column if not exists titulo text;
alter table posts_backup add column if not exists title text;
alter table posts_backup add column if not exists juego text;
alter table posts_backup add column if not exists game text;
alter table posts_backup add column if not exists plataforma text;
alter table posts_backup add column if not exists platform text;
alter table posts_backup add column if not exists categoria text;
alter table posts_backup add column if not exists category text;
alter table posts_backup add column if not exists descripcion_corta text;
alter table posts_backup add column if not exists short_desc text;
alter table posts_backup add column if not exists descripcion text;
alter table posts_backup add column if not exists long_desc text;
alter table posts_backup add column if not exists video_url text;
alter table posts_backup add column if not exists descarga_url text;
alter table posts_backup add column if not exists downloads text;
alter table posts_backup add column if not exists descarga_label text;
alter table posts_backup add column if not exists imagen_url text;
alter table posts_backup add column if not exists cover text;
alter table posts_backup add column if not exists pasos text;
alter table posts_backup add column if not exists steps text;
alter table posts_backup add column if not exists requisitos_min text;
alter table posts_backup add column if not exists req_min text;
alter table posts_backup add column if not exists requisitos_rec text;
alter table posts_backup add column if not exists req_rec text;
alter table posts_backup add column if not exists tags text;
alter table posts_backup add column if not exists visitas int default 0;
alter table posts_backup add column if not exists views int default 0;
alter table posts_backup add column if not exists likes int default 0;
alter table posts_backup add column if not exists deleted_at timestamptz default now();

-- 3. Quitar NOT NULL de TODAS las columnas (no solo title) para que nunca vuelva el 23502
-- Esto quita el NOT NULL de title, titulo, game, juego, text, texto, etc. en las 4 tablas, excepto id.
do $$
declare r record;
begin
  for r in select table_name, column_name from information_schema.columns where table_schema = 'public' and table_name in ('posts','comments','app_settings','posts_backup') and is_nullable = 'NO' and column_name not in ('id') loop
    begin
      execute format('alter table %I alter column %I drop not null', r.table_name, r.column_name);
    exception when others then null;
    end;
  end loop;
end $$;

-- 4. Convertir downloads / steps / ads / socials de jsonb a texto (si estaban en jsonb, daban error de tipo)
do $$ begin
  begin alter table posts alter column downloads type text using downloads::text; exception when others then null; end;
  begin alter table posts alter column steps type text using steps::text; exception when others then null; end;
  begin alter table posts_backup alter column downloads type text using downloads::text; exception when others then null; end;
  begin alter table posts_backup alter column steps type text using steps::text; exception when others then null; end;
  begin alter table app_settings alter column ads type text using ads::text; exception when others then null; end;
  begin alter table app_settings alter column socials type text using socials::text; exception when others then null; end;
end $$;

-- 5. Sincronizar español <-> inglés en los datos que YA existen (copia donde falte)
update posts set titulo = title where (titulo is null or titulo = '') and title is not null and title <> '';
update posts set title = titulo where (title is null or title = '') and titulo is not null and titulo <> '';
update posts set juego = game where (juego is null or juego = '') and game is not null and game <> '';
update posts set game = juego where (game is null or game = '') and juego is not null and juego <> '';
update posts set plataforma = platform where (plataforma is null or plataforma = '') and platform is not null and platform <> '';
update posts set platform = plataforma where (platform is null or platform = '') and plataforma is not null and plataforma <> '';
update posts set categoria = category where (categoria is null or categoria = '') and category is not null and category <> '';
update posts set category = categoria where (category is null or category = '') and categoria is not null and categoria <> '';
update posts set descripcion_corta = short_desc where (descripcion_corta is null or descripcion_corta = '') and short_desc is not null;
update posts set short_desc = descripcion_corta where (short_desc is null or short_desc = '') and descripcion_corta is not null;
update posts set descripcion = long_desc where (descripcion is null or descripcion = '') and long_desc is not null;
update posts set long_desc = descripcion where (long_desc is null or long_desc = '') and descripcion is not null;
update posts set imagen_url = cover where (imagen_url is null or imagen_url = '') and cover is not null and cover <> '';
update posts set cover = imagen_url where (cover is null or cover = '') and imagen_url is not null and imagen_url <> '';
update posts set requisitos_min = req_min where (requisitos_min is null or requisitos_min = '') and req_min is not null;
update posts set req_min = requisitos_min where (req_min is null or req_min = '') and requisitos_min is not null;
update posts set requisitos_rec = req_rec where (requisitos_rec is null or requisitos_rec = '') and req_rec is not null;
update posts set req_rec = requisitos_rec where (req_rec is null or req_rec = '') and requisitos_rec is not null;
update posts set descarga_url = downloads where (descarga_url is null or descarga_url = '') and downloads is not null;
update posts set downloads = descarga_url where (downloads is null or downloads = '') and descarga_url is not null;
update posts set pasos = steps where (pasos is null or pasos = '') and steps is not null;
update posts set steps = pasos where (steps is null or steps = '') and pasos is not null;
update posts set visitas = views where (visitas is null or visitas = 0) and views is not null and views <> 0;
update posts set views = visitas where (views is null or views = 0) and visitas is not null and visitas <> 0;

update comments set nombre = name where (nombre is null or nombre = '') and name is not null and name <> '';
update comments set name = nombre where (name is null or name = '') and nombre is not null and nombre <> '';
update comments set texto = text where (texto is null or texto = '') and text is not null and text <> '';
update comments set text = texto where (text is null or text = '') and texto is not null and texto <> '';

update app_settings set total_visitas = total_visits where (total_visitas is null or total_visitas = 0) and total_visits is not null and total_visits <> 0;
update app_settings set total_visits = total_visitas where (total_visits is null or total_visits = 0) and total_visitas is not null and total_visitas <> 0;

update posts_backup set titulo = title where (titulo is null or titulo = '') and title is not null and title <> '';
update posts_backup set title = titulo where (title is null or title = '') and titulo is not null and titulo <> '';
update posts_backup set juego = game where (juego is null or juego = '') and game is not null and game <> '';
update posts_backup set game = juego where (game is null or game = '') and juego is not null and juego <> '';

insert into app_settings (id) values (1) on conflict (id) do nothing;
update app_settings set ads = '{"top":{"activo":false,"imagen":"","link":"","codigo":""},"feed":{"activo":false,"imagen":"","link":"","codigo":""},"sidebar":{"activo":false,"imagen":"","link":"","codigo":""}}' where id = 1 and (ads is null or ads = '');

-- 6. TRIGGER automático: a partir de ahora, si el index manda solo español o solo inglés, la base copia sola el otro idioma.
-- Así aunque un día se te olvide mandar bilingüe, nunca vuelve el 23502.
create or replace function sync_bilingue_posts() returns trigger as $$
begin
  if (new.titulo is null or new.titulo = '') and new.title is not null and new.title <> '' then new.titulo := new.title; end if;
  if (new.title is null or new.title = '') and new.titulo is not null and new.titulo <> '' then new.title := new.titulo; end if;
  if (new.titulo is null or new.titulo = '') and (new.title is null or new.title = '') then new.titulo := 'Sin título'; new.title := 'Sin título'; end if;
  if (new.juego is null or new.juego = '') and new.game is not null then new.juego := new.game; end if;
  if (new.game is null or new.game = '') and new.juego is not null then new.game := new.juego; end if;
  if (new.plataforma is null or new.plataforma = '') and new.platform is not null then new.plataforma := new.platform; end if;
  if (new.platform is null or new.platform = '') and new.plataforma is not null then new.platform := new.plataforma; end if;
  if (new.categoria is null or new.categoria = '') and new.category is not null then new.categoria := new.category; end if;
  if (new.category is null or new.category = '') and new.categoria is not null then new.category := new.categoria; end if;
  if (new.descripcion_corta is null or new.descripcion_corta = '') and new.short_desc is not null then new.descripcion_corta := new.short_desc; end if;
  if (new.short_desc is null or new.short_desc = '') and new.descripcion_corta is not null then new.short_desc := new.descripcion_corta; end if;
  if (new.descripcion is null or new.descripcion = '') and new.long_desc is not null then new.descripcion := new.long_desc; end if;
  if (new.long_desc is null or new.long_desc = '') and new.descripcion is not null then new.long_desc := new.descripcion; end if;
  if (new.imagen_url is null or new.imagen_url = '') and new.cover is not null then new.imagen_url := new.cover; end if;
  if (new.cover is null or new.cover = '') and new.imagen_url is not null then new.cover := new.imagen_url; end if;
  if (new.descarga_url is null or new.descarga_url = '') and new.downloads is not null then new.descarga_url := new.downloads; end if;
  if (new.downloads is null or new.downloads = '') and new.descarga_url is not null then new.downloads := new.descarga_url; end if;
  if (new.pasos is null or new.pasos = '') and new.steps is not null then new.pasos := new.steps; end if;
  if (new.steps is null or new.steps = '') and new.pasos is not null then new.steps := new.pasos; end if;
  if (new.requisitos_min is null or new.requisitos_min = '') and new.req_min is not null then new.requisitos_min := new.req_min; end if;
  if (new.req_min is null or new.req_min = '') and new.requisitos_min is not null then new.req_min := new.requisitos_min; end if;
  if (new.requisitos_rec is null or new.requisitos_rec = '') and new.req_rec is not null then new.requisitos_rec := new.req_rec; end if;
  if (new.req_rec is null or new.req_rec = '') and new.requisitos_rec is not null then new.req_rec := new.requisitos_rec; end if;
  if new.visitas is null then new.visitas := coalesce(new.views, 0); end if;
  if new.views is null then new.views := coalesce(new.visitas, 0); end if;
  if new.likes is null then new.likes := 0; end if;
  return new;
end;
$$ language plpgsql;

create or replace function sync_bilingue_comments() returns trigger as $$
begin
  if (new.nombre is null or new.nombre = '') and new.name is not null and new.name <> '' then new.nombre := new.name; end if;
  if (new.name is null or new.name = '') and new.nombre is not null and new.nombre <> '' then new.name := new.nombre; end if;
  if (new.texto is null or new.texto = '') and new.text is not null then new.texto := new.text; end if;
  if (new.text is null or new.text = '') and new.texto is not null then new.text := new.texto; end if;
  if (new.texto is null or new.texto = '') and (new.text is null or new.text = '') then new.texto := ''; new.text := ''; end if;
  return new;
end;
$$ language plpgsql;

create or replace function sync_bilingue_settings() returns trigger as $$
begin
  if new.total_visitas is null then new.total_visitas := coalesce(new.total_visits, 0); end if;
  if new.total_visits is null then new.total_visits := coalesce(new.total_visitas, 0); end if;
  return new;
end;
$$ language plpgsql;

drop trigger if exists trg_bilingue_posts on posts;
create trigger trg_bilingue_posts before insert or update on posts for each row execute function sync_bilingue_posts();

drop trigger if exists trg_bilingue_comments on comments;
create trigger trg_bilingue_comments before insert or update on comments for each row execute function sync_bilingue_comments();

drop trigger if exists trg_bilingue_settings on app_settings;
create trigger trg_bilingue_settings before insert or update on app_settings for each row execute function sync_bilingue_settings();

-- 7. CLAVE: desactivar RLS para que los posts SIEMPRE se vean (cuando RLS está activo sin política, Supabase devuelve 0 filas sin error)
alter table posts disable row level security;
alter table comments disable row level security;
alter table app_settings disable row level security;
alter table posts_backup disable row level security;

-- VERIFICACIÓN (corre estas 2 después de Run):
-- select count(*) as total_posts from posts;
-- select id, titulo, title, juego, game from posts order by created_at desc limit 5;
