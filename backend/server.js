const express = require("express");
const { Pool } = require("pg");
const cors = require("cors");

const app = express();
app.use(cors());
app.use(express.json());

// --- Connexion PostgreSQL via variables d'environnement ---
const pool = new Pool({
  host: process.env.DB_HOST || "localhost",
  port: parseInt(process.env.DB_PORT || "5432", 10),
  database: process.env.DB_NAME || "meteo_db",
  user: process.env.DB_USER || "meteo_user",
  password: process.env.DB_PASSWORD || "meteo_pass",
});

// --- GET /health — vérification du backend + connexion BDD ---
app.get("/health", async (_req, res) => {
  try {
    const result = await pool.query("SELECT NOW() AS time");
    res.json({
      status: "ok",
      service: "meteo-backend",
      database: "connected",
      server_time: result.rows[0].time,
    });
  } catch (err) {
    res.status(503).json({
      status: "error",
      service: "meteo-backend",
      database: "disconnected",
      error: err.message,
    });
  }
});

// --- GET /api/cities — liste toutes les villes enregistrées ---
app.get("/api/cities", async (_req, res) => {
  try {
    const result = await pool.query(
      "SELECT id, name, country, created_at FROM cities ORDER BY created_at DESC"
    );
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// --- POST /api/cities — ajouter une ville ---
app.post("/api/cities", async (req, res) => {
  const { name, country } = req.body;
  if (!name) {
    return res.status(400).json({ error: "Le champ 'name' est requis." });
  }
  try {
    const result = await pool.query(
      "INSERT INTO cities (name, country) VALUES ($1, $2) RETURNING id, name, country, created_at",
      [name.trim(), (country || "").trim()]
    );
    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// --- DELETE /api/cities/:id — supprimer une ville ---
app.delete("/api/cities/:id", async (req, res) => {
  try {
    await pool.query("DELETE FROM cities WHERE id = $1", [req.params.id]);
    res.json({ deleted: true });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// --- Démarrage ---
const PORT = process.env.PORT || 3000;
app.listen(PORT, "0.0.0.0", () => {
  console.log(`Backend listening on port ${PORT}`);
});
