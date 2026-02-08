-- Script d'initialisation PostgreSQL
-- Exécuté automatiquement au premier lancement du conteneur

CREATE TABLE IF NOT EXISTS cities (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(10) DEFAULT '',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Données de démonstration
INSERT INTO cities (name, country) VALUES
    ('Paris', 'FR'),
    ('Marseille', 'FR'),
    ('Lyon', 'FR');
