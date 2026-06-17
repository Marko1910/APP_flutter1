const { Empleado, Empresa } = require('../models');

// GET /api/empresas/:empresaId/empleados  -> empleados de una empresa
const getByEmpresa = async (req, res) => {
  try {
    const empresa = await Empresa.findByPk(req.params.empresaId);
    if (!empresa) return res.status(404).json({ error: 'Empresa no existe' });

    const empleados = await Empleado.findAll({
      where: { empresaId: req.params.empresaId },
      order: [['id', 'ASC']]
    });
    res.json(empleados);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// POST /api/empresas/:empresaId/empleados  -> crea empleado en esa empresa
const createForEmpresa = async (req, res) => {
  try {
    const empresa = await Empresa.findByPk(req.params.empresaId);
    if (!empresa) return res.status(404).json({ error: 'Empresa no existe' });

    const { nombre, cargo, email, telefono } = req.body;
    const empleado = await Empleado.create({
      nombre,
      cargo,
      email,
      telefono,
      empresaId: empresa.id
    });
    res.status(201).json(empleado);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// PUT /api/empleados/:id
const updateEmpleado = async (req, res) => {
  try {
    const empleado = await Empleado.findByPk(req.params.id);
    if (!empleado) return res.status(404).json({ error: 'No existe' });
    await empleado.update(req.body);
    res.json(empleado);
  } catch (err) {
    res.status(400).json({ error: err.message });
  }
};

// DELETE /api/empleados/:id
const deleteEmpleado = async (req, res) => {
  try {
    const empleado = await Empleado.findByPk(req.params.id);
    if (!empleado) return res.status(404).json({ error: 'No existe' });
    await empleado.destroy();
    res.json({ message: 'Eliminado' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = { getByEmpresa, createForEmpresa, updateEmpleado, deleteEmpleado };
