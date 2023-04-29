import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataTableDemo extends StatefulWidget {
  const DataTableDemo({super.key});

  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<DataTableDemo> {
  List<dynamic> _posts = [];
  bool _isLoading = true;
  final Set<int> _selectedRowIndices = {};

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _posts = data;
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _onRowSelected(int index, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedRowIndices.add(index);
      } else {
        _selectedRowIndices.remove(index);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('ID')),
                  DataColumn(label: Text('Title')),
                  DataColumn(label: Text('Body')),
                ],
                rows: List<DataRow>.generate(
                  _posts.length,
                  (index) => DataRow(
                    selected: _selectedRowIndices.contains(index),
                    onSelectChanged: (isSelected) =>
                        _onRowSelected(index, isSelected!),
                    cells: [
                      DataCell(Text(_posts[index]['id'].toString())),
                      DataCell(Text(_posts[index]['title'])),
                      DataCell(Text(_posts[index]['body'])),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
