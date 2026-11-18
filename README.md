# Elraizercommunity - MISMO DISEÑO que la vista previa "Bienvenidos a mi comunidad"

Este ZIP es la copia exacta del diseño que te gusta:
- Header con R verde + ELRAIZER COMMUNITY + COMUNIDAD RAIZER + botón Acceder
- Hero: "Bienvenidos a mi comunidad" con "comunidad" en degradado verde -> morado
- Stats en tarjetas glass: Posts / Likes / Visitas + "En la comunidad"
- Banner: "Hoy en la comunidad: Minecraft, GTA V y Valorant..."
- Publicidad 728x90 + sidebar 300x250
- Sección "Últimos posts" + filtros Todos / YouTube / TikTok / Kick / Juegos
- Tarjetas: portada con letra del juego + degradado por plataforma, badge de plataforma, categoría, juego, título, descripción, 👁️ visitas ❤️ likes 💬 comentarios + fecha
- Al abrir un post: Video, Cómo instalar paso a paso con números verdes, Enlaces de descarga, Requisitos, Comentarios sin registro (botón morado Publicar)
- Panel admin: rounded-[28px] verde, mismo formulario
- Sidebar Sígueme con botones YouTube rojo / TikTok blanco / Kick verde + "Solo enlaces oficiales. No alojamos archivos pesados."

## Pasos
1. Supabase > SQL Editor > pega TODO supabase.sql > Run
2. Table Editor > app_settings > id=1 > admin_password = tu contraseña > Save
3. GitHub repo Comunidad-raizer > reemplaza index.html, config.js, supabase.sql por los de este ZIP > Commit
4. Vercel redepliega solo > abre con Ctrl+Shift+R

## Diferencia con el ZIP anterior
El ZIP anterior tenía hero "EL RAIZER COMMUNITY" gigante. Este tiene el hero correcto "Bienvenidos a mi comunidad".
Si al abrirlo sigues viendo el viejo, es caché: haz Ctrl+Shift+R o abre en incógnito.
