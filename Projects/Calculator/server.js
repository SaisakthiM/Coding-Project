const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');

const app = express();
const PORT = 5000;

// Enable CORS and JSON parsing
app.use(cors());
app.use(express.json());

// MySQL database connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',       // 🔁 replace with your MySQL username
    password: 'saisakthi@2008', // 🔁 replace with your MySQL password
    database: 'result'       // 🔁 replace with your DB name
});

// Connect to DB
db.connect(err => {
    if (err) {
        console.error('Database connection failed:', err);
        process.exit(1); // Exit if DB connection fails
    }
    console.log('MySQL connected');
});

// Create table if not exists
db.query(`
    CREATE TABLE IF NOT EXISTS history (
        id INT AUTO_INCREMENT PRIMARY KEY,
        expression TEXT NOT NULL,
        result TEXT NOT NULL
    )
`, (err) => {
    if (err) console.error("Table creation failed:", err.message);
});

// Route to add new history entry
app.post('/add', (req, res) => {
    const { expression, result } = req.body;
    if (!expression || !result) {
        return res.status(400).json({ error: "Expression and result are required" });
    }

    db.query(
        'INSERT INTO history (expression, result) VALUES (?, ?)',
        [expression, result],
        (err) => {
            if (err) {
                return res.status(500).json({ error: err.message });
            }
            res.json({ message: "Saved" });
        }
    );
});

// Route to fetch history
app.get('/history', (req, res) => {
    db.query(
        'SELECT expression, result FROM history ORDER BY id DESC LIMIT 10',
        (err, results) => {
            if (err) {
                return res.status(500).json({ error: err.message });
            }
            res.json(results);
        }
    );
});

// Start server
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
