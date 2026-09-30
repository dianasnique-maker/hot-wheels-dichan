# Hot Wheels DiChan

Catálogo online de Hot Wheels con:
- Catálogo público.
- Búsqueda y filtros.
- Panel de administración protegido con Supabase Auth.
- Alta, edición y eliminación de modelos.
- Fotografías almacenadas en Supabase Storage.
- Botón de WhatsApp.
- Base de datos compartida online.

## Estructura
- `index.html`: sitio completo.
- `config.js`: URL y publishable key de Supabase.
- `supabase.sql`: tablas, seguridad, Storage y datos iniciales.

## Configuración
1. Crear un proyecto en Supabase.
2. Abrir SQL Editor y ejecutar `supabase.sql`.
3. Crear un usuario administrador en Authentication > Users.
4. Copiar Project URL y Publishable key en `config.js`.
5. Publicar este repositorio con GitHub Pages, Netlify o Vercel.

Importante: nunca subir una service_role key al navegador.
