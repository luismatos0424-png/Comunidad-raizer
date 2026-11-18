-- Elraizercommunity - FIX DEFINITIVO POSTS - No borra tus datos
-- Pega TODO en Supabase > SQL Editor > New Query > Run
-- Esto arregla: "entro pero no veo posts" y "no puedo crear posts"
-- Causa 1: loadAll pedía posts + comments(count) con JOIN. Si no hay FK, fallaba y dejaba la lista vacía.
-- Causa 2: savePost pedía descarga_url / imagen_url que no existían en la tabla vieja.
-- Causa 3: faltaban políticas RLS para posts.

-- 1. Asegurar tablas
create table if not exists posts (
  id bigint generated always as identity primary key,
  titulo text not null,
  juego text,
  plataforma text default 'YouTube',
  descripcion text,
  video_url text,
  descarga_url text,
  imagen_url text,
  likes int default 0,
  created_at timestamptz default now()
);
create table if not exists comments (
  id bigint generated always as identity primary key,
  post_id bigint references posts(id) on delete cascade,
  nombre text default 'Anónimo',
  texto text not null,
  created_at timestamptz default now()
);
create table if not exists app_settings (
  id int primary key,
  admin_password text default '',
  total_visitas int default 0,
  updated_at timestamptz default now()
);

-- 2. Agregar columnas que faltan si tu tabla ya existía (esto es lo que impide crear posts)
alter table posts add column if not exists titulo text;
alter table posts add column if not exists juego text;
alter table posts add column if not exists plataforma text default 'YouTube';
alter table posts add column if not exists descripcion text;
alter table posts add column if not exists video_url text;
alter table posts add column if not exists descarga_url text;
alter table posts add column if not exists imagen_url text;
alter table posts add column if not exists likes int default 0;
alter table posts add column if not exists created_at timestamptz default now();

alter table comments add column if not exists post_id bigint;
alter table comments add column if not exists nombre text default 'Anónimo';
alter table comments add column if not exists texto text;

-- 3. Si comments.post_id no tiene FK, agrégala (sin esto el JOIN viejo fallaba). Si ya existe, no pasa nada.
do $$ begin
  begin
    alter table comments add constraint comments_post_id_fkey foreign key (post_id) references posts(id) on delete cascade;
  exception when duplicate_object then null;
  end;
end $$;

insert into app_settings (id) values (1) on conflict (id) do nothing;

-- 4. RLS + políticas para posts y comments (sin esto, entras pero no ves nada)
alter table posts enable row level security;
alter table comments enable row level security;
alter table app_settings enable row level security;

drop policy if exists "public read posts" on posts;
drop policy if exists "public write posts" on posts;
create policy "public read posts" on posts for select using (true);
create policy "public write posts" on posts for all using (true) with check (true);

drop policy if exists "public read comments" on comments;
drop policy if exists "public write comments" on comments;
create policy "public read comments" on comments for select using (true);
create policy "public write comments" on comments for all using (true) with check (true);

drop policy if exists "public read settings" on app_settings;
drop policy if exists "public write settings" on app_settings;
create policy "public read settings" on app_settings for select using (true);
create policy "public write settings" on app_settings for all using (true) with check (true);

-- 5. VERIFICACIÓN: después de Run, ejecuta esto en otra pestaña para ver si ya tienes posts:
-- select id, titulo, juego, plataforma from posts order by created_at desc;
-- Si sale vacío, es que de verdad no hay posts, no es error. Crea uno desde Admin.
