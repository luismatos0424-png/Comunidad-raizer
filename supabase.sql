-- FIX DEFINITIVO: posts no se ven pero sí puedes acceder
-- Causa: RLS activado sin política = Supabase devuelve 0 filas SIN error.
-- Este archivo DESACTIVA RLS para posts/comments/settings (tu web es pública y usas tu contraseña en app_settings, no Auth de Supabase)
-- y agrega todas las columnas que faltan. NO borra tus posts.
-- Pega TODO en Supabase > SQL Editor > New Query > Run. Debe decir Success.

create table if not exists posts (
  id bigint generated always as identity primary key,
  titulo text not null,
  juego text,
  plataforma text default 'YouTube',
  categoria text default 'Juego',
  descripcion_corta text,
  descripcion text,
  video_url text,
  descarga_url text,
  descarga_label text default 'Descargar juego',
  imagen_url text,
  pasos text,
  requisitos_min text,
  requisitos_rec text,
  tags text,
  visitas int default 0,
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

-- Agregar columnas que falten si la tabla ya existía con el esquema viejo:
alter table posts add column if not exists titulo text;
alter table posts add column if not exists juego text;
alter table posts add column if not exists plataforma text default 'YouTube';
alter table posts add column if not exists categoria text default 'Juego';
alter table posts add column if not exists descripcion_corta text;
alter table posts add column if not exists descripcion text;
alter table posts add column if not exists video_url text;
alter table posts add column if not exists descarga_url text;
alter table posts add column if not exists descarga_label text default 'Descargar juego';
alter table posts add column if not exists imagen_url text;
alter table posts add column if not exists pasos text;
alter table posts add column if not exists requisitos_min text;
alter table posts add column if not exists requisitos_rec text;
alter table posts add column if not exists tags text;
alter table posts add column if not exists visitas int default 0;
alter table posts add column if not exists likes int default 0;
alter table posts add column if not exists created_at timestamptz default now();

alter table comments add column if not exists post_id bigint;
alter table comments add column if not exists nombre text default 'Anónimo';
alter table comments add column if not exists texto text;
alter table comments add column if not exists created_at timestamptz default now();

alter table app_settings add column if not exists admin_password text default '';
alter table app_settings add column if not exists total_visitas int default 0;

do $$ begin
  begin
    alter table comments add constraint comments_post_id_fkey foreign key (post_id) references posts(id) on delete cascade;
  exception when duplicate_object then null;
  end;
end $$;

insert into app_settings (id) values (1) on conflict (id) do nothing;

-- *** CLAVE DEL FIX: desactivar RLS para que los posts SIEMPRE se vean ***
alter table posts disable row level security;
alter table comments disable row level security;
alter table app_settings disable row level security;

-- VERIFICACIÓN: corre estas 2 consultas después de Run para confirmar:
-- select count(*) as total_posts from posts;
-- select id, titulo, plataforma, created_at from posts order by created_at desc limit 10;
-- Si count = 0, la tabla está vacía de verdad y hay que crear el primer post desde el panel admin.
-- Si count > 0 pero en la web sale 0, recarga con Ctrl+Shift+R (es caché de Vercel).
