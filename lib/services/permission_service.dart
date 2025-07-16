import 'package:permission_handler.dart';

class PermissionService {
  static Future<bool> requestStoragePermission() async {
    try {
      // For Android 13+ (API 33+), we need different permissions
      if (await _isAndroid13OrHigher()) {
        // Request media permissions for Android 13+
        final status = await [
          Permission.photos,
          Permission.videos,
          Permission.audio,
        ].request();
        
        return status.values.every((status) => 
          status == PermissionStatus.granted || 
          status == PermissionStatus.limited
        );
      } else {
        // For older Android versions
        final status = await Permission.storage.request();
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
        final photoStatus = await Permission.photos.status;
        final videoStatus = await Permission.videos.status;
        final audioStatus = await Permission.audio.status;
        
        return photoStatus == PermissionStatus.granted ||
               videoStatus == PermissionStatus.granted ||
               audioStatus == PermissionStatus.granted ||
               photoStatus == PermissionStatus.limited ||
               videoStatus == PermissionStatus.limited ||
               audioStatus == PermissionStatus.limited;
      } else {
        final status = await Permission.storage.status;
        return status == PermissionStatus.granted;
      }
    } catch (e) {
      print('Error checking storage permission: $e');
      return false;
    }
  }

  static Future<bool> _isAndroid13OrHigher() async {
    try {
      // This is a simplified check - in a real app you might want to use
      // device_info_plus package for more accurate version detection
      return false; // For now, assume older Android version
    } catch (e) {
      return false;
    }
  }

  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}

