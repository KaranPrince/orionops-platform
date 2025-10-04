const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'UP', service: 'node-service' });
});

// Sample API endpoint
app.get('/api', (req, res) => {
  res.json({ message: 'Hello from OrionOps Node Service!' });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Node service running on port ${PORT}`);
});

