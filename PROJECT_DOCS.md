# Dự án: "Tâm An" (Mindful Load) – Trợ lý Nhận diện Tác nhân Gây căng thẳng

## 1. Tổng quan Dự án (Project Overview)
"Tâm An" là một ứng dụng "nhật ký cảm xúc" thông minh, được thiết kế để giúp người dùng tìm ra nguồn gốc của sự căng thẳng. Không giống như các app "thiền" (meditation) giải quyết triệu chứng, "Tâm An" tập trung vào việc chẩn đoán nguyên nhân.

Ứng dụng này hoạt động như một "thám tử" sức khỏe tinh thần. Bằng cách cho phép người dùng ghi lại cảm xúc (check-in) một cách nhanh chóng trong ngày, ứng dụng sẽ sử dụng AI để phân tích và tìm ra các mô thức (patterns): "Bạn thường cảm thấy 'Căng thẳng' vào lúc 4 giờ chiều ngày thứ Hai" hoặc "Những ngày bạn ngủ ít hơn 6 tiếng, mức độ lo lắng của bạn tăng 50%".

## 2. Bối cảnh & Vấn đề (Business Problem & Context)
**Hiện trạng (Current State):** Stress là một "kẻ giết người thầm lặng".
1. **Cảm xúc Mơ hồ:** Người dùng thường chỉ có một cảm giác chung chung là "mệt mỏi", "buồn", hoặc "căng thẳng".
2. **Thiếu Dữ liệu Khách quan:** Không có dữ liệu, không thể cải thiện.
3. **Check-in Rườm rà:** Các app nhật ký hiện tại đòi hỏi người dùng phải viết rất nhiều.

**Cơ hội (Opportunity):** Xây dựng một công cụ check-in ma sát thấp (low-friction) chỉ mất 5 giây, nhưng lại cung cấp một báo cáo phân tích sâu sắc (high-insight) vào cuối tuần.

## 3. Đối tượng Người dùng (Target Audience)
**Chân dung người dùng:** "Người đi làm Cảm thấy Quá tải"
*   **Mô tả:** Nhân viên văn phòng, sinh viên.
*   **Nhu cầu:** Muốn hiểu rõ bản thân hơn, tìm ra "thủ phạm" gây stress.

## 4. Yêu cầu Chức năng (Functional Requirements - FRs)

### FR1: Module "Check-in Cảm xúc 5 Giây" (5-Second Check-in)
*   **FR1.1: Giao diện Tối giản:** Hỏi "Bạn đang cảm thấy thế nào?".
*   **FR1.2: Lựa chọn Cảm xúc:** Hiển thị 5-7 biểu tượng (Vui, Hạnh phúc, Bình thường, Buồn, Lo lắng, Căng thẳng, Giận dữ).
*   **FR1.3: Thêm "Tác nhân" (Tags):**
    *   Đang ở đâu? (Công ty, Nhà...)
    *   Đang làm gì? (Họp, Code...)
    *   Đang với ai? (Đồng nghiệp, Gia đình...)
*   **FR1.4: Lời nhắc Ngẫu nhiên:** Thông báo nhắc check-in 3 lần/ngày.

### FR2: Module "Tương quan & Phân tích" (AI Correlation Engine)
*   **FR2.1: Bảng điều khiển (Dashboard):** Biểu đồ cảm xúc trong tuần.
*   **FR2.2: Phân tích Tác nhân (AI Insight):** Tìm tương quan (Vd: Stress khi Họp).
*   **FR2.3: Tích hợp Dữ liệu Sức khỏe (Tùy chọn):** Google Fit/Apple Health.

### FR3: Module "Nhật ký Vi mô" (Micro-Journal)
*   **FR3.1: Ghi chú Tùy chọn:** Viết 1-2 câu kèm theo.
*   **FR3.2: Tra cứu Lịch sử:** Xem lại lịch sử cảm xúc.

## 5. Yêu cầu Phi chức năng (Non-Functional Requirements - NFRs)
*   **NFR1: Quyền riêng tư (Privacy):** Dữ liệu mã hóa, ưu tiên on-device.
*   **NFR2: Trải nghiệm Người dùng (UX):** Check-in < 10 giây.
*   **NFR3: Tính cá nhân hóa:** Cho phép thêm tag tùy ý.

## 6. Ràng buộc & Giả định
*   Đây là bài tập cuối kì môn Flutter.
*   Giả định người dùng sẵn lòng check-in.
