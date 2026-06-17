const sequelize = require('../config/db');
const Empresa = require('./empresa.model');
const Empleado = require('./empleado.model');
const Usuario = require('./usuario.model');

// Relacion uno-a-muchos: una Empresa tiene muchos Empleados.
// Si se elimina la empresa, se eliminan en cascada sus empleados.
Empresa.hasMany(Empleado, {
  foreignKey: 'empresaId',
  as: 'empleados',
  onDelete: 'CASCADE'
});
Empleado.belongsTo(Empresa, {
  foreignKey: 'empresaId',
  as: 'empresa'
});

const connectAndSync = async () => {
  try {
    await sequelize.authenticate();
    console.log('DB conectado');
    await sequelize.sync(); // en dev: { alter: true } para ajustar columnas
    console.log('Modelos sincronizados');
  } catch (err) {
    console.error('Error DB', err);
  }
};

module.exports = { sequelize, Empresa, Empleado, Usuario, connectAndSync };
