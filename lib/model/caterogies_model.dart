class Categories {
  final int? id;
  final String? name;
  final String? image;
  final int? idCha;
  final int? viTri;
  final List<String>? idChild;
  // List<Categories> childCategories = [];
  Categories(
      {this.id, this.name, this.image, this.idCha, this.viTri, this.idChild});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
        id: json['idDanhMuc'] as int?,
        name: json['TenDanhMuc'] as String?,
        image: json['AnhNen'] as String?,
        idCha: json['IdCapCha'] as int?,
        idChild: (json['IdDanhMucCon'] != null)
            ? List<String>.from(json['IdDanhMucCon'])
            : [],
        viTri: json['ViTri'] as int?);
  }

  Map<String, dynamic> toJson() {
    return {
      'idDanhMuc': id,
      'TenDanhMuc': name,
      'AnhNen': image,
      'IdCapCha': idCha,
      'ViTri': viTri,
      'IdDanhMucCon': idChild
    };
  }
}
