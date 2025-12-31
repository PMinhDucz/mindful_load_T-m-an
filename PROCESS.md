# QUẢN LÝ TIẾN ĐỘ & QUY TRÌNH LÀM VIỆC NHÓM
## I. THÔNG TIN HÀNH CHÍNH
*   **Tên đề tài:** Xây dựng ứng dụng Trợ lý Sức khỏe Tinh thần & Nhận diện Căng thẳng "Tâm An" (Mindful Load).
*   **Nhóm số:** ...
*   **Thành viên:**
    1.  Phạm Minh Đức (Leader/Dev) - MSSV: 2251172292
    2.  Nguyễn Phúc Bình An (Dev) - Rút lui
*   **Link Figma:** [Figma Design](https://www.figma.com/design/sNNdycc3pggrTm52k81zcr/Tam_an_app?node-id=2-2&p=f&t=VtfhlH95xjHJTsjP-0)
*   **Link Git:** [Github Repository](https://github.com/PMinhDucz/mindful_load_T-m-an.git)

## II. TÌNH TRẠNG HIỆN TẠI (TUẦN 4 - SNAPSHOT)
### 1. Công nghệ (Tech Stack)
*   **Kiến trúc:** [x] MVC
*   **State Management:** [x] Provider
*   **Backend:** [x] REST API (Node/Java...)
*   **Lưu ý:** Hiện tại source code đang ở trạng thái scaffold (khung sườn), chưa có logic.

### 2. Trạng thái UI (Figma to Flutter)
*   [x] Màn hình Login/Register (Đã xong - theo báo cáo, cần kiểm tra thực tế)
*   [ ] Màn hình Home Dashboard (Đang làm 50%)
*   [ ] Màn hình Phân tích AI (Chưa làm)
*   [ ] Màn hình Settings (Chưa làm)

### 3. Đánh giá chung
*   Tiến độ: **Chậm (Sắp báo động)**
*   Nhân sự: Chỉ còn 1 người (Phạm Minh Đức) cân toàn bộ dự án -> Khối lượng công việc RẤT LỚN.

## III. KẾ HOẠCH VỀ ĐÍCH (TUẦN 5 - TUẦN 8)

| Tuần | Mục tiêu (Milestone) | Tasks cụ thể | Người phụ trách |
| :--- | :--- | :--- | :--- |
| **TUẦN 5** | **Logic UI & Navigation** | - Hoàn tất 100% UI code.<br>- Xử lý luồng đi (Routing).<br>- Validate Form. | Phạm Minh Đức |
| **TUẦN 6** | **Tích hợp Backend/API** | - Kết nối Database.<br>- Chức năng Auth.<br>- Hiển thị List View. | Phạm Minh Đức |
| **TUẦN 7** | **Xử lý Nghiệp vụ & CRUD** | - Thêm/Sửa/Xóa dữ liệu.<br>- Tính năng nâng cao (Map, Chart...). | Phạm Minh Đức |
| **TUẦN 8** | **Testing & Đóng gói** | - Fix bug.<br>- Build APK/IPA.<br>- Viết báo cáo. | Phạm Minh Đức |

## IV. QUY TRÌNH GIT & QUẢN LÝ TASK
### 1. Git Workflow
*   **Nhánh chính:** `main` (Production)
*   **Nhánh phát triển:** `dev` (Development)
*   **Nhánh tính năng:** `feature/ten-tinh-nang`
*   **Quy tắc:** Code trên `feature` -> PR vào `dev` -> Ổn định mới PR vào `main`.

### 2. Quản lý Task
*   **Công cụ:** Notion
*   **Nguyên tắc:** Cập nhật Real-time. Deadline trước họp 12-24h.

## V. KHÓ KHĂN HIỆN TẠI
*   **Vẽ biểu đồ:** Chưa có kinh nghiệm với `fl_chart`.
*   **Nhân sự:** Thiếu người.
