import express, { Request, Response } from 'express';
import { Pool } from 'pg';

const app = express();
const pool = new Pool({
  user: 'yourusername',
  host: 'localhost',
  database: 'angelone',
  password: 'yourpassword',
  port: 5432,
});

app.use(express.json());

app.get('/portfolio', async (req: Request, res: Response) => {
  try {
    const result = await pool.query('SELECT * FROM portfolio');
    res.json(result.rows);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.post('/portfolio', async (req: Request, res: Response) => {
  try {
    const { symbol, quantity, current_value } = req.body;
    await pool.query(
      'INSERT INTO portfolio (symbol, quantity, current_value) VALUES ($1, $2, $3)',
      [symbol, quantity, current_value]
    );
    res.sendStatus(201);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

app.delete('/portfolio/:symbol', async (req: Request, res: Response) => {
  try {
    const { symbol } = req.params;
    await pool.query('DELETE FROM portfolio WHERE symbol = $1', [symbol]);
    res.sendStatus(200);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
