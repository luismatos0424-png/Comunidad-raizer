# CONTROL DE ANUNCIOS + EDITAR / BORRAR POSTS

## Qué trae este ZIP
Mismo diseño "Bienvenidos a mi comunidad" que ya te funciona, + 2 cosas nuevas:

### 1. Control de Anuncios (sin tocar código)
En Panel admin > abajo hay una sección amarilla "Control de Anuncios" con 3 espacios:
- 1. Anuncio Superior - 728x90 (arriba de la web)
- 2. Anuncio en el Feed - entre los posts
- 3. Anuncio Sidebar - 300x250 (a la derecha)

Por cada espacio puedes:
- Marcar Activo / Inactivo
- Poner Imagen del anuncio (link https://...)
- Poner Link al hacer clic (a donde va el anuncio)
- O pegar Código HTML / AdSense (si pones código, ese manda sobre la imagen)

Pulsa "Guardar anuncios" y ya se ven en la web para todos.
"Quitar todos los anuncios" los deja vacíos otra vez.

Si dejas un espacio inactivo o sin imagen, se muestra el cartel vacío "Espacio publicitario" como antes.

### 2. Editar y Borrar posts desde la web
En Panel admin > Mis posts, cada post ahora tiene 3 botones:
- Ver: abre el detalle
- Editar: carga todos los datos en el formulario arriba, cambia el botón a "Actualizar post", y puedes cambiar título, juego, links, etc. Pulsa Actualizar y queda guardado SIN resetear likes ni visitas.
- Cancelar edición: vuelve a modo "Guardar post" nuevo.
- Eliminar: borra el post (pide confirmación). También borra sus comentarios.

## Pasos
1. Supabase > SQL Editor > pega TODO supabase.sql de este ZIP > Run. Agrega la columna ads y NO borra posts.
2. GitHub > reemplaza index.html y config.js por los de este ZIP > Commit.
3. Vercel > espera 2 min > abre con Ctrl+Shift+R.
4. Entra a Acceder > abajo en Panel admin verás "Control de Anuncios".
5. Prueba: Activa el Anuncio Superior, pon una imagen de prueba (ej: https://picsum.photos/728/90) y un link, Guarda, y recarga. Debe aparecer arriba.

## Si Guardar anuncios da error
Es porque falta correr el supabase.sql nuevo (agrega la columna ads). Corre el SQL y vuelve a intentar.
