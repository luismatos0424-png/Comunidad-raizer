# ELRAIZERCOMMUNITY - ZIP para GitHub + Vercel + Supabase

## Qué hay en este ZIP
- `index.html` -> tu web completa (Bienvenidos a mi comunidad, botón Acceder, editor pro, likes, comentarios, contador de visitas, publicidad)
- `config.js` -> aquí pegas tu URL y KEY de Supabase
- `supabase.sql` -> crea las tablas y los posts de ejemplo
- `README.md` -> esta guía

## 1. ¿Tengo que hacer algo en Supabase? SÍ, solo 5 minutos, una sola vez

Supabase es la base de datos que guarda todo: posts, comentarios, likes, visitas, publicidad. Sin esto, en GitHub/Vercel la web quedaría en modo demo y no guardaría nada.

### Paso a paso Supabase

1. Entra a **https://supabase.com** > **Start your project** > Crea cuenta gratis con Google/GitHub
2. **New Project**
   - Name: `elraizercommunity`
   - Database Password: inventa una y guárdala
   - Region: elige `South America (Sao Paulo)` que es la más cerca a Colombia
   - Dale **Create project** y espera 1-2 min
3. En el menú izquierdo ve a **SQL Editor** > **New Query**
   - Abre el archivo `supabase.sql` de este ZIP, copia TODO y pégalo ahí
   - Dale **Run**. Debe decir Success. Esto crea `posts`, `comments`, `app_settings` y 3 posts de ejemplo.
4. Ve a **Table Editor** > `app_settings` > abre la fila `id = 1`
   - En la columna `admin_password` pon TU contraseña maestra (la que solo tú sabes)
   - En `youtube`, `tiktok`, `kick` pon tus links
   - Dale Save. **IMPORTANTE: No pongas tu contraseña en ningún archivo de GitHub, solo aquí en Supabase.**
5. Ve a **Project Settings (⚙️ abajo) > API**
   - Copia **Project URL** -> ej: `https://abcd1234.supabase.co`
   - Copia **anon public key** -> es la clave larga que empieza por `eyJ...`
6. Abre `config.js` de este ZIP y pega esos 2 datos donde dice `TU_SUPABASE_URL_AQUI` y `TU_ANON_KEY_AQUI`. Guarda.

Listo. Ya tienes base de datos activa.

## 2. Subir a GitHub

1. En GitHub > **New repository** > Nombre: `elraizercommunity` > **Public** > Create
2. Dale **Upload files** > Arrastra los 4 archivos del ZIP: `index.html`, `config.js`, `supabase.sql`, `README.md`
3. **Commit changes**

## 3. Publicar en Vercel

1. Entra a **https://vercel.com** > **Add New > Project** > **Import Git Repository**
2. Elige `elraizercommunity` > **Deploy**
3. Te dará un link tipo `https://elraizercommunity.vercel.app` - esa ya es tu web oficial.

## 4. Cómo usarla ya publicada

- Visitantes: ven posts, dan like, comentan con nombre o como Anónimo
- Tú: botón **Acceder** > pones tu contraseña maestra (la que pusiste en Supabase)
- En Admin: **+ Nuevo Post** -> título, juego, portada por enlace o desde PC, stickers 🎮🔥, negrita, títulos, enlaces de descarga, pasos de instalación, requisitos
- **Publicidad / Ajustes**: pega ahí tu código de AdSense (banner superior e in-feed) y tus redes. Se guarda en Supabase.
- Cada post, comentario, like, visita y archivo compartido queda guardado en Supabase, no se borra al recargar.

## Si algo falla

- Si ves "Modo demo": es que `config.js` aún tiene los textos `TU_SUPABASE...` sin reemplazar.
- Si no te deja entrar: revisa que en Supabase `app_settings > admin_password` sí tenga tu contraseña, sin espacios.
- Si no cargan posts: revisa que corriste `supabase.sql` completo y que en **Authentication > Policies** no bloqueaste nada.

## Seguridad

- Nunca subas tu contraseña maestra a GitHub, ni en `config.js`, ni en `index.html`.
- La `anon key` sí es pública y es la que va en `config.js`, esa no es tu contraseña.
