const { DataTypes } = require('sequelize');
const sequelize = require('../config/db');

const Empresa = sequelize.define('Empresa', {
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  nombre: {
    type: DataTypes.STRING,
    allowNull: false
  },
  ruc: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true
  },
  direccion: DataTypes.STRING,
  rubro: DataTypes.STRING,
  esactivo: {
    type: DataTypes.BOOLEAN,
    defaultValue: true
  }
}, {
  tableName: 'empresas',
  timestamps: true
});

module.exports = Empresa;