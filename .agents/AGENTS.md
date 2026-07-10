# General Project Rules (heathy_teacher)

## 1. Tiêu chuẩn Code (Coding Standards)
- Luôn sử dụng ngôn ngữ Dart phiên bản mới nhất với Null safety.
- Không sử dụng `var` hoặc `dynamic` trừ khi thực sự cần thiết, hãy định nghĩa kiểu dữ liệu rõ ràng.
- Đảm bảo logic nghiệp vụ được tách biệt khỏi UI. Cố gắng chia nhỏ các Widget thành các component tái sử dụng được.

## 2. Quy tắc đặt tên (Naming Conventions)
- Tên class, enum: `PascalCase` (ví dụ: `HomePage`, `UserRole`).
- Tên biến và hàm: `camelCase` (ví dụ: `getUserData()`, `isLoggedIn`).
- Tên file và thư mục: `snake_case` (ví dụ: `home_page.dart`, `user_profile`).

## 3. Workflow & Hành vi của AI
- Trước khi thêm một package mới vào `pubspec.yaml`, phải thông báo và xin ý kiến người dùng.
- Luôn giữ lại các comment và docstring có sẵn trong code cũ để bảo toàn tài liệu dự án.
- Ưu tiên sử dụng hằng số (`const`) trong cấu trúc Widget Tree của Flutter để tối ưu hóa hiệu năng render.
