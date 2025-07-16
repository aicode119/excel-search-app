import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestStoragePermission() async {
    try {
      // For Android 13+ (API 33+), we need different permissions
      if (await _isAndroid13OrHigher()) {
        // Request media permissions for Android 13+
        final Map<Permission, PermissionStatus> statuses = await [
          Permission.photos,
          Permission.videos,
          Permission.audio,
        ].request();
        
        return statuses.values.every((status) => 
          status == PermissionStatus.granted || 
          status == PermissionStatus.limited
        );
      } else {
        // For older Android versions
        final PermissionStatus status = await Permission.storage.request();
        return status == PermissionStatus.granted;
      }
    } catch (e) {
      print('Error requesting storage permission: $e');
      return false;
    }
  }

  static Future<bool> checkStoragePermission() async {
    try {
      if (await _isAndroid13OrHigher()) {
        final PermissionStatus photoStatus = await Permission.photos.status;
        final PermissionStatus videoStatus = await Permission.videos.status;
        final PermissionStatus audioStatus = await Permission.audio.status;
        
        return photoStatus == PermissionStatus.granted ||
               videoStatus == PermissionStatus.granted ||
               audioStatus == PermissionStatus.granted ||
               photoStatus == PermissionStatus.limited ||
               videoStatus == PermissionStatus.limited ||
               audioStatus == PermissionStatus.limited;
      } else {
        final PermissionStatus status = await Permission.storage.status;
        return status == PermissionStatus.granted;
      }
    } catch (e) {
      print('Error checking storage permission: $e');
      return false;
    }
  }

  static Future<bool> _isAndroid13OrHigher() async {
    // This is a simplified check - in a real app you might want to use
    // device_info_plus package for more accurate version detection
    // For now, we'll return true to test the Android 13+ permission flow
    // You might want to use Platform.isAndroid and check SDK version here
    return false; 
  }

  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}

