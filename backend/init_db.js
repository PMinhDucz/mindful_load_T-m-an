const pool = require('./db');

async function initDB() {
  try {
    console.log("Initializing Database Tables...");

    // 1. Users Table
    await pool.query(`
      CREATE TABLE IF NOT EXISTS users (
        id INT AUTO_INCREMENT PRIMARY KEY,
        username VARCHAR(255) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL,
        full_name VARCHAR(255)
      ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    `);

    // 2. Activity Logs Table
    // Added user_id column
    await pool.query(`
      CREATE TABLE IF NOT EXISTS activity_logs (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT,
        mood VARCHAR(50) NOT NULL,
        note TEXT,
        tags JSON, 
        timestamp DATETIME NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      ) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    `);

    // Migration helper: Attempt to add user_id if missing (for existing table)
    try {
      await pool.query("ALTER TABLE activity_logs ADD COLUMN user_id INT;");
      await pool.query("ALTER TABLE activity_logs ADD FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;");
      console.log("ℹ️ Migrated 'activity_logs' adding user_id.");
    } catch (e) {
      // Ignore if column exists
    }

    console.log("✅ Database initialized successfully.");
    process.exit(0);
  } catch (err) {
    console.error("❌ Error initializing database:", err);
    process.exit(1);
  }
}

initDB();
