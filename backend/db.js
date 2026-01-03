const mysql = require('mysql2/promise');
require('dotenv').config();

const pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASS || '',
    database: process.env.DB_NAME || 'mindful_load',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// Check connection
pool.getConnection()
    .then(conn => {
        console.log("✅ Successfully connected to MySQL Database!");
        conn.release();
    })
    .catch(err => {
        console.error("❌ Database connection failed:", err.message);
        console.error("Please make sure MySQL is running and database 'mindful_load' exists.");
    });

module.exports = pool;
