-- ELRAIZERCOMMUNITY - CORREGIDO - Pega esto en Supabase > SQL Editor > Run

create table if not exists posts (
  id bigint generated always as identity primary key,
  titulo text not null,
  juego text,
  categoria text,
  plataforma text,
  portada text,
  descripcion_corta text,
  descripcion text,
  video_url text,
  enlaces jsonb default '[]'::jsonb,
  pasos jsonb default '[]'::jsonb,
  requisitos text,
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
  ad_top text default '',
  ad_feed text default '',
  ad_sidebar text default '',
  youtube text default '',
  tiktok text default '',
  kick text default '',
  admin_password text default '',
  total_visitas int default 0,
  updated_at timestamptz default now()
);

insert into app_settings (id) values (1) on conflict (id) do nothing;

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

insert into posts (titulo, juego, categoria, plataforma, portada, descripcion_corta, descripcion, video_url, enlaces, pasos, requisitos, tags, visitas, likes) values
('Minecraft con Shaders que uso en Directo','Minecraft','Mod','Kick','https://images.unsplash.com/photo-1587573089734-09cb69c0f2b4?w=900','Los shaders que uso en directo, se ve brutal.','Instalación paso a paso de los shaders que uso en mis directos de Minecraft.','', '[{"texto":"Descargar OptiFine","url":"https://optifine.net/downloads"}]'::jsonb, '["Descarga OptiFine","Instala OptiFine","Descarga el shader","Pégalo en la carpeta shaderpacks","Actívalo en Video > Shaders"]'::jsonb, 'PC con 8GB RAM mínimo','minecraft, shaders, directo', 125, 32),
('GTA V - Cómo instalar los Mods que uso en YouTube','GTA V','Juego','YouTube','https://images.unsplash.com/photo-1552820728-8b83bb6b773f?w=900','Todos los mods que ves en mis videos.','Guía completa para instalar los mods de GTA V que uso en YouTube.','', '[{"texto":"Descargar Script Hook V","url":"https://www.dev-c.com/gtav/scripthookv/"}]'::jsonb, '["Descarga Script Hook V","Copia los archivos a la carpeta de GTA V","Instala los mods","Abre el juego y prueba"]'::jsonb, 'GTA V original, 16GB RAM recomendado','gta, mods, youtube', 340, 89),
('Valorant - Mi Configuración y Programas para Directos','Valorant','Programa','TikTok','https://images.unsplash.com/photo-1542751371-adc38448a05e?w=900','Mi setup para directos de Valorant.','Mi configuración, sensibilidad y programas que uso para directos.','', '[{"texto":"Descargar Valorant","url":"https://playvalorant.com/"}]'::jsonb, '["Descarga Valorant desde la web oficial","Instala y crea cuenta","Aplica mi sensibilidad","Configura OBS como en el video"]'::jsonb, 'PC gamer, Windows 10/11','valorant, setup, tiktok', 210, 54);
