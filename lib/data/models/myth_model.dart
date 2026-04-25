class Myth {
  final int id;
  final String name;
  final String description;
  final String createdAt;

  Myth({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  factory Myth.fromJson(Map<String, dynamic> json) {
    return Myth(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      createdAt: json['created_at'],
    );
  }
}