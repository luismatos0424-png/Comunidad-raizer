# FIX CONEXIÓN - Ya no sale el banner verde viejo "No se pudo conectar..."

Este ZIP es el MISMO diseño exacto "Bienvenidos a mi comunidad", pero YA NO usa el banner genérico verde.
Ahora si falla, sale una caja AMARILLA que dice el error EXACTO + botón "Probar conexión".

## Si sigues viendo el banner verde viejo
Ese banner NO es de este ZIP. Es del archivo viejo que todavía está en Vercel.
Significa que GitHub todavía no reemplazó index.html, o Vercel todavía no redeplegó, o estás viendo caché.

Cómo comprobarlo en 10 segundos:
1. Entra a GitHub > tu repo > abre index.html > busca (Ctrl+F) la palabra "debugBox"
   - Si NO aparece "debugBox", estás viendo el archivo viejo. No se reemplazó.
   - Si SÍ aparece, ya es el nuevo.
2. Entra a Vercel > tu proyecto > Deployments > mira la hora del último deploy. Debe ser de hace pocos minutos.
3. Abre la web con Ctrl+Shift+R (no solo F5) o en incógnito.

## Pasos
1. Supabase > SQL Editor > pega TODO supabase.sql de este ZIP > Run (desactiva RLS y agrega columnas)
2. GitHub > reemplaza index.html Y config.js por los de este ZIP > Commit
3. Vercel > espera 2 min > abre con Ctrl+Shift+R
4. Si sale la caja amarilla, pulsa "Probar conexión" y dime qué Status te da (200, 401, 404) y qué texto sale.

## Qué significa cada Status en Probar conexión
- 200 = Supabase sí responde. Si aún no se ven posts, es tabla vacía (count=0) o RLS. Corre supabase.sql.
- 401 = Llave mal copiada. Supabase > Settings > API Keys > copia la Publishable de nuevo a config.js.
- 404 = URL mal o tabla posts no existe. Corre supabase.sql y revisa que la URL no tenga /rest/v1/ al final.
- No se pudo hacer fetch = URL mal, proyecto Paused (dale Restore en Supabase), o navegador bloqueando.
