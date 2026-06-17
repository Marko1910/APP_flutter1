const express = require('express');
const cors = require('cors');
require('dotenv').config();
const { connectAndSync } = require('./src/models');
const authRoutes = require('./src/routes/auth.routes');
const empresaRoutes = require('./src/routes/empresa.routes');
const empleadoRoutes = require('./src/routes/empleado.routes');

const app = express();
app.use(cors());
app.use(express.json());

// Endpoint de salud para verificar que el servicio esta vivo (util en Render/Railway).
app.get('/', (req, res) => res.json({ status: 'ok', api: 'crud empresas' }));

app.use('/api/auth', authRoutes);
app.use('/api/empresas', empresaRoutes);
app.use('/api/empleados', empleadoRoutes);

const PORT = process.env.PORT || 3000;

connectAndSync().then(() => {
  app.listen(PORT, () => console.log(`Server en ${PORT}`));
});
