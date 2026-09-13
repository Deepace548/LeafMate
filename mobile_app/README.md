# LeafMate

A beautiful Flutter plant care application that helps you manage your plant collection, track watering schedules, and discover new plants.

## Features

### 🔐 Authentication
- **Email/Password Login** - Traditional authentication with validation
- **Google Sign-In** - OAuth integration with Firebase
- **Facebook Sign-In** - Social login with Facebook Auth
- **Registration** - New user account creation

### 🌱 Plant Management
- **Add Plants** - Add plants from catalog or search external database
- **Edit Plants** - Modify existing plant details
- **Delete Plants** - Remove plants with confirmation
- **Plant Details** - View comprehensive plant information including:
  - Light requirements
  - Watering schedule
  - Humidity needs
  - Care tips and overview

### 🔔 Notifications
- **Watering Reminders** - Schedule push notifications for plant watering
- **Date/Time Picker** - Custom reminder scheduling
- **Automatic Cancellation** - Reminders cancelled when plant is deleted

### 🔍 Plant Database
- **External API Integration** - Search plants from Perenual API
- **Real Plant Data** - Access accurate care information
- **Visual Search Results** - Horizontal scrollable plant cards with images

### 👤 Profile
- **User Profile** - Modern profile screen with avatar
- **Stats Dashboard** - Track plant count and reminders
- **Settings Menu** - Access app settings and preferences
- **Help & Support** - In-app support resources

### 🎨 Design
- **Theme Consistent** - Beautiful green color scheme (#286B47)
- **Modern UI** - Rounded corners, subtle shadows, gradients
- **Responsive** - Works on various screen sizes
- **Bottom Navigation** - Easy access to Home, History, and Profile tabs

## Tech Stack

- **Framework**: Flutter 3.10.1+
- **Language**: Dart
- **State Management**: Provider
- **Authentication**: Firebase Auth, Google Sign-In, Facebook Auth
- **Local Storage**: SharedPreferences
- **Notifications**: flutter_local_notifications
- **HTTP**: http package
- **Fonts**: Google Fonts (Poppins)

## Installation

### Prerequisites
- Flutter SDK 3.10.1 or higher
- Dart SDK compatible with Flutter version
- Android Studio / Xcode for mobile development
- Firebase account

### Setup Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd mobile_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Configuration**
   
   a. Create a Firebase project at https://console.firebase.google.com/
   
   b. Add Android app:
   - Package name: `com.example.mobile_app`
   - Download `google-services.json`
   - Place in `android/app/`
   
   c. Add iOS app:
   - Bundle ID: `com.example.mobile_app`
   - Download `GoogleService-Info.plist`
   - Place in `ios/Runner/`
   
   d. Enable Authentication:
   - Go to Firebase Console → Authentication
   - Enable Email/Password
   - Enable Google Sign-In
   - Enable Facebook Sign-In

4. **Facebook App Setup**
   
   a. Create app at https://developers.facebook.com/
   
   b. Add Android platform:
   - Add package name and class name
   - Add key hash (use `keytool` to generate)
   
   c. Add iOS platform:
   - Add bundle ID
   - Configure Single Sign-On
   
   d. Add Facebook App ID to:
   - `android/app/src/main/AndroidManifest.xml`
   - `ios/Runner/Info.plist`

5. **Notification Permissions**
   
   Android (`android/app/src/main/AndroidManifest.xml`):
   ```xml
   <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
   <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
   ```
   
   iOS (`ios/Runner/Info.plist`):
   ```xml
   <key>UIBackgroundModes</key>
   <array>
       <string>remote-notification</string>
   </array>
   ```

6. **API Configuration**
   
   The Perenual API key is already configured in `lib/services/plant_api_service.dart`.
   If you need to change it, update the `_apiKey` constant.

7. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── main.dart                          # App entry point with Firebase init
├── models/
│   └── plant.dart                     # Plant data model
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart          # Login with social auth
│   │   └── registration_screen.dart   # User registration
│   ├── home/
│   │   └── home_screen.dart           # Main screen with tabs
│   ├── add_plant/
│   │   └── add_plant_screen.dart      # Add/edit plants
│   └── plant_detail/
│       └── plant_detail_screen.dart   # Plant details & reminders
├── services/
│   ├── auth_service.dart              # Email/password auth
│   ├── social_auth_service.dart       # Google/Facebook auth
│   ├── plant_storage_service.dart     # Local plant storage
│   ├── plant_api_service.dart         # External API integration
│   └── notification_service.dart      # Push notifications
├── theme/
│   ├── app_colors.dart                # Color palette
│   └── app_theme.dart                 # App theme configuration
├── utils/
│   └── constants.dart                 # App constants
└── widgets/
    ├── bottom_nav_bar.dart            # Navigation bar
    ├── custom_button.dart             # Reusable button
    ├── custom_text_field.dart         # Reusable text field
    ├── empty_state_widget.dart        # Empty state UI
    └── plant_card.dart                # Plant card component
```

## Key Services

### PlantStorageService
Singleton service for managing plant data locally using SharedPreferences.
- `addPlant()` - Add new plant
- `updatePlant()` - Update existing plant
- `deletePlant()` - Remove plant
- `loadPlants()` - Load plants from storage

### SocialAuthService
Handles Google and Facebook authentication with Firebase.
- `signInWithGoogle()` - Google OAuth flow
- `signInWithFacebook()` - Facebook OAuth flow
- `signOut()` - Sign out from all providers

### NotificationService
Manages local push notifications for watering reminders.
- `scheduleWateringReminder()` - Schedule reminder
- `cancelWateringReminder()` - Cancel specific reminder
- `cancelAllReminders()` - Cancel all reminders

### PlantApiService
Integrates with Perenual API for plant data.
- `searchPlants()` - Search plants by name
- `getPlantDetails()` - Get detailed plant info
- `getPopularPlants()` - Get trending plants

## Theme Colors

- **Primary**: `#1D9A6C` (Emerald Green)
- **Brand Green**: `#286B47` (Forest Green)
- **Accent**: `#D7F0E3` (Mint Green)
- **Background**: `#F8FFFB` (Light Green Tint)
- **Auth Background**: `#1B4128` (Dark Forest Green)
- **Error**: `#E5484D` (Red)
- **Grey**: `#6B7280` (Neutral Grey)

## Development

### Running Tests
```bash
flutter test
```

### Build for Release

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

### Code Style
The project uses `flutter_lints` for code quality. Run:
```bash
flutter analyze
```

## Troubleshooting

### Firebase Initialization Error
- Ensure `google-services.json` is in `android/app/`
- Check that Firebase project is properly configured
- Verify package name matches Firebase console

### Social Login Not Working
- Verify OAuth providers are enabled in Firebase Console
- Check Facebook App ID is correctly configured
- Ensure SHA-1 fingerprint is added to Firebase (Android)
- Verify URL schemes are configured (iOS)

### Notifications Not Showing
- Check notification permissions are granted
- Verify exact alarm permission (Android 12+)
- Ensure background modes are enabled (iOS)
- Check device notification settings

### API Search Not Working
- Verify API key is valid
- Check internet connection
- Ensure API endpoint is accessible

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.

## Acknowledgments

- [Flutter](https://flutter.dev/) - UI Framework
- [Firebase](https://firebase.google.com/) - Backend services
- [Perenual API](https://perenual.com/) - Plant database
- [Google Fonts](https://fonts.google.com/) - Typography
