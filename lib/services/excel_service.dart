import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import '../models/excel_data.dart';

class ExcelService {
  static Future<PlatformFile?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls', 'csv'],
      allowMultiple: false,
    );

    if (result != null && result.files.isNotEmpty) {
      return result.files.first;
    }
    return null;
  }

  static Future<ExcelData?> processFile(PlatformFile file) async {
    try {
      if (file.path == null) return null;

      final fileExtension = file.extension?.toLowerCase();
      
      if (fileExtension == 'csv') {
        return await _processCsvFile(file);
      } else if (fileExtension == 'xlsx' || fileExtension == 'xls') {
        return await _processExcelFile(file);
      }
      
      return null;
    } catch (e) {
      print('Error processing file: $e');
      return null;
    }
  }

  static Future<ExcelData?> _processCsvFile(PlatformFile file) async {
    try {
      final fileContent = await File(file.path!).readAsString();
      final List<List<dynamic>> csvData = const CsvToListConverter().convert(fileContent);
      
      if (csvData.isEmpty) return null;

      final headers = csvData.first.map((h) => h?.toString() ?? '').toList();
      final rows = csvData.skip(1).map((row) {
        final Map<String, dynamic> rowMap = {};
        for (int i = 0; i < headers.length; i++) {
          rowMap[headers[i]] = i < row.length ? row[i]?.toString() ?? '' : '';
        }
        return rowMap;
      }).toList();

      return ExcelData(
        headers: headers.cast<String>(),
        rows: rows,
        fileName: file.name,
        loadedAt: DateTime.now(),
      );
    } catch (e) {
      print('Error processing CSV file: $e');
      return null;
    }
  }

  static Future<ExcelData?> _processExcelFile(PlatformFile file) async {
    try {
      final bytes = await File(file.path!).readAsBytes();
      final excel = Excel.decodeBytes(bytes);
      
      // Get the first sheet
      final sheetName = excel.tables.keys.first;
      final sheet = excel.tables[sheetName];
      
      if (sheet == null || sheet.rows.isEmpty) return null;

      // Extract headers from first row
      final headerRow = sheet.rows.first;
      final headers = headerRow.map((cell) => 
        cell?.value?.toString() ?? ''
      ).toList();

      // Extract data rows
      final rows = <Map<String, dynamic>>[];
      for (int i = 1; i < sheet.rows.length; i++) {
        final row = sheet.rows[i];
        final Map<String, dynamic> rowMap = {};
        
        for (int j = 0; j < headers.length; j++) {
          final cellValue = j < row.length ? row[j]?.value?.toString() ?? '' : '';
          rowMap[headers[j]] = cellValue;
        }
        rows.add(rowMap);
      }

      return ExcelData(
        headers: headers.cast<String>(),
        rows: rows,
        fileName: file.name,
        loadedAt: DateTime.now(),
      );
    } catch (e) {
      print('Error processing Excel file: $e');
      return null;
    }
  }

  static SearchResult searchData(
    ExcelData data,
    String searchTerm1,
    String searchTerm2,
    SearchType searchType,
  ) {
    final filteredRows = <Map<String, dynamic>>[];

    for (final row in data.rows) {
      bool matchesTerm1 = searchTerm1.isEmpty ? true : false;
      bool matchesTerm2 = searchTerm2.isEmpty ? true : false;

      // Search for term 1 in all columns
      if (searchTerm1.isNotEmpty) {
        for (final header in data.headers) {
          final cellValue = row[header]?.toString().toLowerCase() ?? '';
          if (_performMatch(cellValue, searchTerm1.toLowerCase(), searchType)) {
            matchesTerm1 = true;
            break;
          }
        }
      }

      // Search for term 2 in all columns
      if (searchTerm2.isNotEmpty) {
        for (final header in data.headers) {
          final cellValue = row[header]?.toString().toLowerCase() ?? '';
          if (_performMatch(cellValue, searchTerm2.toLowerCase(), searchType)) {
            matchesTerm2 = true;
            break;
          }
        }
      }

      // Both terms must match (AND logic)
      if (matchesTerm1 && matchesTerm2) {
        filteredRows.add(row);
      }
    }

    return SearchResult(
      filteredRows: filteredRows,
      totalResults: filteredRows.length,
      searchTerm1: searchTerm1,
      searchTerm2: searchTerm2,
      searchType: searchType,
    );
  }

  static bool _performMatch(String cellValue, String searchValue, SearchType searchType) {
    switch (searchType) {
      case SearchType.wildcard:
        return _matchWildcard(cellValue, searchValue);
      case SearchType.exact:
        return cellValue == searchValue;
      case SearchType.starts:
        return cellValue.startsWith(searchValue);
      case SearchType.ends:
        return cellValue.endsWith(searchValue);
      case SearchType.contains:
      default:
        return cellValue.contains(searchValue);
    }
  }

  static bool _matchWildcard(String text, String pattern) {
    // Convert wildcard pattern to regex
    String regexPattern = pattern
        .replaceAll(RegExp(r'[.+^${}()|[\]\\]'), r'\$&')
        .replaceAll('*', '.*');
    
    try {
      final regex = RegExp(regexPattern, caseSensitive: false);
      return regex.hasMatch(text);
    } catch (e) {
      // If regex fails, fall back to simple contains
      return text.toLowerCase().contains(pattern.toLowerCase().replaceAll('*', ''));
    }
  }
}

