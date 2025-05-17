class Participant {
  final String id;
  final String name;
  final int bib;

  Participant({required this.id, required this.name, required this.bib});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Participant &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
