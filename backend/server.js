const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();
const db = require('./db');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(bodyParser.json());

// --- 1. AUTHENTICATION ROUTES ---
const bcrypt = require('bcryptjs');

// REGISTER
app.post('/api/auth/register', async (req, res) => {
    const { username, password, fullName } = req.body;

    // 1. Validation Logic
    if (!username || !password || !fullName) {
        return res.status(400).json({ error: 'Vui lòng điền đầy đủ: Tên, Email và Mật khẩu.' });
    }

    // Validate Full Name
    if (fullName.trim().length < 2) {
        return res.status(400).json({ error: 'Họ tên phải từ 2 ký tự trở lên.' });
    }

    // Validate Username (Accepts Email format or Alphanumeric)
    // Allowed: letters, numbers, underscores, dots, @, hyphens
    const usernameRegex = /^[a-zA-Z0-9_@.-]{3,50}$/;
    if (!usernameRegex.test(username)) {
        return res.status(400).json({ error: 'Email/Username không hợp lệ (Không chứa ký tự đặc biệt ngoài @ . _ -).' });
    }

    if (password.length < 6) {
        return res.status(400).json({ error: 'Mật khẩu phải từ 6 ký tự trở lên.' });
    }

    try {
        // 2. Check duplicates
        const [existing] = await db.query('SELECT id FROM users WHERE username = ?', [username]);
        if (existing.length > 0) {
            return res.status(409).json({ error: 'Username này đã tồn tại.' });
        }

        // 3. Hash Password (SECURITY UPGRADE)
        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(password, salt);

        // 4. Insert User
        const [result] = await db.query(
            'INSERT INTO users (username, password, full_name) VALUES (?, ?, ?)',
            [username, hashedPassword, fullName || '']
        );

        res.status(201).json({
            success: true,
            userId: result.insertId,
            message: 'Đăng ký thành công!'
        });

    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Lỗi server khi đăng ký.' });
    }
});

// LOGIN
app.post('/api/auth/login', async (req, res) => {
    const { username, password } = req.body;

    if (!username || !password) {
        return res.status(400).json({ error: 'Thiếu thông tin đăng nhập.' });
    }

    try {
        // 1. Find User by Username
        const [users] = await db.query('SELECT * FROM users WHERE username = ?', [username]);

        if (users.length === 0) {
            return res.status(401).json({ error: 'Sai tên đăng nhập hoặc mật khẩu.' });
        }

        const user = users[0];

        // 2. Compare Password (bcrypt)
        const isMatch = await bcrypt.compare(password, user.password);

        if (!isMatch) {
            return res.status(401).json({ error: 'Sai tên đăng nhập hoặc mật khẩu.' });
        }

        // 3. Success
        console.log(`[LOGIN SUCCESS] User: ${user.username}`);
        return res.json({
            success: true,
            user: {
                id: user.id,
                username: user.username,
                fullName: user.full_name
            },
            token: "mock-jwt-token-" + user.id // In real app, use jsonwebtoken here
        });

    } catch (err) {
        console.error('[LOGIN ERROR]', err);
        res.status(500).json({ error: 'Lỗi server khi đăng nhập.' });
    }
});


// --- 2. ACTIVITY LOG ROUTES (Protected) ---

// Middleware to simulate Auth check (using header x-user-id)
const requireAuth = (req, res, next) => {
    const userId = req.headers['x-user-id'];
    if (!userId) {
        return res.status(401).json({ error: 'Unauthorized: Bạn chưa đăng nhập.' });
    }
    req.userId = userId;
    next();
};

app.get('/api/logs', requireAuth, async (req, res) => {
    try {
        // FR2.1: Dashboard displays chart for "the current calendar week" (Mon-Sun).
        // YEARWEEK(date, 1) uses Monday as the first day of the week.
        const [rows] = await db.query(
            'SELECT * FROM activity_logs WHERE user_id = ? AND YEARWEEK(timestamp, 1) = YEARWEEK(NOW(), 1) ORDER BY timestamp DESC',
            [req.userId]
        );
        res.json(rows);
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Database error' });
    }
});

