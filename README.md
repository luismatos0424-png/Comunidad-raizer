# FIX - Se volvieron a borrar los posts - PROTEGIDO

## Por qué se borraron (lo más probable)
Este ZIP nuevo NO borra posts. Lo verifiqué: no tiene ningún DROP, DELETE ni TRUNCATE de posts.

Lo que SÍ borra es el archivo VIEJO supabase-CORREGIDO.sql que tiene al inicio:
  drop table if exists comments cascade;
  drop table if exists posts cascade;
  drop table if exists app_settings cascade;

Si corriste ESE archivo viejo otra vez pensando que era el nuevo, ese fue el que borró todo.
A partir de ahora, NO vuelvas a correr ningún archivo que diga CORREGIDO o que tenga DROP TABLE.
Solo usa el supabase.sql de ESTE ZIP.

## Cómo saber si de verdad se borraron o solo no se ven
1. Supabase > SQL Editor > corre:
   select count(*) as total_posts from posts;
   select count(*) as total_papelera from posts_backup;
- Si total_posts > 0 pero en la web salen 0: es RLS o caché, no borrado. Corre el supabase.sql de este ZIP y recarga con Ctrl+Shift+R.
- Si total_posts = 0 y total_papelera > 0: restaura desde la web (abajo).
- Si los 2 son 0 y corriste el archivo viejo con DROP: ve a Supabase > Database > Backups > Restore. Supabase guarda backups automáticos.

## Qué trae este ZIP para que no vuelva a pasar
1. Borrar ahora es PROTEGIDO:
   - Al pulsar Eliminar, te muestra el título del post
   - Te pide escribir ELIMINAR en mayúsculas para confirmar
   - ANTES de borrar, guarda una copia en Papelera (tabla posts_backup)

2. Papelera en Panel admin:
   - Botón "Ver Papelera / Restaurar posts borrados"
   - Ahí ves los posts borrados con fecha y botón Restaurar
   - Restaurar los vuelve a poner en la web
   - Borrar para siempre los quita de la papelera

3. supabase.sql NUEVO: crea posts_backup, NO tiene DROP, solo agrega columnas.

## Pasos
1. Supabase > SQL Editor > pega TODO supabase.sql de este ZIP > Run. Debe decir Success.
2. GitHub > reemplaza index.html y config.js > Commit.
3. Vercel > espera 2 min > Ctrl+Shift+R.
4. Entra a Acceder > Panel admin > Ver Papelera. Si hay copias ahí, pulsa Restaurar.
5. BORRA de tu PC el archivo viejo supabase-CORREGIDO.sql para no correrlo por error otra vez.
