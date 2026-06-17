const express = require('express');
const router = express.Router();
const ctrl = require('../controllers/empleado.controller');
const verifyToken = require('../middleware/auth.middleware');

router.use(verifyToken);

router.put('/:id', ctrl.updateEmpleado);
router.delete('/:id', ctrl.deleteEmpleado);

module.exports = router;