app.post('/api/logs', requireAuth, async (req, res) => {
    const { mood, tags, note, timestamp } = req.body;
    if (!mood) return res.status(400).json({ error: 'Mood is required' });

    // Fix Timezone: Use client string directly if available (strip T), else local server time
    let jsTimestamp;
    if (timestamp) {
        jsTimestamp = timestamp.replace('T', ' ').slice(0, 19);
    } else {
        const now = new Date();
        const offset = now.getTimezoneOffset() * 60000;
        jsTimestamp = new Date(now - offset).toISOString().replace('T', ' ').slice(0, 19);
    }

    const tagsJson = JSON.stringify(tags || []);

    try {
        const [result] = await db.query(
            'INSERT INTO activity_logs (user_id, mood, tags, note, timestamp) VALUES (?, ?, ?, ?, ?)',
            [req.userId, mood, tagsJson, note || null, jsTimestamp]
        );

        res.status(201).json({ id: result.insertId, mood, tags, note, timestamp });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Failed to save log' });
    }
});

app.delete('/api/logs/:id', requireAuth, async (req, res) => {
    const { id } = req.params;
    try {
        // Only delete if belongs to user
        await db.query('DELETE FROM activity_logs WHERE id = ? AND user_id = ?', [id, req.userId]);
        res.json({ success: true, id });
    } catch (err) {
        res.status(500).json({ error: 'Delete failed' });
    }
});

app.delete('/api/cleanup', requireAuth, async (req, res) => {
    try {
        await db.query('DELETE FROM activity_logs WHERE user_id = ?', [req.userId]);
        res.json({ success: true });
    } catch (err) {
        res.status(500).json({ error: 'Cleanup failed' });
    }
});

