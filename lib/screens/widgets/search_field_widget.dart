import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';

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
      cursorColor: AColors.primaryColor,
      controller: _searchController,
      decoration: InputDecoration(
        labelText: 'Search horns',
        labelStyle: TextStyle(
          fontFamily: 'JosefinSans',
          color: AColors.primaryColor,
        ),
        prefixIcon: Icon(
          Icons.search,
          color: AColors.primaryColor,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AColors.primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
              color: AColors.primaryColor,
              width: 1), // Red border when not focused
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
