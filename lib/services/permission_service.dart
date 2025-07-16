import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:device_info_plus/device_info_plus.dart';

class PermissionService {
  static Future<bool> requestStoragePermission() async {
    try {
      if (kIsWeb) return true; // Permissions not applicable for web

      if (await _isAndroid13OrHigher()) {
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
      if (kIsWeb) return true; // Permissions not applicable for web

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
    if (kIsWeb) return false; // Not applicable for web

    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt >= 33;
  }

  static Future<void> openAppSettings() async {
    await openAppSettings();
  }
}

