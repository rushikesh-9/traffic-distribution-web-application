const path = require("path");
const express = require("express");
const sqlite3 = require("sqlite3").verbose();

const app = express();
const PORT = process.env.PORT || 3001;
const publicDir = path.join(__dirname);
const dbPath = path.join(__dirname, "bookings.db");

const db = new sqlite3.Database(dbPath, (err) => {
  if (err) {
    console.error("Database connection failed:", err.message);
    process.exit(1);
  }
  console.log("Connected to SQLite database.");
});

db.run(
  `CREATE TABLE IF NOT EXISTS bookings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    mobile TEXT NOT NULL,
    email TEXT NOT NULL,
    passengers INTEGER NOT NULL,
    source TEXT NOT NULL,
    destination TEXT NOT NULL,
    travel_date TEXT NOT NULL,
    booked_at TEXT NOT NULL
  )`
);

app.use(express.json());
app.use(express.static(publicDir));

app.post("/api/bookings", (req, res) => {
  const { name, mobile, email, passengers, from, destination, date } = req.body;

  if (!name || !mobile || !email || !passengers || !from || !destination || !date) {
    return res.status(400).json({ error: "All fields are required." });
  }

  const bookedAt = new Date().toISOString();
  const sql = `
    INSERT INTO bookings (name, mobile, email, passengers, source, destination, travel_date, booked_at)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?)
  `;
  const params = [name, mobile, email, passengers, from, destination, date, bookedAt];

  db.run(sql, params, function onInsert(err) {
    if (err) {
      return res.status(500).json({ error: "Failed to save booking." });
    }

    res.json({
      message: "Booking saved successfully.",
      bookingId: this.lastID,
    });
  });
});

app.get("/api/bookings", (req, res) => {
  const sql = `
    SELECT id, name, mobile, email, passengers, source, destination, travel_date, booked_at
    FROM bookings
    ORDER BY id DESC
  `;

  db.all(sql, [], (err, rows) => {
    if (err) {
      return res.status(500).json({ error: "Failed to fetch bookings." });
    }
    res.json(rows);
  });
});

app.get("/api/bookings/:id", (req, res) => {
  const sql = `
    SELECT id, name, mobile, email, passengers, source, destination, travel_date, booked_at
    FROM bookings
    WHERE id = ?
  `;

  db.get(sql, [req.params.id], (err, row) => {
    if (err) {
      return res.status(500).json({ error: "Failed to fetch booking." });
    }
    if (!row) {
      return res.status(404).json({ error: "Booking not found." });
    }
    res.json(row);
  });
});

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
  console.log(`Open http://localhost:${PORT}/booking-db.html`);
  console.log(`Open http://localhost:${PORT}/admin-bookings.html for all bookings`);
});



