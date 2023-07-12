/// This file contains a simple enum for representing time horizons.

/// Enum representing different lengths of time. To be used for filtering tasks
/// based on when they are due.
enum TimeHorizon {
  /// Things taking place today.
  day,

  /// Things taking place this week.
  week,

  /// Things taking place in the next month.
  month,

  /// All future things.
  all,
}
