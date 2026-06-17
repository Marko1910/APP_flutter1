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
| **1. Infraestructura y Nube** | Despliegue de BD y backend en la nube. El codigo ya esta preparado (`DATABASE_URL` + `DB_SSL` en el backend, `--dart-define=API_BASE_URL` en el frontend) | ⏳ Pendiente de desplegar |

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

# Web / escritorio (apunta al backend local):
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000/api

# Emulador Android (10.0.2.2 = localhost del PC):
flutter run            # usa el valor por defecto del codigo
```

## Variables de entorno (backend)

El backend lee su configuracion de un archivo `.env` (NO incluido en el repo por seguridad).
Usa `backend/variables-entorno.txt` como plantilla. Variables principales:

- `PORT`, `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASS`, `DB_SSL`
- `JWT_SECRET`, `JWT_EXPIRES`
- (opcional, para nube) `DATABASE_URL`

## Stack

- **Frontend:** Flutter, Provider, http, flutter_secure_storage (movil) / shared_preferences (web)
- **Backend:** Node.js, Express, Sequelize, PostgreSQL, jsonwebtoken, bcryptjs
