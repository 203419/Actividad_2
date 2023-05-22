class Task {
  final int id;
  final String name;
  final String description;

  Task({required this.id, required this.name, required this.description});

  // Método para convertir un objeto Task en un mapa.
  // Útil para guardar el objeto en una base de datos
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  // Método para crear un objeto Task a partir de un mapa
  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      name: map['name'],
      description: map['description'],
    );
  }

  // Método para crear un objeto Task a partir de JSON
  static Task fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  // Método para convertir el objeto Task a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}
