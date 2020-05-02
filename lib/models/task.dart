class Task {
  final String id;
  final String name;
  final String content;
  Task({this.id, this.name, this.content});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'content': content,
    };
  }
}
