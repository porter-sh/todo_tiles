/// This file defines the [FilterMenuItem] interface, so that different types
/// can be used in the [FilterDropdown] widget.

/// Public class [FilterMenuItem] is an interface for dropdown menu items.
abstract class FilterMenuItem<T> {
  /// The value of the item.
  String get value;
}
