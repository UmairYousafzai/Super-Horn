# 🎺 Super Air Horn

A Flutter mobile application that allows users to play horn sounds and connect to Bluetooth devices. The app features a modern UI with sound management, search functionality, and seamless Bluetooth connectivity.

## 📱 Features

- **🔊 Horn Sound Library**: Play multiple horn sounds with play/pause controls
- **🔍 Search & Filter**: Search sounds by name or filter by category (Indonesia, English, All)
- **📱 Bluetooth Connectivity**: Connect and interact with Bluetooth devices
- **👤 User Authentication**: Secure login and signup functionality
- **✅ Selection Management**: Select individual sounds or select all at once
- **💾 Local Storage**: Persistent user preferences using SharedPreferences
- **🎨 Modern UI**: Beautiful and responsive design built with Flutter

## 🎯 App Functionality

### 1. User Authentication

#### Sign Up
- **User Registration**: Create a new account with the following details:
  - Full Name
  - Email Address (with validation)
  - Password (with validation)
  - City
  - Country
- **Form Validation**: Real-time validation for all input fields
- **Data Persistence**: User data is securely saved to local storage (SharedPreferences)
- **Auto-login**: After successful signup, users are automatically logged in

#### Login
- **Email & Password Authentication**: Login with registered credentials
- **Form Validation**: Email and password validation before submission
- **Forgot Password**: Link available for password recovery (UI ready)
- **Session Management**: Automatic navigation based on user login status
- **Error Handling**: User-friendly error messages for invalid credentials

### 2. Home Screen - Sound Management

#### Sound Library
- **83+ Horn Sounds**: Extensive library of horn sounds including:
  - **56 Indonesian Sounds**: Popular Indonesian music and sound effects
  - **27 English Sounds**: International hits and popular tracks
  - Each sound has a unique code identifier (e.g., B1-2701-IND, B5-3700-ENG)

#### Sound Playback
- **Play/Pause Controls**: Tap the play button to start/stop sound playback
- **Visual Feedback**: Play button changes to pause icon when sound is playing
- **Auto-stop**: Sound automatically stops when playback completes
- **Multiple Sound Support**: Four different horn sound files (horn1.mp3 - horn4.mp3) distributed across the library

#### Search & Filter
- **Real-time Search**: Search sounds by name or category as you type
- **Category Filtering**: Filter sounds by:
  - All (shows all sounds)
  - Indonesia (shows only Indonesian sounds)
  - English (shows only English sounds)
- **Combined Search**: Search and filter work together for precise results
- **Case-insensitive**: Search is not case-sensitive for better user experience

#### Selection Management
- **Individual Selection**: Select/deselect individual sounds using checkboxes
- **Select All**: Quick "Select All" option in the app bar to select/deselect all filtered sounds
- **Visual State**: Checkbox state reflects current selection status
- **State Persistence**: Selected items are managed through Riverpod state management

#### Sound Information Display
Each sound card displays:
- **Sound Name**: The name of the horn sound
- **Code**: Unique identifier code (e.g., B1-2701-IND)
- **Category**: Sound category (Indonesia/English)
- **Play Button**: Circular red play/pause button
- **Selection Checkbox**: For multi-selection functionality

### 3. Bluetooth Connectivity

#### Device Discovery
- **Scan for Devices**: Tap "Scan" button to discover nearby Bluetooth devices
- **Real-time Discovery**: Devices appear in the list as they are discovered
- **Stop Scanning**: Tap "Stop" to cancel the scanning process
- **Loading Indicator**: Visual feedback during scanning process

#### Device Management
- **Device List**: View all discovered Bluetooth devices
- **Device Information**: Each device shows:
  - Device name
  - Device address
  - Connection status
- **Connect/Disconnect**: Connect to or disconnect from Bluetooth devices
- **Bonded Devices**: View previously paired devices

#### Bluetooth Service
- **Connection Management**: Handle Bluetooth connections and disconnections
- **Stream Support**: Real-time device discovery through streams
- **Error Handling**: Graceful error handling for connection failures

### 4. Navigation & User Interface

#### Navigation Drawer
- **User Profile**: Displays logged-in user's information:
  - User name
  - Email address
  - Profile avatar
- **Menu Options**:
  - **Home**: Navigate to home screen
  - **Settings**: Access app settings (UI ready)
  - **Help**: Get help and support (UI ready)
  - **Logout**: Sign out and clear user data
- **User Data**: Shows user information retrieved from local storage

#### Responsive Design
- **Screen Adaptation**: Uses Flutter ScreenUtil for responsive layouts
- **Design Size**: Optimized for 375x812 (iPhone X size)
- **Cross-platform**: Consistent UI across Android and iOS

### 5. Data Management

#### Local Storage
- **SharedPreferences**: Store user data locally on device
- **User Data Storage**:
  - Name
  - Email
  - Password (encrypted)
  - City
  - Country
- **Session Persistence**: User login status is remembered
- **Data Retrieval**: Quick access to stored user information

#### State Management
- **Riverpod**: Modern state management solution
- **Providers**:
  - `loginProvider`: Manages login state and validation
  - `signUpProvider`: Handles signup form state
  - `soundProvider`: Manages sound list
  - `checkedItemsProvider`: Tracks selected sounds
  - `bluetoothProvider`: Manages Bluetooth device list
  - `bluetoothDevicesStateProvider`: Controls Bluetooth scanning state
  - `sharedPreferencesProvider`: Handles local storage operations

