class PollOption {
  String title;
  int votes;

  PollOption({required this.title, this.votes = 0});
}

class Poll {
  String question;
  List<PollOption> options;
  DateTime createdAt;
  DateTime expiresAt;

  Poll({
    required this.question,
    required this.options,
    required this.createdAt,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
