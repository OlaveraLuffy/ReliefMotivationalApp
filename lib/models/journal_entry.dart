class JournalEntry {

  DateTime dateTime;
  String title;
  String content;
  final String? filePath;
  int backgroundColor;

  JournalEntry({
    DateTime? dateTime,
    this.title = 'Title',
    this.content = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus at rutrum metus, eget semper felis. Morbi blandit metus consectetur eros sollicitudin, a tempus ipsum blandit. Aenean feugiat aliquam egestas. Suspendisse dolor ipsum, imperdiet eget nibh sit amet, pretium malesuada tellus. Mauris ultricies, erat eu maximus viverra, elit sem commodo mauris, eget vestibulum velit nisl nec lorem. Ut convallis vulputate maximus. Vestibulum sit amet elementum lorem, non maximus turpis. Mauris at velit blandit, volutpat risus id, finibus diam. Quisque a fringilla ipsum.',
    this.filePath,
    int? backgroundColor,
  })  : backgroundColor = backgroundColor ?? 0xFF879d55,
        dateTime = dateTime ?? DateTime.now();

  String get strDateTime => dateTime.toIso8601String();
}