### 6. Additional Features

#### Background & Theming
- **Custom Background**: Beautiful background image across all screens
- **Color Scheme**: Consistent red primary color theme
- **Material Design**: Follows Material Design guidelines

#### Form Validation
- **Email Validation**: Ensures proper email format
- **Password Validation**: Password strength requirements
- **Required Fields**: All mandatory fields are validated
- **Error Messages**: Clear, user-friendly error messages

#### Navigation Flow
- **Auto-navigation**: App automatically navigates based on login status
- **Route Management**: Custom navigation utilities for smooth transitions
- **Back Navigation**: Proper back button handling

## 🎨 Design

The app design is available on Figma:
[View Design on Figma](https://www.figma.com/design/librdl3b9bBCTOI4mzrLi6/Super-Air-Horn?t=MDqMrfCS4HUr6e39-0)

## 🛠️ Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: Riverpod
- **Bluetooth**: flutter_bluetooth_serial
- **Audio**: audioplayers
- **Local Storage**: shared_preferences
- **UI Utilities**: 
  - flutter_screenutil (responsive design)
  - flutter_svg (SVG support)
  - gap (spacing)
- **Permissions**: permission_handler

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- Flutter SDK (>=3.5.3)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Git

## 🚀 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/Super-Horn.git
   cd Super-Horn
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📱 Platform Support

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Windows
- ✅ Linux

## 📁 Project Structure

```
lib/
├── core/
│   └── theme/
│       └── colors.dart
├── data/
│   ├── data_source/
│   │   └── local/
│   └── models/
│       └── local/
├── domain/
│   └── entities/
│       ├── bluetooth_device.dart
│       ├── sound.dart
│       └── states/
├── providers/
│   ├── bluetooth_devices_provider.dart
│   ├── bluetooth_provider.dart
│   ├── checked_item_provider.dart
│   ├── login_provider.dart
│   ├── shared_pref_provider.dart
│   ├── signup_provider.dart
│   └── sound_provider.dart
├── screens/
│   ├── auth/
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── connectivity/
│   │   └── bluetooth_devices_widget.dart
│   ├── homescreen.dart
│   └── widgets/
├── utils/
│   ├── bluetooth_connectivity_helper.dart
│   ├── media_query_extension.dart
│   ├── navigations.dart
│   └── services/
│       └── bluetooth_service.dart
└── main.dart
```

## 🎯 Quick Start Guide

### First Time Setup

1. **Launch the App**: Open Super Air Horn on your device
2. **Sign Up** (if new user):
   - Tap "Register" on the login screen
   - Fill in your details: Name, Email, Password, City, Country
   - Tap "Get Started" to create your account
   - You'll be automatically logged in after signup
3. **Login** (if existing user):
   - Enter your email and password
   - Tap "Get Started" to access the app

### Using the Sound Library

1. **Browse Sounds**: 
   - The home screen displays all available horn sounds
   - Scroll through the list to see all 83+ sounds

2. **Play a Sound**:
   - Tap the red circular play button next to any sound
   - The button changes to pause icon while playing
   - Tap again to stop playback

3. **Search for Sounds**:
   - Use the search bar at the top to type a sound name
   - Results filter in real-time as you type
   - Search works for both sound names and categories

4. **Filter by Category**:
   - Tap the filter icon (☰) in the app bar
   - Select from: All, Indonesia, or English
   - The list updates to show only sounds from selected category

5. **Select Sounds**:
   - Check individual checkboxes to select specific sounds
   - Use "Select All" checkbox in app bar to select/deselect all visible sounds
   - Selected sounds are tracked for future operations

### Bluetooth Device Connection

1. **Access Bluetooth Screen**:
   - Navigate to the Bluetooth devices screen (currently set as default in main.dart)

2. **Scan for Devices**:
   - Tap the "Scan" button in the top right
   - Wait for devices to appear in the list
   - A loading indicator shows while scanning

3. **Connect to Device**:
   - Tap on a device from the list to connect
   - Connection status will be displayed
   - Use "Stop" button to cancel scanning

4. **Manage Connection**:
   - View connected/bonded devices
   - Disconnect from devices as needed

### Navigation & Settings

1. **Access Drawer**:
   - Tap the hamburger menu (☰) icon in the app bar
   - View your profile information

2. **Logout**:
   - Open the navigation drawer
   - Tap "Logout" at the bottom
   - You'll be returned to the login screen
   - All session data will be cleared

## 🔧 Configuration

### Android Permissions
The app requires the following permissions (configured in `android/app/src/main/AndroidManifest.xml`):
- Bluetooth
- Bluetooth Admin
- Location (for Bluetooth scanning)

### iOS Permissions
Configure Bluetooth permissions in `ios/Runner/Info.plist`:
- NSBluetoothAlwaysUsageDescription
- NSBluetoothPeripheralUsageDescription

## 📝 Development

### Running Tests
```bash
flutter test
```

### Building for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License


## 👤 Author

(https://github.com/UmairYousafzai)

---

⭐ If you like this project, please give it a star!
