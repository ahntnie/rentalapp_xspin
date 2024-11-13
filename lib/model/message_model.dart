class MessageModel {
  final int? id;
  final String? soDienThoai;
  final String? hoTen;
  final String? noiDung;

  MessageModel({
    this.id,
    this.soDienThoai,
    this.hoTen,
    this.noiDung,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['idBaiDang'] as int?,
      soDienThoai: json['SoDienThoai'] as String?,
      hoTen: json['Hoten'] as String?,
      noiDung: json['NoiDung'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idBaiDang': id,
      'SoDienThoai': soDienThoai,
      'Hoten': hoTen,
      'NoiDung': noiDung,
    };
  }
}
