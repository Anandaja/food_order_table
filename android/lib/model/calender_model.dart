class Calendar {
  final DateTime date;
  final bool thisMonth;
  final bool prevMonth;
  final bool nextMonth;
  bool isPrebooked; // Add this property

  Calendar({
    required this.date,
    this.thisMonth = false,
    this.prevMonth = false,
    this.nextMonth = false,
    this.isPrebooked = false, // Initialize it to false by default
  });
}
