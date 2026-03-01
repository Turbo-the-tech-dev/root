import express from 'express';
import { Pool } from 'pg';

/**
 * Three Dollar Store Backend: Sector 23
 * Node.js + PostgreSQL + Express
 */

const app = express();
app.use(express.json());

// Simulated Postgres Connection
const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgresql://imperial:vader@localhost:5432/dollar_store',
});

// Mock Inventory Data (Fallback if DB is unreachable)
const MOCK_INVENTORY = [
  { id: 1, name: 'Micro-USB Cable (3-pack)', price: 3.00, inventory: 500 },
  { id: 2, name: 'LED Night Light', price: 3.00, inventory: 200 },
];

app.get('/api/inventory', async (req, res) => {
  try {
    // const { rows } = await pool.query('SELECT * FROM products');
    // res.json(rows);
    res.json(MOCK_INVENTORY);
  } catch (error) {
    console.error('DB Error:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

app.post('/api/sales', async (req, res) => {
  const { productId, affiliateRef } = req.body;
  try {
    // await pool.query('INSERT INTO sales (product_id, amount, affiliate_ref) VALUES ($1, $2, $3)', [productId, 3.00, affiliateRef]);
    // await pool.query('UPDATE products SET inventory = inventory - 1 WHERE id = $1', [productId]);
    
    console.log(`[AFFILIATE TRACKING] Server registered sale for product ${productId} via ${affiliateRef}`);
    res.json({ success: true, message: 'Sale recorded' });
  } catch (error) {
    console.error('DB Error:', error);
    res.status(500).json({ error: 'Failed to record sale' });
  }
});

const PORT = process.env.PORT || 3003;
app.listen(PORT, () => {
  console.log(`🚀 $3 Store Backend running on port ${PORT}`);
});
