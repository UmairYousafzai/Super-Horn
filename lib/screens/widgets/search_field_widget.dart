import 'package:flutter/material.dart';

class SearchFieldWidget extends StatelessWidget {
  const SearchFieldWidget({
    super.key,
    required TextEditingController searchController,
    required this.focusNode,
  }) : _searchController = searchController;
  final FocusNode focusNode;

  final TextEditingController _searchController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      focusNode: focusNode,
      cursorColor: Colors.red.shade400,
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Search horns',
        labelStyle: TextStyle(color: Colors.red.shade400),
        prefixIcon: Icon(
          Icons.search,
          color: Colors.red.shade400,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red.shade400, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: Colors.red.shade200,
              width: 1), // Red border when not focused
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
