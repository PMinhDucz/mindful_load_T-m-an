require('dotenv').config();
const mysql = require('mysql2/promise');

const dbConfig = {
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || '',
    database: process.env.DB_NAME || 'mindful_load',
    port: process.env.DB_PORT || 3306
};

async function resetDb() {
    let connection;
    try {
        console.log("🔥 Connecting to Database...");
        connection = await mysql.createConnection(dbConfig);

        console.log("💣 TRUNCATING activity_logs table...");
        await connection.query('TRUNCATE TABLE activity_logs');

        console.log("✅ SUCCESS: All logs have been deleted.");
        console.log("   The Chart will be perfectly clean now.");

    } catch (err) {
        console.error("❌ Error:", err);
    } finally {
        if (connection) await connection.end();
        process.exit();
    }
}

resetDb();
