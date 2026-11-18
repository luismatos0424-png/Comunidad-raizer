# Elraizercommunity - CORREGIDO

## Que estaba mal en tus archivos (ya corregido en este ZIP)

1. **config.js usaba `const` pero index.html leia `window.SUPABASE_URL`**
   En el navegador, `const` NO crea `window.SUPABASE_URL`, por eso `init()` pensaba que no habia configuracion y fallaba.
   CORREGIDO: ahora config.js usa `window.SUPABASE_URL = ...` y tambien `var`, y index.html lee ambas formas.

2. **supabase.sql tenia columnas en ESPAÑOL pero index.html pedia columnas en INGLES**
   - SQL tenia: titulo, juego, portada, descripcion_corta, enlaces, pasos, visitas, nombre, texto, ad_top, total_visitas...
   - index.html pedia: title, game, cover, short_desc, downloads, steps, views, name, text, socials, ads, total_visits...
   Por eso Supabase respondia "column does not exist" y salia "No se pudo guardar el post" / "No se pudo conectar".
   CORREGIDO: supabase.sql ahora crea todo en INGLES, igual que index.html.

## Que hay en este ZIP
- `index.html` = tu web con el parche de lectura de config.js
- `config.js` = MISMO URL y MISMA llave que ya tenias, pero ahora con `window.` para que si funcione
- `supabase.sql` = tablas CORREGIDAS en ingles + politicas RLS + 3 posts de ejemplo
- `README.md` = esta guia

## Pasos (en este orden, importante)

1. En Supabase > SQL Editor > New Query > pega TODO `supabase.sql` de este ZIP > Run.
   Debe decir Success. Esto BORRA las tablas viejas en español y las crea bien en ingles.
   Si ya tenias posts importantes que quieres conservar, NO lo ejecutes y avisame para hacerte migracion.

2. En Supabase > Table Editor > app_settings > id=1 > pon tu contraseña en `admin_password` > Save.
   No la pongas en GitHub.

3. En GitHub, reemplaza los 3 archivos: `index.html`, `config.js`, `supabase.sql` por los de este ZIP.
   Haz Commit.

4. Espera que Vercel redepliegue solo. Abre tu web con Ctrl + Shift + R.

5. Prueba: Acceder con tu contraseña > Crear post > Guardar. Ya debe decir "Post publicado." y aparecer en la lista.
   Si aun falla, abre F12 > Console y copiame el error exacto, que ahora si dira el motivo real.

## Si algo falla
- Si ves "Error en config.js": revisa que en GitHub config.js si sea el nuevo con `window.`
- Si ves "column does not exist": es que no ejecutaste el nuevo supabase.sql completo.
- Si ves RLS / row-level security: es que no se crearon las politicas, vuelve a ejecutar supabase.sql.
