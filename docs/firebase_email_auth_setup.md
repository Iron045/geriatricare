# Thiết lập OTP email miễn phí cho bản demo

Ứng dụng dùng máy chủ Node.js chạy trên máy tính và Gmail SMTP. Không cần Firebase
Cloud Functions, Secret Manager hoặc gói Blaze.

## 1. Chuẩn bị Gmail

1. Bật xác minh 2 bước cho tài khoản Google.
2. Mở trang **Mật khẩu ứng dụng** và tạo một mật khẩu mới.
3. Không đưa mật khẩu ứng dụng vào mã Flutter, Git hoặc ảnh chụp công khai.

## 2. Cấu hình máy chủ

Trước tiên tải khóa Firebase Admin:

1. Mở Firebase Console và chọn dự án `geriatriccare-2477d`.
2. Chọn **Project settings** → **Service accounts**.
3. Chọn **Generate new private key** và xác nhận tải xuống.
4. Đổi tên file thành `service-account.json` rồi đặt vào thư mục `otp_server`.

File khóa này cho phép server kiểm tra email đã tồn tại trong Firebase Authentication.
Không chia sẻ file, không đưa lên Git; `.gitignore` đã loại trừ file này.

Mở PowerShell tại thư mục dự án:

```powershell
cd D:\Android\Project\Geriatriccare\otp_server
Copy-Item .env.example .env
notepad .env
```

Điền `.env` như sau (dùng App Password mới, có thể nhập có hoặc không có dấu cách):

```dotenv
PORT=3000
SMTP_HOST=smtp.gmail.com
SMTP_PORT=465
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-new-app-password
SMTP_FROM=GeriatricCare <your-email@gmail.com>
FIREBASE_SERVICE_ACCOUNT=service-account.json
```

Không gửi nội dung `.env` cho người khác. File này đã được `.gitignore` loại trừ.

## 3. Cài và chạy máy chủ

```powershell
cd D:\Android\Project\Geriatriccare\otp_server
npm install
npm run check
npm start
```

Giữ cửa sổ này mở trong lúc demo. Kiểm tra bằng trình duyệt:

```text
http://localhost:3000/health
```

Kết quả đúng có `"ok":true`.

## 4. Chạy ứng dụng

### Điện thoại thật dùng URL mặc định

Ứng dụng hiện mặc định kết nối tới máy tính tại `http://192.168.1.12:3000`:

```powershell
cd D:\Android\Project\Geriatriccare
flutter run
```

Nếu IPv4 của máy tính thay đổi, dùng `--dart-define` để ghi đè như hướng dẫn bên
dưới hoặc cập nhật `defaultValue` trong `auth_repository_impl.dart`.

### Android Emulator

Máy ảo Android cần ghi đè URL thành `http://10.0.2.2:3000`:

```powershell
cd D:\Android\Project\Geriatriccare
flutter run --dart-define=OTP_SERVER_URL=http://10.0.2.2:3000
```

### Điện thoại thật

Điện thoại và máy tính phải cùng Wi-Fi. Lấy IPv4 của máy tính bằng `ipconfig`, ví
dụ `192.168.1.20`, sau đó chạy:

```powershell
flutter run --dart-define=OTP_SERVER_URL=http://192.168.1.20:3000
```

Nếu không kết nối được, cho phép Node.js qua Windows Firewall trên mạng Private và
kiểm tra điện thoại có mở được `http://192.168.1.20:3000/health` hay không.

## 5. Cơ chế OTP

- Sinh ngẫu nhiên đủ 6 chữ số bằng `crypto.randomInt`.
- Chỉ lưu bản băm OTP trong RAM của máy chủ.
- Hết hạn sau 10 phút, tối đa 5 lần nhập sai.
- Chỉ dùng một lần; gửi lại sau 60 giây sẽ tạo mã mới.
- Khởi động lại server sẽ xóa toàn bộ OTP đang chờ.

Sau khi OTP đúng, Flutter tạo tài khoản Firebase Email/Password và lưu hồ sơ
Firestore. Đây là kiến trúc dành cho demo nội bộ; không dùng cho sản phẩm công khai.

## 6. Lỗi thường gặp

- `Invalid login`: sai email/App Password hoặc chưa bật xác minh 2 bước.
- `Connection refused`: server chưa chạy hoặc URL/IP không đúng.
- Email vào Spam: đánh dấu thư là không phải spam rồi thử lại sau 60 giây.
- `permission-denied`: cần triển khai Firestore Rules phù hợp của dự án.
