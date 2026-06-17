# Backend CRUD Empresas + Empleados (Node.js + Express + Sequelize + PostgreSQL)

API REST con autenticación JWT para el proyecto Flutter `crud_withnodejs`.

## Funcionalidades

- **Auth JWT**: registro y login de usuarios (contraseñas hasheadas con bcrypt).
- **Empresas**: CRUD completo + búsqueda por nombre o RUC (`?search=`). Rutas protegidas por token.
- **Empleados**: relación uno-a-muchos con Empresa (una empresa tiene muchos empleados).
- **Nube**: soporte de conexión SSL y `DATABASE_URL` para Neon / Supabase / Amazon RDS.

## Instalación local

1. Instala dependencias:
   ```bash
   npm install
   ```
2. Crea un archivo `.env` en esta carpeta (usa `variables-entorno.txt` como plantilla).
3. Arranca en modo desarrollo:
   ```bash
   npm run dev
   ```
   o en producción:
   ```bash
   npm start
   ```
El servidor queda en `http://localhost:3000`.

## Variables de entorno

Ver `variables-entorno.txt`. Resumen:

| Variable | Descripción |
|----------|-------------|
| `PORT` | Puerto del servidor (la nube lo inyecta). |
| `DB_HOST/DB_PORT/DB_NAME/DB_USER/DB_PASS` | Conexión local a PostgreSQL. |
| `DATABASE_URL` | Cadena única de conexión (tiene prioridad). La dan Neon/Supabase/Render. |
| `DB_SSL` | `true` en la nube, `false` en local. |
| `JWT_SECRET` | Secreto para firmar los tokens. **Obligatorio y secreto.** |
| `JWT_EXPIRES` | Duración del token (ej. `7d`). |

## Endpoints

### Autenticación (públicas)
| Método | Ruta | Body |
|--------|------|------|
| POST | `/api/auth/register` | `{ nombre, email, password }` |
| POST | `/api/auth/login` | `{ email, password }` |

Ambas devuelven `{ token, usuario }`. Envía el token en las rutas protegidas:
```
Authorization: Bearer <token>
```

### Empresas (requieren token)
| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/empresas` | Lista todas. Con `?search=texto` filtra por nombre o RUC. |
| GET | `/api/empresas/:id` | Una empresa con sus empleados. |
| POST | `/api/empresas` | Crea empresa. |
| PUT | `/api/empresas/:id` | Actualiza empresa. |
| DELETE | `/api/empresas/:id` | Elimina empresa (y sus empleados en cascada). |

### Empleados (requieren token)
| Método | Ruta | Descripción |
|--------|------|-------------|
| GET | `/api/empresas/:empresaId/empleados` | Empleados de una empresa. |
| POST | `/api/empresas/:empresaId/empleados` | Crea empleado en esa empresa. |
| PUT | `/api/empleados/:id` | Actualiza empleado. |
| DELETE | `/api/empleados/:id` | Elimina empleado. |

---

## Despliegue en la nube (Reto 1)

### 1. Base de datos — Neon (recomendado, gratis)
1. Crea una cuenta en https://neon.tech y un proyecto PostgreSQL.
2. Copia la **connection string** (formato `postgresql://user:pass@ep-xxx.neon.tech/db?sslmode=require`).
3. Esa cadena será tu `DATABASE_URL`. Recuerda poner `DB_SSL=true`.

> Alternativas: **Supabase** (https://supabase.com → Project Settings → Database → Connection string) o **Amazon RDS** (instancia PostgreSQL, abre el puerto 5432 en el Security Group).

### 2. Backend — Render (recomendado, gratis)
1. Sube esta carpeta a un repositorio de GitHub.
2. En https://render.com crea un **New → Web Service** apuntando al repo.
3. Configuración:
   - **Build Command**: `npm install`
   - **Start Command**: `npm start`
4. En **Environment** agrega las variables:
   - `DATABASE_URL` = (la cadena de Neon/Supabase)
   - `DB_SSL` = `true`
   - `JWT_SECRET` = (un secreto largo aleatorio)
   - `JWT_EXPIRES` = `7d`
   - (`PORT` lo inyecta Render automáticamente)
5. Deploy. Obtendrás una URL pública tipo `https://tu-app.onrender.com`.

> Alternativas: **Railway** (https://railway.app, mismo proceso, variables en la pestaña Variables) o **AWS EC2** (instala Node, clona el repo, usa `pm2` para mantener el proceso vivo).

### 3. Frontend — apuntar a la nube
En la app Flutter, cambia la URL base por la pública del backend. El proyecto lee la
variable `API_BASE_URL` (ver `lib/config/app_config.dart`). Ejecuta con:
```bash
flutter run --dart-define=API_BASE_URL=https://tu-app.onrender.com/api
```

### El desafío extra: ocultar la contraseña real
- El archivo `.env` está en `.gitignore`: **nunca** se sube al repositorio.
- En producción, las credenciales viven solo en el panel de variables de entorno del
  proveedor (Render/Railway), no en el código. Así la contraseña de la base de datos
  real nunca queda expuesta en GitHub ni en la app.
