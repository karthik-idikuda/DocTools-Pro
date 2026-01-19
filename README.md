# DocTools Pro 📄

A powerful, offline-first PDF and DOCX document utility app built with Flutter.

## Features

- 📱 **Cross-Platform**: Works on iOS, Android, Web, Windows, macOS, and Linux
- 🔒 **Offline-First**: All document processing happens locally
- 📄 **PDF Tools**: View, manipulate, and create PDF documents
- 📝 **OCR Scanning**: Camera-based document scanning with text recognition
- 🔐 **Secure Auth**: Firebase authentication with Google Sign-In
- ☁️ **Cloud Sync**: Optional Firebase integration for cloud backup

## Tech Stack

- **Framework**: Flutter (SDK ≥3.2.0)
- **State Management**: Provider
- **Database**: SQLite (local), Firebase Firestore (cloud)
- **PDF Processing**: Syncfusion Flutter PDF, PDFX
- **ML/OCR**: Google ML Kit Text Recognition
- **Authentication**: Firebase Auth + Google Sign-In

## Getting Started

### Prerequisites

- Flutter SDK (≥3.2.0)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Firebase project (for cloud features)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Nytrynox/DocTools-Pro.git
   cd DocTools-Pro
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Firebase Setup (Optional)

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add your app platforms (iOS, Android, Web)
3. Download and add configuration files
4. Enable Authentication and Firestore

## Project Structure

```
lib/
├── main.dart              # App entry point
├── models/               # Data models
├── screens/              # UI screens
├── services/             # Business logic
├── widgets/              # Reusable components
└── utils/                # Helper utilities
```

## Dependencies

| Package | Purpose |
|---------|---------|
| `provider` | State management |
| `sqflite` | Local database |
| `syncfusion_flutter_pdf` | PDF manipulation |
| `pdfx` | PDF viewing |
| `google_mlkit_text_recognition` | OCR |
| `firebase_core` | Firebase integration |
| `file_picker` | Document import |
| `share_plus` | Document sharing |

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Karthik Idikuda** - [@Nytrynox](https://github.com/Nytrynox)