// --- 3. AI ANALYSIS ROUTE (Local Statistical Engine) ---
// NFR1: On-device/Local processing only. No data sent to 3rd party APIs.
app.get('/api/analyze', requireAuth, async (req, res) => {
    try {
        // 1. Fetch User Logs (Last 100 entries for better statistics)
        const [rows] = await db.query('SELECT mood, tags, timestamp FROM activity_logs WHERE user_id = ? ORDER BY timestamp DESC LIMIT 100', [req.userId]);

        if (rows.length < 5) {
            return res.json({ insights: ["💡 Hãy check-in ít nhất 5 lần để 'Tâm An' tìm ra quy luật của bạn nhé!"] });
        }

        const insights = [];
        const totalLogs = rows.length;

        // --- Helper: Parse Tags & Map Moods (English -> Vietnamese) ---
        // Backend DB stores Mood as ENUM/String from Flutter (e.g. "stress", "good")
        // But AI logic expects Vietnamese (e.g. "Căng thẳng", "Vui") matches from FRs.

        const moodMap = {
            'good': 'Vui',
            'happy': 'Hạnh phúc', // just in case
            'neutral': 'Bình thường',
            'sad': 'Buồn',
            'angry': 'Giận dữ',
            'anxious': 'Lo lắng',
            'stress': 'Căng thẳng'
        };

        const data = rows.map(r => {
            let parsedTags = [];
            try { parsedTags = JSON.parse(r.tags); } catch (e) { }

            // Map mood to Vietnamese or keep original if not found
            const viMood = moodMap[r.mood] || r.mood;

            return { ...r, mood: viMood, parsedTags };
        });

        // --- Analysis 1: General Mood Breakdown ---
        const moodCounts = {};
        data.forEach(r => {
            moodCounts[r.mood] = (moodCounts[r.mood] || 0) + 1;
        });

        // Find dominant mood
        let domMood = '';
        let domCount = 0;
        for (const [m, c] of Object.entries(moodCounts)) {
            if (c > domCount) {
                domCount = c;
                domMood = m;
            }
        }
        const domPercent = Math.round((domCount / totalLogs) * 100);
        insights.push(`📊 Cảm xúc chủ đạo tuần này của bạn là '${domMood}' (chiếm ${domPercent}%).`);

        // --- Analysis 2: Tag Correlation (The "Detective" Logic) ---
        // We look for tags that trigger negative moods (Căng thẳng, Lo lắng, Buồn, Giận dữ)
        const negativeMoods = ['Căng thẳng', 'Lo lắng', 'Buồn', 'Giận dữ', 'Mệt mỏi'];
        const tagMap = {};

        data.forEach(r => {
            if (Array.isArray(r.parsedTags)) {
                r.parsedTags.forEach(tag => {
                    if (!tagMap[tag]) tagMap[tag] = { total: 0, negative: 0, moods: {} };
                    tagMap[tag].total++;
                    tagMap[tag].moods[r.mood] = (tagMap[tag].moods[r.mood] || 0) + 1;
                    if (negativeMoods.includes(r.mood)) {
                        tagMap[tag].negative++;
                    }
                });
            }
        });

        // Find "Stress Triggers"
        let foundTrigger = false;
        for (const [tag, stat] of Object.entries(tagMap)) {
            if (stat.total >= 3) { // Minimum sample size for a tag
                const negRatio = stat.negative / stat.total;
                if (negRatio >= 0.70) { // 70% threshold
                    // Find the most frequent negative mood for this tag
                    let topMood = '';
                    let topCount = 0;
                    for (const [m, c] of Object.entries(stat.moods)) {
                        if (negativeMoods.includes(m) && c > topCount) {
                            topCount = c;
                            topMood = m;
                        }
                    }
                    const percent = Math.round(negRatio * 100);
                    // SRS FR2.2 Suggestion 1 format
                    insights.push(`🔍 Tâm An nhận thấy: ${percent}% các lần bạn check-in '${topMood}' đều liên quan đến tag [${tag}].`);
                    foundTrigger = true;
                }
            }
        }

        // --- Analysis 3: Positive Correlation ---
        // Look for tags that boost "Vui", "Hạnh phúc", "Bình thường"
        const positiveMoods = ['Vui', 'Hạnh phúc', 'Phấn khích', 'Bình thường'];
        for (const [tag, stat] of Object.entries(tagMap)) {
            if (stat.total >= 3) {
                let posCount = 0;
                positiveMoods.forEach(m => posCount += (stat.moods[m] || 0));

                if (posCount / stat.total >= 0.80) {
                    insights.push(`✨ Tip: Bạn có vẻ rất tích cực khi [${tag}]. Hãy dành nhiều thời gian hơn cho việc này!`);
                }
            }
        }

        // --- Analysis 4: Time & Day Patterns (The "Sherlock" Logic) ---
        // Bucket data: { "Mon-Afternoon": { total: 0, negative: 0, topMood: '' } }
        const timeMap = {};
        const periods = ['Sáng', 'Chiều', 'Tối', 'Đêm']; // 6-12, 12-18, 18-24, 0-6

        data.forEach(r => {
            const date = new Date(r.timestamp);
            const day = date.toLocaleDateString('vi-VN', { weekday: 'long' }); // Thứ Hai
            const hour = date.getHours();

            let period = 'Đêm';
            if (hour >= 6 && hour < 12) period = 'Sáng';
            else if (hour >= 12 && hour < 18) period = 'Chiều';
            else if (hour >= 18) period = 'Tối';

            const key = `${day} ${period}`; // e.g., "Thứ Hai Chiều"

            if (!timeMap[key]) timeMap[key] = { total: 0, counts: {} };
            timeMap[key].total++;
            timeMap[key].counts[r.mood] = (timeMap[key].counts[r.mood] || 0) + 1;
        });

        // Analyze Buckets
        for (const [key, stat] of Object.entries(timeMap)) {
            if (stat.total >= 3) { // Min 3 logs in this timeframe
                // Find top mood in this bucket
                let topMood = '';
                let topCount = 0;
                for (const [m, c] of Object.entries(stat.counts)) {
                    if (c > topCount) {
                        topCount = c;
                        topMood = m;
                    }
                }

                const ratio = topCount / stat.total;
                if (ratio >= 0.65) { // 65% consistency
                    insights.push(`🕵️ Thám tử AI: Vào ${key}, bạn thường cảm thấy '${topMood}' (${Math.round(ratio * 100)}%).`);
                }
            }
        }

        if (insights.length < 3) {
            insights.push("💡 Hãy check-in thường xuyên hơn để AI học được thói quen của bạn nhé.");
        }

        res.json({ insights });

    } catch (err) {
        console.error("Analysis Error:", err);
        res.json({ insights: ["❌ Lỗi khi phân tích dữ liệu cục bộ."] });
    }
});

app.listen(PORT, () => {
    console.log(`🚀 MySQL Backend (Auth Enabled) running on port ${PORT}`);
});
