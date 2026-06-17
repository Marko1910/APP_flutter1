const { Sequelize } = require('sequelize');
require('dotenv').config();

// Los proveedores en la nube (Neon, Supabase, Amazon RDS) exigen conexion SSL.
// Activa SSL con la variable de entorno DB_SSL=true en produccion.
const useSSL = String(process.env.DB_SSL).toLowerCase() === 'true';

const dialectOptions = useSSL
  ? {
      ssl: {
        require: true,
        // Los certificados de Neon/Supabase no son auto-firmados verificables
        // por defecto; en estos proveedores gestionados se permite la conexion.
        rejectUnauthorized: false,
      },
    }
  : {};

// Permite usar una unica URL de conexion (DATABASE_URL) como dan Neon/Supabase/Render,
// o las variables separadas DB_HOST, DB_USER, etc. para desarrollo local.
const sequelize = process.env.DATABASE_URL
  ? new Sequelize(process.env.DATABASE_URL, {
      dialect: 'postgres',
      logging: false,
      dialectOptions,
    })
  : new Sequelize(
      process.env.DB_NAME,
      process.env.DB_USER,
      process.env.DB_PASS,
      {
        host: process.env.DB_HOST,
        port: process.env.DB_PORT || 5432,
        dialect: 'postgres',
        logging: false,
        dialectOptions,
      }
    );

module.exports = sequelize;
