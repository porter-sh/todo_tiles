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
    this.onLongPress = _defaultOnLongPress,
    required this.items,
  });

  /// The default onLongPress callback for the dropdown.
  static void _defaultOnLongPress({FilterMenuItem? object, int? index}) {}

  /// The currently selected value.
  final T value;

  /// The callback that is called when the user selects a value.
  final void Function(T?) onChanged;

  /// The callback that is called when the user long-presses on a value.
  final void Function({T object, int index}) onLongPress;

  /// The list of items to display in the dropdown.
  final List<T> items;

  /// Returns the widget that displays the dropdown.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).buttonTheme.colorScheme?.surface,
        borderRadius:
            (Theme.of(context).buttonTheme.shape as RoundedRectangleBorder)
                .borderRadius,
      ),
      child: DropdownButton<T>(
        value: value,
        onChanged: onChanged,
        items: List.generate(items.length, (i) {
          return DropdownMenuItem<T>(
            value: items[i],
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onLongPress: () => onLongPress(object: items[i], index: i),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(items[i].value),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
