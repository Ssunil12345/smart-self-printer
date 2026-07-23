# Smart Self Printer

Self-service print ordering application built with Flutter. Users can upload documents, select print options, and complete payments through the app.

## Features

- **File Upload** — Upload documents (PDF, DOC, DOCX, PPT, images, etc.) via file picker
- **Print Options** — Select color mode (B&W/Color), page range (All/Custom), and number of copies
- **Price Calculation** — Live price preview based on pages, copies, and color mode (₹3/page B&W, ₹10/page Color)
- **Order Preview** — Review order summary before proceeding
- **Payment** — Select payment method and confirm payment
- **Order History** — View past orders stored locally
- **Dark Mode** — Toggle between light and dark themes

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `30-update.php` | POST | Upload file with print options |
| `31-update.php` | GET | Confirm payment (`?value=1` success, `?value=0` failure) |

### POST Parameters (30-update.php)

| Field | Type | Description |
|-------|------|-------------|
| `document` | File | The document to print |
| `pages` | String | Page selection (`"all"` or range like `"2"`, `"1-5,8"`) |
| `colour` | String | `"Color"` or `"Black & White"` |
| `counts` | String | Number of copies |

## Setup

1. Install [Flutter SDK](https://docs.flutter.dev/get-started/install)
2. Clone the repository
3. Run `flutter pub get`
4. Update API endpoints in `lib/core/network/api_endpoints.dart` as needed
5. Run `flutter run`

### Build

```sh
flutter build apk --release
```

## Project Structure

```
lib/
├── core/
│   ├── constants/       # App colors, strings, constants
│   ├── network/         # API client, endpoints, response models
│   └── utils/           # Helpers (price calc, order number, etc.)
├── models/              # Data models (print options, order, payment)
├── providers/           # State management (Provider)
├── routes/              # Route configuration
├── screens/             # UI screens
│   ├── dashboard/
│   ├── history/
│   ├── loading/
│   ├── login/
│   ├── payment/
│   ├── preview/
│   ├── print_options/
│   ├── settings/
│   ├── splash/
│   ├── success/
│   └── upload/
├── services/            # API services (upload, payment, auth, storage)
└── widgets/             # Reusable widgets
```

## Tech Stack

- **Framework:** Flutter
- **State Management:** Provider
- **Networking:** Dio
- **Local Storage:** Shared Preferences, Flutter Secure Storage
- **Animations:** Lottie, flutter_animate, animate_do
- **Responsive:** responsive_framework
