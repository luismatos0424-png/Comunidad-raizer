-- Elraizercommunity - CORREGIDO 2026 - Esquema en INGLES, igual que index.html
-- Ejecutar TODO en Supabase > SQL Editor > New Query > Run
-- Este archivo corrige el error principal: antes la tabla tenia columnas en ESPAÑOL
-- (titulo, juego, portada...) pero index.html pedía columnas en INGLES (title, game, cover...)
-- por eso todo fallaba con "column does not exist" / "No se pudo guardar el post".

-- 1. Si ya tienes tablas viejas en español, las borramos para crearlas bien.
--    Si ya tienes posts que quieres conservar, NO ejecutes el DROP, avisame y te hago migracion.
--    Para un proyecto nuevo / sin datos importantes, este DROP es lo mas limpio:
drop table if exists comments cascade;
drop table if exists posts cascade;
drop table if exists app_settings cascade;

-- 2. POSTS - esquema INGLES (el que usa index.html)
create table posts (
  id bigint generated always as identity primary key,
  title text not null,
  game text not null,
  platform text default 'YouTube',
  category text default 'Juego',
  cover text,
  short_desc text,
  long_desc text,
  video_url text,
  downloads jsonb default '[]'::jsonb,
  steps jsonb default '[]'::jsonb,
  req_min text default '',
  req_rec text default '',
  tags text default '',
  views int default 0,
  likes int default 0,
  created_at timestamptz default now()
);

-- 3. COMMENTS - esquema INGLES (name, text)
create table comments (
  id bigint generated always as identity primary key,
  post_id bigint references posts(id) on delete cascade,
  name text default 'Anónimo',
  text text not null,
  created_at timestamptz default now()
);

-- 4. SETTINGS - esquema INGLES (socials jsonb, ads jsonb, total_visits)
create table app_settings (
  id int primary key,
  admin_password text default '',
  socials jsonb default '{"youtube":"https://youtube.com/@elraizer","tiktok":"https://tiktok.com/@elraizer","kick":"https://kick.com/elraizer"}'::jsonb,
  ads jsonb default '{"top":"","feed":"","sidebar":""}'::jsonb,
  total_visits int default 0,
  updated_at timestamptz default now()
);

insert into app_settings (id) values (1) on conflict (id) do nothing;

-- 5. RLS + POLITICAS PUBLICAS (la web es publica)
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

-- 6. POSTS DE EJEMPLO (ya en esquema INGLES)
insert into posts (title, game, category, platform, cover, short_desc, long_desc, video_url, downloads, steps, req_min, req_rec, tags, views, likes) values
('Minecraft con Shaders que uso en Directo','Minecraft','Mod','Kick','https://images.unsplash.com/photo-1587573089734-09cb69c0f2b4?w=900','Los shaders que uso en directo, se ve brutal.','Instalación paso a paso de los shaders que uso en mis directos de Minecraft.','', '[{"label":"Descargar OptiFine","url":"https://optifine.net/downloads"}]'::jsonb, '["Descarga OptiFine","Instala OptiFine","Descarga el shader","Pégalo en la carpeta shaderpacks","Actívalo en Video > Shaders"]'::jsonb, 'PC con 8GB RAM mínimo','PC con 16GB RAM recomendado','minecraft, shaders, directo', 125, 32),
('GTA V - Cómo instalar los Mods que uso en YouTube','GTA V','Juego','YouTube','https://images.unsplash.com/photo-1552820728-8b83bb6b773f?w=900','Todos los mods que ves en mis videos.','Guía completa para instalar los mods de GTA V que uso en YouTube.','', '[{"label":"Descargar Script Hook V","url":"https://www.dev-c.com/gtav/scripthookv/"}]'::jsonb, '["Descarga Script Hook V","Copia los archivos a la carpeta de GTA V","Instala los mods","Abre el juego y prueba"]'::jsonb, 'GTA V original, 8GB RAM','GTA V original, 16GB RAM recomendado','gta, mods, youtube', 340, 89),
('Valorant - Mi Configuración y Programas para Directos','Valorant','Programa','TikTok','https://images.unsplash.com/photo-1542751371-adc38448a05e?w=900','Mi setup para directos de Valorant.','Mi configuración, sensibilidad y programas que uso para directos.','', '[{"label":"Descargar Valorant","url":"https://playvalorant.com/"}]'::jsonb, '["Descarga Valorant desde la web oficial","Instala y crea cuenta","Aplica mi sensibilidad","Configura OBS como en el video"]'::jsonb, 'PC gamer, Windows 10/11','PC gamer, Windows 11','valorant, setup, tiktok', 210, 54);

-- DESPUES DE ESTO:
-- Ve a Table Editor > app_settings > id=1 > pon tu contraseña en admin_password y guarda.
-- No pongas tu contraseña en GitHub, solo ahí en Supabase.
