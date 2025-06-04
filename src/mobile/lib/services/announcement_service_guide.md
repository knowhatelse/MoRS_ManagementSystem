# Announcement Service Usage Guide

This guide demonstrates how to use the AnnouncementService to interact with the API for announcement-related operations.

## Service Overview

The `AnnouncementService` provides methods to:

- ✅ **GET** all announcements with filtering
- ✅ **GET** announcement by ID
- ✅ **POST** create new announcements
- ✅ **PUT** update announcements (soft delete/restore)

## API Endpoints Mapping

| Method | Endpoint                 | Description             |
| ------ | ------------------------ | ----------------------- |
| `GET`  | `/api/Announcement`      | Get all announcements   |
| `GET`  | `/api/Announcement/{id}` | Get announcement by ID  |
| `POST` | `/api/Announcement`      | Create new announcement |
| `PUT`  | `/api/Announcement/{id}` | Update announcement     |

## Usage Examples

### 1. Initialize Service

```dart
import 'package:mors_management_system_mobile/services/services.dart';

final announcementService = AnnouncementService();
```

### 2. Get All Active Announcements (Most Common)

```dart
try {
  // Get active announcements with user information
  final announcements = await announcementService.getActiveAnnouncements();

  for (final announcement in announcements) {
    print('${announcement.title} by ${announcement.user?.fullName}');
  }
} on ApiException catch (e) {
  print('API Error: ${e.message} (Status: ${e.statusCode})');
} catch (e) {
  print('Unexpected error: $e');
}
```

### 3. Get Announcements with Custom Filtering

```dart
try {
  // Get all announcements (including deleted) without user info
  final allAnnouncements = await announcementService.getAnnouncements(
    isDeleted: null,           // null = all, true = deleted only, false = active only
    isUserIncluded: false,     // Don't include user information
  );

  // Get only deleted announcements with user info
  final deletedAnnouncements = await announcementService.getAnnouncements(
    isDeleted: true,
    isUserIncluded: true,
  );

} catch (e) {
  print('Error: $e');
}
```

### 4. Get Specific Announcement

```dart
try {
  final announcement = await announcementService.getAnnouncementById(
    1,                        // Announcement ID
    isUserIncluded: true,     // Include user information
  );

  if (announcement != null) {
    print('Found: ${announcement.title}');
  } else {
    print('Announcement not found');
  }
} catch (e) {
  print('Error: $e');
}
```

### 5. Create New Announcement

```dart
try {
  final request = CreateAnnouncementRequest(
    title: 'Important Update',
    content: 'This is an important announcement about system changes.',
    userId: 1,  // ID of the user creating the announcement
  );

  // Validation is automatic before sending
  final newAnnouncement = await announcementService.createAnnouncement(request);

  print('Created announcement with ID: ${newAnnouncement.id}');
} on ApiException catch (e) {
  if (e.statusCode == 400) {
    print('Validation error: ${e.message}');
  } else {
    print('API error: ${e.message}');
  }
} catch (e) {
  print('Error: $e');
}
```

### 6. Soft Delete Announcement

```dart
try {
  final result = await announcementService.deleteAnnouncement(1);

  if (result != null) {
    print('Announcement deleted successfully');
  } else {
    print('Announcement not found');
  }
} catch (e) {
  print('Error: $e');
}
```

### 7. Restore Deleted Announcement

```dart
try {
  final result = await announcementService.restoreAnnouncement(1);

  if (result != null) {
    print('Announcement restored successfully');
  } else {
    print('Announcement not found');
  }
} catch (e) {
  print('Error: $e');
}
```

### 8. Custom Update

```dart
try {
  final updateRequest = UpdateAnnouncementRequest(isDeleted: false);
  final result = await announcementService.updateAnnouncement(1, updateRequest);

  if (result != null) {
    print('Announcement updated: ${result.title}');
  } else {
    print('Announcement not found');
  }
} catch (e) {
  print('Error: $e');
}
```

## UI Integration Example

### In a StatefulWidget:

```dart
class AnnouncementsPage extends StatefulWidget {
  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  final AnnouncementService _service = AnnouncementService();
  List<AnnouncementResponse> announcements = [];
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAnnouncements();
  }

  Future<void> _loadAnnouncements() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final result = await _service.getActiveAnnouncements();
      setState(() {
        announcements = result;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $errorMessage'),
            ElevatedButton(
              onPressed: _loadAnnouncements,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAnnouncements,
      child: ListView.builder(
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          final announcement = announcements[index];
          return ListTile(
            title: Text(announcement.title),
            subtitle: Text(announcement.content),
            trailing: Text(_formatDate(announcement.createdAt)),
          );
        },
      ),
    );
  }
}
```

## Error Handling

The service handles different types of errors:

### ApiException

- **Status 400**: Validation errors
- **Status 404**: Resource not found
- **Status 500**: Server errors

### Network Exceptions

- **SocketException**: No internet connection
- **HttpException**: HTTP-level errors
- **FormatException**: Invalid JSON response

### Best Practices

1. **Always use try-catch blocks**
2. **Handle ApiException separately for specific status codes**
3. **Provide user-friendly error messages**
4. **Implement retry mechanisms for network failures**
5. **Show loading states during API calls**
6. **Use pull-to-refresh for data updates**

## Configuration

Make sure your API base URL is correctly configured in `ApiConfig`:

```dart
// In api_config.dart
static const String _baseUrl = 'http://your-api-server:port/api';
```

The service automatically handles:

- ✅ JSON serialization/deserialization
- ✅ HTTP headers
- ✅ Error responses
- ✅ Validation before sending requests
- ✅ Type-safe responses
