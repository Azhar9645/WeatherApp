class City {
  final String name;
  final DateTime datetime;

  City({
    required this.name,
    required this.datetime,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] ?? 'Unknown City', // Provide a default value or handle null
      datetime: json['datetime'] != null ? DateTime.parse(json['datetime']) : DateTime.now(), // Handle null datetime
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'datetime': datetime.toIso8601String(),
    };
  }
}
