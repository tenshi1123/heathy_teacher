---
name: Tạo màn hình Flutter mới
description: Sử dụng kỹ năng này khi người dùng yêu cầu tạo một màn hình (screen) hoặc trang (page) mới trong dự án.
---

# Hướng dẫn tạo màn hình (Screen Workflow)

Khi được yêu cầu tạo một màn hình mới, hãy thực hiện tuần tự các bước sau:

1. **Xác định vị trí:** Màn hình mới nên được tạo trong thư mục tương ứng theo tính năng, ví dụ: `lib/screens/<tên_tính_năng>/<tên_màn_hình>_screen.dart`.
2. **Khởi tạo file UI:** 
   - Dựa vào template được cung cấp trong thư mục `templates/screen_template.dart` để tạo cấu trúc giao diện cơ bản.
   - Luôn sử dụng `const` ở những widget không thay đổi trạng thái.
3. **Quản lý trạng thái:** Nếu màn hình cần quản lý dữ liệu động, hãy tạo thêm các class tương ứng (BLoC, Controller, ViewModel...) tùy thuộc vào cấu trúc dự án.
4. **Kiểm tra tổng quan:** Đảm bảo code không có cảnh báo (lint warning) trước khi hoàn tất.
