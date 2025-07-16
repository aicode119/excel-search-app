import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class DataTableWidget extends StatefulWidget {
  final List<String> headers;
  final List<Map<String, dynamic>> rows;
  final String searchTerm1;
  final String searchTerm2;
  final int itemsPerPage;

  const DataTableWidget({
    Key? key,
    required this.headers,
    required this.rows,
    this.searchTerm1 = '',
    this.searchTerm2 = '',
    this.itemsPerPage = 50,
  }) : super(key: key);

  @override
  State<DataTableWidget> createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  int _currentPage = 0;
  int get _totalPages => (widget.rows.length / widget.itemsPerPage).ceil();

  List<Map<String, dynamic>> get _currentPageData {
    final startIndex = _currentPage * widget.itemsPerPage;
    final endIndex = (startIndex + widget.itemsPerPage).clamp(0, widget.rows.length);
    return widget.rows.sublist(startIndex, endIndex);
  }

  @override
  void didUpdateWidget(DataTableWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reset to first page when data changes
    if (oldWidget.rows.length != widget.rows.length) {
      _currentPage = 0;
    }
  }

  String _highlightText(String text, String searchTerm) {
    if (searchTerm.isEmpty) return text;
    
    // For display purposes, we'll just return the original text
    // In a real implementation, you might want to use RichText for highlighting
    return text;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rows.isEmpty) {
      return Card(
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'لم يتم العثور على نتائج مطابقة',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'جرب تغيير كلمات البحث أو نوع البحث',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with pagination info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'النتائج',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_totalPages > 1)
                  Text(
                    'صفحة ${_currentPage + 1} من $_totalPages',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          
          // Data table
          SizedBox(
            height: 400, // Fixed height for the table
            child: DataTable2(
              columnSpacing: 12,
              horizontalMargin: 12,
              minWidth: 600,
              columns: widget.headers.map((header) {
                return DataColumn2(
                  label: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      header,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  size: ColumnSize.M,
                );
              }).toList(),
              rows: _currentPageData.map((row) {
                return DataRow2(
                  cells: widget.headers.map((header) {
                    final cellValue = row[header]?.toString() ?? '';
                    return DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          _highlightText(cellValue, widget.searchTerm1),
                          style: const TextStyle(fontSize: 14),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
              headingRowColor: MaterialStateProperty.all(Colors.blue[700]),
              dataRowColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.hovered)) {
                  return Colors.blue[50];
                }
                return null;
              }),
            ),
          ),
          
          // Pagination controls
          if (_totalPages > 1)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _currentPage > 0
                        ? () {
                            setState(() {
                              _currentPage--;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.chevron_right),
                    tooltip: 'الصفحة السابقة',
                  ),
                  const SizedBox(width: 16),
                  
                  // Page numbers
                  ...List.generate(
                    _totalPages.clamp(0, 5), // Show max 5 page numbers
                    (index) {
                      final pageIndex = _currentPage < 3
                          ? index
                          : _currentPage - 2 + index;
                      
                      if (pageIndex >= _totalPages) return const SizedBox.shrink();
                      
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _currentPage = pageIndex;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _currentPage == pageIndex
                                ? Colors.blue[700]
                                : Colors.grey[200],
                            foregroundColor: _currentPage == pageIndex
                                ? Colors.white
                                : Colors.black,
                            minimumSize: const Size(40, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('${pageIndex + 1}'),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(width: 16),
                  IconButton(
                    onPressed: _currentPage < _totalPages - 1
                        ? () {
                            setState(() {
                              _currentPage++;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.chevron_left),
                    tooltip: 'الصفحة التالية',
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

