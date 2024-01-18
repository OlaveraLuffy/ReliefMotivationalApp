class JournalEntry {

  DateTime dateTime;
  String title;
  String content;
  final String? filePath;
  int backgroundColor;
  String? imagePath;

  JournalEntry({
    DateTime? dateTime,
    this.title = 'Title',
    this.content = '',
    this.filePath,
    this.imagePath,
    int? backgroundColor,
  })  : backgroundColor = backgroundColor ?? 0xFF879d55,
        dateTime = dateTime ?? DateTime.now();

  String get strDateTime => dateTime.toIso8601String();
}