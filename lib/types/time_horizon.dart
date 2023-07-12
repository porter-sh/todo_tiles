import 'dropdown_menu_item.dart';

/// This file contains a simple enum for representing time horizons.

/// Enum representing different lengths of time. To be used for filtering tasks
/// based on when they are due.
enum TimeHorizon implements FilterMenuItem<TimeHorizon> {
  day(string: 'Day'),
  week(string: 'Week'),
  month(string: 'Month'),
  all(string: 'All');

  const TimeHorizon({required this.string});

  final String string;

  @override
  String get value => string;
}
