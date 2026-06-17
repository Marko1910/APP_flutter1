const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/empresa.controller');
const empleadoCtrl = require('../controllers/empleado.controller');
const verifyToken = require('../middleware/auth.middleware');

// Todas las rutas de empresas requieren un token JWT valido.
router.use(verifyToken);

router.post('/', ctrl.createEmpresa);
router.get('/', ctrl.getAll);
router.get('/:id', ctrl.getById);
router.put('/:id', ctrl.updateEmpresa);
router.delete('/:id', ctrl.deleteEmpresa);

// Empleados anidados bajo una empresa (relacion uno-a-muchos).
router.get('/:empresaId/empleados', empleadoCtrl.getByEmpresa);
router.post('/:empresaId/empleados', empleadoCtrl.createForEmpresa);

module.exports = router;
