class HistoryEvent {
  final String title;
  final String subtext;
  final String time;
  final String humidity;
  final String inclination;

  const HistoryEvent({
    required this.title,
    required this.subtext,
    required this.time,
    required this.humidity,
    required this.inclination,
  });
}
