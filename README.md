# Elraizercommunity - ZIP COMPLETO para GitHub + Vercel
Diseño IGUAL a Elraizercommunity: hero grande, stats, filtros, tarjetas con badge, sidebar con anuncios, panel admin completo.

## Qué trae
- index.html = Diseño Elraizercommunity completo + Supabase (SIN JOIN que tumbaba los posts)
- config.js = Ya con tu URL y tu llave publishable, con window.
- supabase.sql = Esquema completo, NO borra tus posts
- README.md = Esta guía

## Paso 1 - Supabase (OBLIGATORIO, 1 minuto)
1. Entra a Supabase > tu proyecto elraizercommunity > SQL Editor > New Query
2. Pega TODO el archivo supabase.sql de este ZIP > Run (debe decir Success)
3. Ve a Table Editor > app_settings > id=1 > en admin_password pon tu contraseña > Save
   Si no hay fila id=1, créala: id=1, admin_password=tu contraseña, total_visitas=0

## Paso 2 - GitHub
1. Entra a tu repo Comunidad-raizer
2. Borra / reemplaza estos 3 archivos por los de este ZIP:
   - index.html (reemplazar)
   - config.js (reemplazar)
   - supabase.sql (reemplazar)
3. Commit changes

## Paso 3 - Vercel
- Vercel redepliega solo en 1-2 min.
- Abre https://comunidadraizer.vercel.app/ con Ctrl + Shift + R (recarga fuerte)
- Debe mostrar los posts. Si está vacío, es que de verdad no hay posts: entra con Acceder y crea el primero.

## Cómo publicar un post
Acceder (solo tú) > Panel Admin:
- Título * , Juego, Plataforma (YouTube/TikTok/Kick/Juegos), Categoría
- Descripción corta (tarjeta) + Descripción larga (al abrir el post)
- Link de imagen (portada, pega el link, no subas archivos pesados)
- Link del video + Link de descarga + Texto del botón
- Pasos (uno por línea), Requisitos mínimos / recomendados, Tags
- Guardar post -> aparece arriba de inmediato.

## Cómo funciona para visitantes
- Sin registro: pueden dar like (1 por navegador), comentar anónimo o con nombre, ver visitas.
- Likes y visitas se guardan en Supabase.
- Los anuncios son espacios 728x90 + 300x250 + 300x600 para AdSense.

## Si algo falla
- "No se pudieron cargar los posts: ..." -> Copia el mensaje tal cual. Casi siempre es que falta correr supabase.sql.
- "Acceso incorrecto" -> La contraseña en Supabase app_settings id=1 no coincide. Cámbiala ahí, no en GitHub.
- No subas tu service_role key a GitHub. Solo la publishable que ya está en config.js.
