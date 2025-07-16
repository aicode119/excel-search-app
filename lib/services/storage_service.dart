import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/excel_data.dart';

class StorageService {
  static const String _lastFileKey = 'last_opened_file';
  static const String _lastFileDataKey = 'last_file_data';

  static Future<void> saveLastFile(ExcelData data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = jsonEncode(data.toJson());
      
      await prefs.setString(_lastFileKey, data.fileName);
      await prefs.setString(_lastFileDataKey, jsonData);
    } catch (e) {
      print('Error saving last file: $e');
    }
  }

  static Future<ExcelData?> getLastFile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonData = prefs.getString(_lastFileDataKey);
      
      if (jsonData != null) {
        final Map<String, dynamic> data = jsonDecode(jsonData);
        return ExcelData.fromJson(data);
      }
    } catch (e) {
      print('Error loading last file: $e');
    }
    return null;
  }

  static Future<String?> getLastFileName() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_lastFileKey);
    } catch (e) {
      print('Error getting last file name: $e');
    }
    return null;
  }

  static Future<void> clearLastFile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_lastFileKey);
      await prefs.remove(_lastFileDataKey);
    } catch (e) {
      print('Error clearing last file: $e');
    }
  }
}

