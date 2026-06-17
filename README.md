# APP Flutter + Node.js — CRUD de Empresas y Empleados

Aplicacion full-stack: app **Flutter** (frontend) + API **Node.js/Express/Sequelize/PostgreSQL** (backend),
con autenticacion **JWT**, relaciones **1-a-muchos** y mejoras de **UX**.

```
.
├── frontend/   # App Flutter (Provider, http, almacenamiento de token)
└── backend/    # API Node.js (Express, Sequelize, PostgreSQL, JWT)
```

## Retos implementados

| Reto | Descripcion | Estado |
|------|-------------|--------|
| **2. Seguridad (JWT)** | Modelo Usuario, registro/login, token JWT, rutas protegidas; login en Flutter, token guardado en el dispositivo y enviado en cada peticion (`Authorization: Bearer`) | ✅ |
| **3. Relaciones** | Modelo Empleado con relacion 1-a-muchos con Empresa; lista de empleados en el detalle y boton flotante para agregarlos a esa empresa | ✅ |
| **4. UX y Busqueda** | Barra de busqueda por nombre/RUC, `Dismissible` (swipe para borrar), `RefreshIndicator` (pull to refresh) y `SnackBar` rojo ante errores | ✅ |
| **1. Infraestructura y Nube** | Base de datos en **Neon**, backend desplegado en **Render** (`render.yaml`), frontend apuntando a la URL publica por defecto. Secretos gestionados como variables de entorno en Render | ✅ |

## Como correrlo en local

### 1) Backend
```bash
cd backend
npm install
# Crea el archivo .env a partir de la plantilla variables-entorno.txt
#   (define DB_NAME, DB_USER, DB_PASS, y un JWT_SECRET)
npm run dev          # arranca en http://localhost:3000
```
Requiere PostgreSQL en marcha y la base de datos creada (por defecto `DBTest`).
Al conectar, Sequelize crea las tablas automaticamente.

### 2) Frontend (Flutter)
```bash
cd frontend
flutter pub get

# Por defecto la app ya apunta al backend en la nube (Render):
flutter run -d chrome

# Para usar el backend LOCAL en su lugar, sobreescribe la URL:
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000/api
flutter run            --dart-define=API_BASE_URL=http://10.0.2.2:3000/api  # emulador Android
```

## Demo en produccion

- **Backend (Render):** https://crud-empresas-api.onrender.com
- **Base de datos:** Neon (PostgreSQL en la nube)

> Nota: el plan free de Render "duerme" tras inactividad; la primera peticion puede tardar ~50s en despertar.

## Variables de entorno (backend)

El backend lee su configuracion de un archivo `.env` (NO incluido en el repo por seguridad).
Usa `backend/variables-entorno.txt` como plantilla. Variables principales:

- `PORT`, `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASS`, `DB_SSL`
- `JWT_SECRET`, `JWT_EXPIRES`
- (opcional, para nube) `DATABASE_URL`

## Stack

- **Frontend:** Flutter, Provider, http, flutter_secure_storage (movil) / shared_preferences (web)
- **Backend:** Node.js, Express, Sequelize, PostgreSQL, jsonwebtoken, bcryptjs
