class Location {
  final String id;
  final String name;

  // Constructor
  Location({
    required this.id,
    required this.name,
  });

  // Factory method để tạo đối tượng từ JSON
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['MaTinh'] as String,
      name: json['TenTinh'] as String,
    );
  }

  // Phương thức để chuyển đối tượng thành JSON
  Map<String, dynamic> toJson() {
    return {
      'MaTinh': id,
      'TenTinh': name,
    };
  }
}
