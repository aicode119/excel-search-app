import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/excel_data.dart';
import '../services/excel_service.dart';
import '../services/storage_service.dart';
import '../services/permission_service.dart';
import '../widgets/search_widget.dart';
import '../widgets/stats_widget.dart';
import '../widgets/data_table_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ExcelData? _currentData;
  SearchResult? _searchResult;
  bool _isLoading = false;
  String _statusMessage = '';

  @override
  void initState() {
    super.initState();
    _loadLastFile();
  }

  Future<void> _loadLastFile() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'جاري تحميل آخر ملف...';
    });

    try {
      final lastFile = await StorageService.getLastFile();
      if (lastFile != null) {
        setState(() {
          _currentData = lastFile;
          _statusMessage = 'تم تحميل آخر ملف: ${lastFile.fileName}';
        });
        _performSearch('', '', SearchType.contains);
      } else {
        setState(() {
          _statusMessage = 'لا يوجد ملف محفوظ مسبقاً';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'خطأ في تحميل آخر ملف: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickAndLoadFile() async {
    // Check permissions first
    final hasPermission = await PermissionService.checkStoragePermission();
    if (!hasPermission) {
      final granted = await PermissionService.requestStoragePermission();
      if (!granted) {
        _showPermissionDialog();
        return;
      }
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'جاري اختيار الملف...';
    });

    try {
      final file = await ExcelService.pickFile();
      if (file != null) {
        setState(() {
          _statusMessage = 'جاري معالجة الملف: ${file.name}';
        });

        final data = await ExcelService.processFile(file);
        if (data != null) {
          setState(() {
            _currentData = data;
            _statusMessage = 'تم تحميل الملف بنجاح: ${data.fileName}';
          });

          // Save as last file
          await StorageService.saveLastFile(data);
          
          // Perform initial search to show all data
          _performSearch('', '', SearchType.contains);
        } else {
          setState(() {
            _statusMessage = 'فشل في معالجة الملف. تأكد من أن الملف صحيح.';
          });
        }
      } else {
        setState(() {
          _statusMessage = 'لم يتم اختيار ملف';
        });
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'خطأ في تحميل الملف: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _performSearch(String term1, String term2, SearchType searchType) {
    if (_currentData == null) return;

    setState(() {
      _searchResult = ExcelService.searchData(
        _currentData!,
        term1,
        term2,
        searchType,
      );
    });
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('صلاحية مطلوبة'),
        content: const Text(
          'يحتاج التطبيق إلى صلاحية الوصول للملفات لتتمكن من اختيار ملفات Excel. '
          'يرجى منح الصلاحية من إعدادات التطبيق.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              PermissionService.openAppSettings();
            },
            child: const Text('فتح الإعدادات'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '🔍 البحث في ملفات Excel',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[700],
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue[700]!,
              Colors.blue[50]!,
            ],
          ),
        ),
        child: Column(
          children: [
            // Header section with file picker
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        'المبرمج العقيد وسام خيرالدين هادي ضابط استخبارات نينوى',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      
                      ElevatedButton.icon(
                        onPressed: _isLoading ? null : _pickAndLoadFile,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.folder_open),
                        label: Text(_isLoading ? 'جاري التحميل...' : '📁 اختر ملف Excel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      ),
                      
                      if (_statusMessage.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blue[200]!),
                          ),
                          child: Text(
                            _statusMessage,
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      
                      if (_currentData != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green[200]!),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'الملف: ${_currentData!.fileName}',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'تم التحميل: ${_currentData!.loadedAt.toString().split('.')[0]}',
                                style: TextStyle(
                                  color: Colors.green[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            
            // Stats section
            if (_currentData != null && _searchResult != null)
              StatsWidget(
                totalRows: _currentData!.totalRows,
                searchResults: _searchResult!.totalResults,
                totalColumns: _currentData!.totalColumns,
              ),
            
            // Search section
            if (_currentData != null)
              SearchWidget(
                onSearch: _performSearch,
                isLoading: _isLoading,
              ),
            
            // Results section
            if (_currentData != null && _searchResult != null)
              Expanded(
                child: DataTableWidget(
                  headers: _currentData!.headers,
                  rows: _searchResult!.filteredRows,
                  searchTerm1: _searchResult!.searchTerm1,
                  searchTerm2: _searchResult!.searchTerm2,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

