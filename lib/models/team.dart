class Team {
  final String id;
  final String name;
  final String description;
  final List<String> employeeIds;
  final String? managerId;

  Team({
    required this.id,
    required this.name,
    required this.description,
    required this.employeeIds,
    this.managerId,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      employeeIds: List<String>.from(json['employeeIds'] ?? []),
      managerId: json['managerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'employeeIds': employeeIds,
      'managerId': managerId,
    };
  }

  Team copyWith({
    String? id,
    String? name,
    String? description,
    List<String>? employeeIds,
    String? managerId,
  }) {
    return Team(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      employeeIds: employeeIds ?? this.employeeIds,
      managerId: managerId ?? this.managerId,
    );
  }
}