class Categories {
  final int? id;
  final String? name;
  final String? image;

  Categories({
    this.id,
    this.name,
    this.image,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      id: json['idDanhMuc'] as int?,
      name: json['TenDanhMuc'] as String?,
      image: json['AnhNen'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idDanhMuc': id,
      'TenDanhMuc': name,
      'AnhNen': image,
    };
  }
}
