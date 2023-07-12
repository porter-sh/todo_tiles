/// This file contains a widget that displays a list of choices in a dropdown
/// for filtering tasks on the home page.

import 'package:flutter/material.dart';

import '../types/dropdown_menu_item.dart';

/// Public class [FilterDropdown] is a [StatelessWidget] that creates a dropdown
/// for filtering tasks on the home page. The choices are passed in as a list of
/// [FilterMenuItem]s.
class FilterDropdown<T extends FilterMenuItem<T>> extends StatelessWidget {
  /// Creates a [FilterDropdown] widget.
  const FilterDropdown({
    super.key,
    required this.value,
    required this.onChanged,
    required this.items,
  });

  /// The currently selected value.
  final T value;

  /// The callback that is called when the user selects a value.
  final void Function(T?) onChanged;

  /// The list of items to display in the dropdown.
  final List<T> items;

  /// Returns the widget that displays the dropdown.
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DropdownButton<T>(
        value: value,
        onChanged: onChanged,
        items: items.map((T item) {
          return DropdownMenuItem<T>(
            value: item,
            child: Text(item.value),
          );
        }).toList(),
      ),
    );
  }
}
