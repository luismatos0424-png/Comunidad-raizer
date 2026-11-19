-- FIX DEFINITIVO 23502 - null value in column "title"
-- CAUSA REAL: Tu tabla posts se creó con el esquema en INGLÉS (title, game, platform...)
-- pero el index nuevo manda en ESPAÑOL (titulo, juego, plataforma...).
-- Como title es NOT NULL y no le llegaba nada, Supabase rechazaba: "null value in column title violates not-null"
-- ESTE SQL NO BORRA NADA. Agrega las columnas que faltan, quita el NOT NULL de title/titulo/game/juego,
-- convierte downloads/steps de jsonb a texto, y COPIA los datos entre español <-> inglés.
-- Pega TODO en Supabase > SQL Editor > New Query > Run. Debe decir Success.

-- Asegurar que existan las tablas (si ya existen, no las toca)
create table if not exists posts (
  id bigint generated always as identity primary key,
  titulo text, title text,
  juego text, game text,
  plataforma text default 'YouTube', platform text default 'YouTube',
  categoria text default 'Juego', category text default 'Juego',
  descripcion_corta text, short_desc text,
  descripcion text, long_desc text,
  video_url text,
  descarga_url text, descarga_label text default 'Descargar juego',
  imagen_url text, cover text,
  pasos text, requisitos_min text, req_min text, requisitos_rec text, req_rec text,
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
  updated_at timestamptz default now()
);

-- Agregar TODAS las columnas que falten (español + inglés)
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
alter table posts add column if not exists descarga_label text default 'Descargar juego';
alter table posts add column if not exists imagen_url text;
alter table posts add column if not exists cover text;
alter table posts add column if not exists pasos text;
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

-- Quitar NOT NULL de las columnas que daban error 23502
do $$ begin
  begin alter table posts alter column title drop not null; exception when others then null; end;
  begin alter table posts alter column titulo drop not null; exception when others then null; end;
  begin alter table posts alter column game drop not null; exception when others then null; end;
  begin alter table posts alter column juego drop not null; exception when others then null; end;
  begin alter table comments alter column text drop not null; exception when others then null; end;
  begin alter table comments alter column texto drop not null; exception when others then null; end;
end $$;

-- Convertir downloads / steps de jsonb a text para que el index nuevo no falle por tipo
do $$ begin
  begin alter table posts alter column downloads type text using downloads::text; exception when others then null; end;
  begin alter table posts alter column steps type text using steps::text; exception when others then null; end;
end $$;
alter table posts add column if not exists downloads text;
alter table posts add column if not exists steps text;

-- Sincronizar español <-> inglés: copiar donde falte
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
update posts set visitas = views where (visitas is null or visitas = 0) and views is not null and views <> 0;
update posts set views = visitas where (views is null or views = 0) and visitas is not null and visitas <> 0;

update comments set nombre = name where (nombre is null or nombre = '') and name is not null and name <> '';
update comments set name = nombre where (name is null or name = '') and nombre is not null and nombre <> '';
update comments set texto = text where (texto is null or texto = '') and text is not null and text <> '';
update comments set text = texto where (text is null or text = '') and texto is not null and texto <> '';

update app_settings set total_visitas = total_visits where (total_visitas is null or total_visitas = 0) and total_visits is not null and total_visits <> 0;
update app_settings set total_visits = total_visitas where (total_visits is null or total_visits = 0) and total_visitas is not null and total_visitas <> 0;

insert into app_settings (id) values (1) on conflict (id) do nothing;

-- CLAVE: desactivar RLS para que los posts SIEMPRE se vean
alter table posts disable row level security;
alter table comments disable row level security;
alter table app_settings disable row level security;

-- VERIFICACIÓN (corre estas 2 después de Run):
-- select count(*) as total_posts from posts;
-- select id, titulo, title, juego, game from posts order by created_at desc limit 5;


-- === CONTROL DE ANUNCIOS - NUEVO ===
-- Agrega columna ads a app_settings para guardar los 3 anuncios (top, feed, sidebar) como JSON texto.
-- Si ya existía como jsonb, la convierte a texto para que el index nuevo no falle por tipo.
alter table app_settings add column if not exists ads text;
alter table app_settings add column if not exists socials text;

do $$ begin
  begin alter table app_settings alter column ads type text using ads::text; exception when others then null; end;
  begin alter table app_settings alter column socials type text using socials::text; exception when others then null; end;
end $$;

-- Si app_settings no tiene ads, poner uno vacío por defecto
update app_settings set ads = '{"top":{"activo":false,"imagen":"","link":"","codigo":""},"feed":{"activo":false,"imagen":"","link":"","codigo":""},"sidebar":{"activo":false,"imagen":"","link":"","codigo":""}}' where id = 1 and (ads is null or ads = '');


-- === PROTECCIÓN CONTRA BORRADO TOTAL - NUEVO ===
-- 1. Tabla Papelera: guarda copia de cada post antes de borrarlo.
-- Así si borras por error, lo restauras desde Panel admin > Papelera.
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
alter table posts_backup disable row level security;

-- 2. NUNCA uses DROP TABLE en este proyecto.
-- El archivo viejo supabase-CORREGIDO.sql SÍ tenía:
--   BORRAR-TABLA comments (comando peligroso)
--   BORRAR-TABLA posts (comando peligroso)
--   BORRAR-TABLA app_settings (comando peligroso)
-- Si corriste ESE archivo viejo otra vez, ESE fue el que borró todos los posts.
-- Este archivo NUEVO NO tiene ningún comando de borrado de tabla, DELETE ni TRUNCATE de posts.
-- Solo agrega columnas y crea la papelera. No borra nada.

-- VERIFICAR si los posts de verdad se borraron o solo no se ven:
-- select count(*) as total_posts from posts;
-- select count(*) as total_papelera from posts_backup;
-- Si total_posts = 0 y total_papelera > 0, restaura desde Papelera en la web.
-- Si los 2 son 0 y corriste el archivo viejo con DROP, ve a Supabase > Database > Backups > Restore para recuperar.
