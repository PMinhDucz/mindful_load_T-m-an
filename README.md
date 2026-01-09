# Tâm An (Mindful Load) - AI Journaling App

## 📖 Giới thiệu (Overview)
**Tâm An** là ứng dụng nhật ký cảm xúc thông minh, giúp người dùng theo dõi sức khỏe tinh thần, nhận diện các yếu tố gây căng thẳng (stress triggers) và đề xuất giải pháp cải thiện thông qua phân tích dữ liệu cục bộ.

**Tính năng nổi bật:**
*   ✍️ **Check-in cảm xúc**: Ghi lại tâm trạng, tag (ngữ cảnh, hoạt động, người đồng hành) và ghi chú.
*   📊 **Thống kê & Biểu đồ**: Theo dõi biến động cảm xúc theo tuần/tháng.
*   🤖 **AI Phân tích (Local)**: Hệ thống Rule-based Engine phân tích mối liên hệ giữa Tag và Mood để đưa ra cảnh báo (ví dụ: "Bạn thường stress khi gặp Deadline").
*   🔔 **Nhắc nhở thông minh**: Thông báo ngẫu nhiên nhắc check-in mà không gây nhàm chán.
*   🔒 **Privacy First**: Dữ liệu và phân tích AI chạy cục bộ hoặc trên server riêng, bảo mật tuyệt đối.

---

## 🛠️ Yêu cầu cài đặt (Prerequisites)

### 1. Phần mềm
*   **Flutter SDK**: >= 3.0.0
*   **Node.js**: >= 14.x
*   **MySQL Server**: (XAMPP hoặc MySQL Workbench)

### 2. Thiết bị
*   Android Emulator hặc Thiết bị thật (Android 10+ recommended for Notifications).

---

## 🚀 Hướng dẫn chạy dự án (Getting Started)

### Bước 1: Cấu hình Database & Backend
1.  Mở **MySQL** và tạo database mới tên `mindful_load`.
2.  Mở thư mục `backend/` trong terminal.
3.  Cài đặt thư viện:
    ```bash
    npm install
    ```
4.  Cấu hình file `.env` (nếu chưa có, tạo từ `.env.example`):
    ```env
    DB_HOST=localhost
    DB_USER=root
    DB_PASS=
    DB_NAME=mindful_load
    PORT=3000
    SECRET_KEY=my_super_secret_key_123
    ```
5.  Khởi tạo bảng dữ liệu (chạy 1 lần):
    ```bash
    node init_db.js
    ```
6.  Chạy server:
    ```bash
    node server.js
    ```
    > Server sẽ chạy tại: `http://localhost:3000`

### Bước 2: Chạy ứng dụng Flutter
1.  Mở thư mục gốc `mindful_load` (chứa file `pubspec.yaml`).
2.  Lấy các thư viện Dart:
    ```bash
    flutter pub get
    ```
3.  Chạy ứng dụng (trên máy ảo Android):
    ```bash
    flutter run
    ```
    *Lưu ý: Đối với máy ảo Android, App sẽ kết nối tới Backend qua IP `10.0.2.2`. Nếu chạy máy thật, vui lòng sửa IP trong `lib/controllers/auth_controller.dart` trùng với IP LAN của máy tính.*

---

## 🔐 Tài khoản Demo (Nếu có)
*   **Username**: `demo`
*   **Password**: `123456`
*(Hoặc bạn có thể đăng ký tài khoản mới ngay trên App)*

---

## 📂 Cấu trúc dự án
*   `lib/controllers/`: Xử lý Logic, gọi API (MVC Pattern).
*   `lib/models/`: Định nghĩa dữ liệu (ActivityLog, Mood...).
*   `lib/views/`: Giao diện người dùng (Screens, Widgets).
*   `lib/services/`: Các dịch vụ nền (NotificationService...).
*   `backend/`: Mã nguồn Node.js server và Database script.

---
**Made with ❤️ by [Your Name]**
