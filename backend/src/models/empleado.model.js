const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');

const Empleado = sequelize.define('Empleado', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  nombre: {
    type: DataTypes.STRING,
    allowNull: false
  },
  cargo: DataTypes.STRING,
  email: DataTypes.STRING,
  telefono: DataTypes.STRING,
  esactivo: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  },
  // Clave foranea hacia la empresa (relacion uno-a-muchos).
  empresaId: {
    type: DataTypes.INTEGER,
    allowNull: false
  }
}, {
  tableName: 'empleados',
  timestamps: true
});

module.exports = Empleado;
