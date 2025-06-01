# API Service Setup Guide

## 🎉 Setup Complete!

Your Flutter app now has a complete API service layer for calling your local backend API. Here's what has been created:

## 📁 Files Created

### Core Service Files

- `lib/services/api_config.dart` - API configuration with base URL
- `lib/services/base_api_service.dart` - Base service class with HTTP methods
- `lib/services/authentication_service.dart` - Authentication-specific service
- `lib/services/services.dart` - Barrel file for easy imports

### Documentation & Examples

- `lib/services/README.md` - Detailed documentation
- `lib/services/examples/authentication_examples.dart` - Usage examples

### Updated Files

- `pubspec.yaml` - Added HTTP package dependency
- `lib/screens/login_screen.dart` - Integrated with authentication service

## 🔧 Configuration

### 1. Base URL Configuration

The base URL is configured in `lib/services/api_config.dart`. **This is the single place** to change your API URL:

```dart
// Current setting (Android Emulator)
static const String _baseUrl = 'http://10.0.2.2:5000/api';
```

### 2. Environment-Specific URLs

**Choose the right URL for your testing environment:**

#### Android Emulator

```dart
static const String _baseUrl = 'http://10.0.2.2:5000/api';
```

#### Physical Android Device

Replace `XXX.XXX.XXX.XXX` with your computer's actual IP address:

```dart
static const String _baseUrl = 'http://XXX.XXX.XXX.XXX:5000/api';
```

#### iOS Simulator

```dart
static const String _baseUrl = 'http://localhost:5000/api';
```

### 3. Finding Your Computer's IP Address

**Windows (PowerShell):**

```powershell
ipconfig | findstr "IPv4"
```

**Windows (Command Prompt):**

```cmd
ipconfig
```

Look for the "IPv4 Address" under your network adapter (usually starts with 192.168.x.x).

## 🚀 Usage

### Basic Login Example

```dart
import '../services/services.dart';
import '../models/models.dart';

final authService = AuthenticationService();

try {
  final loginRequest = LoginRequest(
    email: 'user@example.com',
    password: 'password123',
  );

  final userResponse = await authService.login(loginRequest);
  print('Welcome ${userResponse.fullName}!');

} on ApiException catch (e) {
  print('Login failed: ${e.message}');
} catch (e) {
  print('Unexpected error: $e');
}
```

### The Login Screen

The `LoginScreen` has been updated to use the authentication service with:

- Input validation
- Loading states
- Error handling
- Success feedback

## 🔍 Testing

1. **Start your API server** on localhost:5000
2. **Update the base URL** in `api_config.dart` based on your testing environment
3. **Run the Flutter app** and test the login functionality

## ⚠️ Important Notes

### Network Security (Android 9+)

If you're testing on Android 9+ with HTTP (not HTTPS), you may need to allow cleartext traffic. Add this to `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:usesCleartextTraffic="true"
    ...>
```

### API Response Format

The service expects the API to return a `UserResponse` object directly. The current API endpoint `/api/Authentication` returns this format when login is successful.

## 🔮 Future Enhancements

The service structure is ready for:

- Token-based authentication
- Refresh token handling
- Additional API endpoints
- Caching mechanisms
- Offline support

## 📞 Adding More Services

To add new services (e.g., UserService, AppointmentService):

1. Create a new service class extending `BaseApiService`
2. Add endpoint constants to `ApiConfig`
3. Export the service in `services.dart`

Example:

```dart
class UserService extends BaseApiService {
  Future<List<UserResponse>> getUsers() async {
    final response = await get('/Users');
    return (response['data'] as List)
        .map((user) => UserResponse.fromJson(user))
        .toList();
  }
}
```

## ✅ Ready to Use!

Your authentication service is now ready! The login screen will call your API at `http://localhost:5000/api/Authentication` and handle the response appropriately.

**Next Steps:**

1. Update the base URL for your testing environment
2. Start your API server
3. Test the login functionality
4. Add navigation to home screen after successful login
