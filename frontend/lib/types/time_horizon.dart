/// This file contains a simple enum for representing time horizons.

import 'dropdown_menu_item.dart';

/// Enum representing different lengths of time. To be used for filtering tasks
/// based on when they are due.
enum TimeHorizon implements FilterMenuItem<TimeHorizon> {
  all(string: 'All', length: Duration()),
  day(string: 'Day', length: Duration(days: 1)),
  week(string: 'Week', length: Duration(days: 7)),
  month(string: 'Month', length: Duration(days: 30)),
  ;

  const TimeHorizon({
    required this.string,
    required this.length,
  });

  final String string;
  final Duration length;

  @override
  String get value => string;
}
