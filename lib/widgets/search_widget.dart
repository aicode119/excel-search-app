import 'package:flutter/material.dart';
import '../models/excel_data.dart';

class SearchWidget extends StatefulWidget {
  final Function(String, String, SearchType) onSearch;
  final bool isLoading;

  const SearchWidget({
    Key? key,
    required this.onSearch,
    this.isLoading = false,
  }) : super(key: key);

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  final TextEditingController _searchController1 = TextEditingController();
  final TextEditingController _searchController2 = TextEditingController();
  SearchType _selectedSearchType = SearchType.contains;

  @override
  void dispose() {
    _searchController1.dispose();
    _searchController2.dispose();
    super.dispose();
  }

  void _performSearch() {
    widget.onSearch(
      _searchController1.text.trim(),
      _searchController2.text.trim(),
      _selectedSearchType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              '🔍 البحث في ملفات Excel',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // First search field
            TextField(
              controller: _searchController1,
              decoration: InputDecoration(
                labelText: 'ابحث عن الكلمة الأولى (جميع الأعمدة)',
                hintText: 'أدخل الكلمة الأولى للبحث...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _searchController1.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController1.clear();
                          _performSearch();
                        },
                      )
                    : null,
              ),
              textAlign: TextAlign.right,
              onChanged: (value) {
                setState(() {});
                _performSearch();
              },
            ),
            const SizedBox(height: 8),
            Text(
              '⬆️ هذا المربع يبحث عن الكلمة الأولى في جميع الأعمدة.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // Second search field
            TextField(
              controller: _searchController2,
              decoration: InputDecoration(
                labelText: 'ابحث عن الكلمة الثانية (جميع الأعمدة)',
                hintText: 'أدخل الكلمة الثانية للبحث...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: _searchController2.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController2.clear();
                          _performSearch();
                        },
                      )
                    : null,
              ),
              textAlign: TextAlign.right,
              onChanged: (value) {
                setState(() {});
                _performSearch();
              },
            ),
            const SizedBox(height: 8),
            Text(
              '⬆️ هذا المربع يبحث عن الكلمة الثانية في جميع الأعمدة.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '💡 ستظهر النتائج فقط إذا تم العثور على كلا الكلمتين في نفس السجل (بحث مركب).',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.blue[700],
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            
            // Search type dropdown
            DropdownButtonFormField<SearchType>(
              value: _selectedSearchType,
              decoration: InputDecoration(
                labelText: 'نوع البحث',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: const [
                DropdownMenuItem(
                  value: SearchType.contains,
                  child: Text('يحتوي على'),
                ),
                DropdownMenuItem(
                  value: SearchType.wildcard,
                  child: Text('بحث بالنجمة (*)'),
                ),
                DropdownMenuItem(
                  value: SearchType.exact,
                  child: Text('مطابقة تامة'),
                ),
                DropdownMenuItem(
                  value: SearchType.starts,
                  child: Text('يبدأ بـ'),
                ),
                DropdownMenuItem(
                  value: SearchType.ends,
                  child: Text('ينتهي بـ'),
                ),
              ],
              onChanged: (SearchType? value) {
                if (value != null) {
                  setState(() {
                    _selectedSearchType = value;
                  });
                  _performSearch();
                }
              },
            ),
            const SizedBox(height: 16),
            
            // Search tips
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '💡 نصائح البحث:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('• البحث العادي: عبيدة احمد'),
                  const Text('• البحث بالنجمة: عبيد*احمد أو مروان*عزام*نعيمي'),
                  const Text('• النجمة (*) تعني أي نص بين الكلمات'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

