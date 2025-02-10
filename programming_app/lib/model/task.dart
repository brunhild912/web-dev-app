class Task {
  final String heading;
  final String description;
  final String dateAssigned;
  final String deadline;
  bool isDone;
  final String id;

  Task( {
    required this.heading,
    required this.description,
    required this.dateAssigned,
    required this.deadline,
    this.isDone = false, required  this.id,
  });
}
