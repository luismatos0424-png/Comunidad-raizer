-- Elraizercommunity - ESQUEMA COMPLETO - Diseño Elraizercommunity + Supabase
-- Pega TODO en Supabase > SQL Editor > New Query > Run
-- NO borra tus posts. Solo crea tablas y agrega columnas que falten.

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

-- Si tu tabla posts ya existía con el esquema viejo, agrega todo lo que falta:
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

-- FK comments -> posts (si no existe)
do $$ begin
  begin
    alter table comments add constraint comments_post_id_fkey foreign key (post_id) references posts(id) on delete cascade;
  exception when duplicate_object then null;
  end;
end $$;

insert into app_settings (id) values (1) on conflict (id) do nothing;

-- RLS + políticas públicas (sin esto entras pero no ves posts)
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

-- VERIFICACIÓN rápida:
-- select id, titulo, plataforma from posts order by created_at desc;
