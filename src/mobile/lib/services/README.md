# API Services Documentation

This directory contains the API service layer for the Flutter mobile application. The services handle all communication with the backend API.

## Structure

### 1. `api_config.dart`

Contains the base URL configuration and common headers. This is the **single place** to change the API base URL.

**Important Notes:**

- **Android Emulator**: Use `10.0.2.2` instead of `localhost`
- **Physical Device**: Replace with your computer's actual IP address (e.g., `192.168.1.XXX`)
- **iOS Simulator**: Use `localhost` or your computer's IP address

### 2. `base_api_service.dart`

Abstract base class that provides common HTTP methods (GET, POST, PUT, DELETE) with:

- Automatic JSON encoding/decoding
- Error handling
- Custom API exceptions
- Response status code handling

### 3. `authentication_service.dart`

Specific service for authentication operations:

- `login()` - Authenticates user with email and password
- `logout()` - Future implementation for logout
- `refreshToken()` - Future implementation for token refresh

## Usage Example

```dart
import '../services/services.dart';
import '../models/models.dart';

// Create service instance
final authService = AuthenticationService();

// Login
try {
  final loginRequest = LoginRequest(
    email: 'user@example.com',
    password: 'password123',
  );

  final userResponse = await authService.login(loginRequest);
  print('Login successful: ${userResponse.fullName}');

} on ApiException catch (e) {
  print('API Error: ${e.message} (Status: ${e.statusCode})');
} catch (e) {
  print('Unexpected error: $e');
}
```

## Configuration for Different Environments

### Android Emulator

```dart
static const String _baseUrl = 'http://10.0.2.2:5000/api';
```

### Physical Device (Replace XXX with your IP)

```dart
static const String _baseUrl = 'http://192.168.1.XXX:5000/api';
```

### iOS Simulator

```dart
static const String _baseUrl = 'http://localhost:5000/api';
```

## Error Handling

The services use a custom `ApiException` class that provides:

- HTTP status codes
- Descriptive error messages
- Automatic network error detection

Common error scenarios handled:

- No internet connection
- Server unreachable
- Invalid response format
- HTTP errors (4xx, 5xx)

## Adding New Services

To add a new service:

1. Create a new service class extending `BaseApiService`
2. Add the endpoint constant to `ApiConfig`
3. Implement the specific methods for your API endpoints
4. Export the service in `services.dart`

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
