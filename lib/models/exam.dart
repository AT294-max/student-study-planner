/// Represents an upcoming exam or quiz.
class Exam {
  final String title;
  final String subject;
  final DateTime date;
  final String location;

  const Exam({
    required this.title,
    required this.subject,
    required this.date,
    this.location = 'Hall A',
  });
}
