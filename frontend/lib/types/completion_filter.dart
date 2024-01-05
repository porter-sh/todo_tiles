/// This file contains the simple [CompletionFilter] enum for representing
/// different levels of completion of tasks for filtering.

/// Enum representing different levels of completion of tasks. To be used for
/// filtering tasks based on their completion status.
enum CompletionFilter {
  // Do not filter tasks.
  all(string: 'all'),
  // Only show completed tasks.
  complete(string: 'complete'),
  // Only show incomplete tasks.
  incomplete(string: 'incomplete'),
  // Only show tasks that were already due, but not completed.
  overdue(string: 'overdue'),
  // Only show tasks that are due in the future.
  upcoming(string: 'upcoming'),
  ;

  const CompletionFilter({
    required this.string,
  });

  final String string;
}
