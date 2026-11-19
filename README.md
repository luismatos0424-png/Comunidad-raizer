# VERIFICAR - Diagnóstico real

Este ZIP trae un archivo nuevo: diagnostico.html

## Cómo usarlo
1. Supabase > SQL Editor > pega TODO supabase.sql > Run
2. GitHub > sube TODOS los archivos de este ZIP:
   - index.html (reemplazar)
   - config.js (reemplazar)
   - diagnostico.html (NUEVO - subirlo)
   - supabase.sql (reemplazar)
3. Vercel > espera 2 min
4. Abre en el navegador:
   https://comunidadraizer.vercel.app/diagnostico.html
   con Ctrl+Shift+R

Esa página te dice el error EXACTO, sin banner genérico:
- Si dice "Posts encontrados: 3" pero en la web principal no se ven -> la web principal es el archivo viejo / caché.
- Si dice "Tabla vacía" -> no hay posts guardados, hay que crear el primero desde Acceder.
- Si dice Error 42P01 -> tabla no existe, corre supabase.sql.
- Si dice 401 / llave mal -> copia de nuevo la llave publishable.

## Por qué el verificador de Meta AI no puede leer tu web
Tu web es 100% JavaScript (Tailwind + Supabase). La herramienta de lectura no puede renderizar JS, por eso dice "no readable text". No es que tu web esté caída, es que hay que verificarla con diagnostico.html que sí muestra el resultado en pantalla.
