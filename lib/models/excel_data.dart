class ExcelData {
  final List<String> headers;
  final List<Map<String, dynamic>> rows;
  final String fileName;
  final DateTime loadedAt;

  ExcelData({
    required this.headers,
    required this.rows,
    required this.fileName,
    required this.loadedAt,
  });

  int get totalRows => rows.length;
  int get totalColumns => headers.length;

  Map<String, dynamic> toJson() {
    return {
      'headers': headers,
      'rows': rows,
      'fileName': fileName,
      'loadedAt': loadedAt.toIso8601String(),
    };
  }

  factory ExcelData.fromJson(Map<String, dynamic> json) {
    return ExcelData(
      headers: List<String>.from(json['headers']),
      rows: List<Map<String, dynamic>>.from(json['rows']),
      fileName: json['fileName'],
      loadedAt: DateTime.parse(json['loadedAt']),
    );
  }
}

enum SearchType {
  contains,
  wildcard,
  exact,
  starts,
  ends,
}

class SearchResult {
  final List<Map<String, dynamic>> filteredRows;
  final int totalResults;
  final String searchTerm1;
  final String searchTerm2;
  final SearchType searchType;

  SearchResult({
    required this.filteredRows,
    required this.totalResults,
    required this.searchTerm1,
    required this.searchTerm2,
    required this.searchType,
  });
}

