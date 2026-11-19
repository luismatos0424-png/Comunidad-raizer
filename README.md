# BILINGÜE COMPLETO - Misma lógica que funcionó para el 23502, ahora para ANUNCIOS + EDITAR/BORRAR

## Lo que pasó en tu captura (y que ya corregimos igual que antes)
Tu captura decía:
NO se guardó. Error: null value in column "title" of relation "posts" violates not-null constraint (code 23502)

Causa real (la que ya habíamos encontrado):
- Tu tabla posts se creó en INGLÉS: title con NOT NULL, game con NOT NULL...
- Pero el index mandaba en ESPAÑOL: titulo, juego...
- Como nunca le llegaba title, quedaba en null y Supabase lo rechazaba con 23502.
- Por eso la conexión sí funcionaba, pero ningún post se guardaba.

Solución que funcionó y que repetimos aquí:
- Index manda ESPAÑOL + INGLÉS a la vez en TODO: crear, editar, comentar, restaurar.
- SQL quita el NOT NULL de TODAS las columnas (no solo title) y sincroniza español <-> inglés.
- NUEVO: trigger automático que copia solo el otro idioma si un día se manda solo uno. Así nunca vuelve el 23502.

## Qué trae este ZIP
Mismo diseño "Bienvenidos a mi comunidad" que ya te funciona, + todo junto:

1. Crear post bilingüe: titulo/title, juego/game, plataforma/platform, categoria/category, descripcion_corta/short_desc, descripcion/long_desc, imagen_url/cover, pasos/steps, requisitos_min/req_min, requisitos_rec/req_rec, descarga_url/downloads.
2. Editar post desde la web: en Mis posts > Editar, carga todo, botón cambia a Actualizar post. NO resetea likes ni visitas.
3. Borrar protegido: pide confirmación + escribir ELIMINAR, y ANTES guarda copia en Papelera.
4. Papelera: Panel admin > Ver Papelera / Restaurar. Restaura posts borrados con TODO bilingüe.
5. Control de Anuncios: Panel admin > Control de Anuncios con 3 espacios:
   - Superior 728x90, Feed entre posts, Sidebar 300x250
   - Por cada uno: Activo, Imagen, Link, Código HTML / AdSense (si pones código, manda sobre la imagen)
6. Comentarios bilingües: nombre/name + texto/text (antes un comentario solo mandaba español y podía dar 23502 en text).

## Pasos - Hazlo en este orden
1. Supabase > SQL Editor > New Query > pega TODO supabase.sql de este ZIP > Run. Debe decir Success. Si dice que ya existe el trigger, es normal, lo vuelve a crear.
2. GitHub > reemplaza index.html y config.js por los de este ZIP > Commit.
3. Vercel > espera 2 min > abre con Ctrl+Shift+R.
4. Entra a Acceder > crea un post de prueba. Si sale "Post guardado", ya quedó.
5. Si antes te salía 23502, ahora NO debe salir. Si sale otro código, copia el mensaje exacto.

## NO vuelvas a correr el archivo viejo
Borra de tu PC el archivo supabase-CORREGIDO.sql. Ese sí borraba tablas.
Solo usa el supabase.sql de ESTE ZIP. Este NO borra posts, solo agrega columnas y crea triggers.

## Verificar
Supabase > SQL Editor:
  select count(*) as total_posts from posts;
  select id, titulo, title, juego, game from posts order by created_at desc limit 5;
Si total_posts > 0 y ves titulo y title llenos, ya está sincronizado.
