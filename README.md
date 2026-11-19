# FIX 23502 - null value in column "title"

## Qué era el error de tu captura
Tu captura dice:
"NO se guardó. Error: null value in column \"title\" of relation \"posts\" violates not-null constraint (code 23502)"

Eso NO es que falte una columna. Es lo contrario:
- Tu tabla en Supabase se creó con el esquema en INGLÉS: title (NOT NULL), game (NOT NULL), platform, category...
- El index nuevo mandaba en ESPAÑOL: titulo, juego, plataforma...
- Como nunca le llegaba "title", Supabase lo rechazaba porque title es NOT NULL y quedaba en null.

Por eso nunca se guardaba ningún post, aunque la conexión sí funcionaba.

## Qué hace este ZIP
1. index.html BILINGÜE: ahora manda AMBOS: titulo + title, juego + game, plataforma + platform, etc.
   Así nunca más da 23502, no importa si tu tabla es en inglés o en español.
   Y al mostrar, lee titulo O title, juego O game, etc.

2. supabase.sql BILINGÜE: 
   - Agrega todas las columnas que faltan (español + inglés)
   - Quita el NOT NULL de title, titulo, game, juego, text, texto
   - Convierte downloads / steps de jsonb a texto (para que no falle por tipo)
   - Copia los datos: titulo <-> title, juego <-> game, etc.
   - Desactiva RLS
   NO BORRA tus posts.

## Pasos (en este orden)
1. Supabase > SQL Editor > New Query > pega TODO supabase.sql de este ZIP > Run. Debe decir Success.
2. GitHub > reemplaza index.html y config.js por los de este ZIP > Commit.
   - Si ya tienes diagnostico.html en GitHub, déjalo, no hace falta subirlo de nuevo.
3. Vercel > espera 2 min > abre con Ctrl+Shift+R.
4. Entra a Acceder > crea un post de prueba > debe salir "✅ Post guardado".
5. Si vuelve a salir 23502, dime qué columna dice ahora (title, game, text...) y te lo ajusto.

## Si ya tenías posts en inglés
El SQL los copia a español, así que van a seguir apareciendo en la web.
