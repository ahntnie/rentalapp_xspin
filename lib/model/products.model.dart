import 'package:intl/intl.dart';

class Products {
  final int? id;
  final String? idCity;
  final int? idCate;
  final String? title;
  final String? desc;
  final double? price;
  final String? avt;
  final String? dvt;
  final String? nameUser;
  final String? phone;
  final String? district;
  final String? city;
  final String? imageBgr;
  final List<String>? images;
  final String? dateCreate;

  Products({
    this.id,
    this.idCate,
    this.idCity,
    this.avt,
    this.title,
    this.desc,
    this.price,
    this.dvt,
    // this.priceWeekend,
    this.nameUser,
    this.phone,
    this.district,
    this.city,
    this.imageBgr,
    this.images,
    this.dateCreate,
  });

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      id: json['idSanPham'] as int?,
      idCate: json['idDanhMuc'] as int?,
      title: json['TieuDe'] as String?,
      idCity: json['MaTinh'] as String?,
      desc: json['NoiDung'] as String?,
      price: (json['Gia'] != null)
          ? (json['Gia'] is int
              ? (json['Gia'] as int).toDouble()
              : json['Gia'] as double)
          : null,
      avt: json['Avatar'] as String?,
      dvt: json['Donvitinh'] as String?,
      nameUser: json['TenNguoiDung'] as String?,
      phone: json['SoDienThoai'] as String?,
      district: json['Huyen'] as String?,
      city: json['Tinh'] as String?,
      imageBgr: json['AnhNen'] as String?,
      images:
          (json['AnhNen2'] != null) ? List<String>.from(json['AnhNen2']) : [],
      dateCreate: json['NgayTao'] as String?,
    );
  }
  String get formattedPrice {
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return formatter.format(price);
  }

  String get obfuscateName {
    int length = nameUser!.length;
    if (length <= 1) return nameUser!;
    int firstHalfLength = (length / 2).ceil();
    // int secondHalfLength = length - firstHalfLength;
    return '*' * firstHalfLength + nameUser!.substring(firstHalfLength);
  }

  // String get formattedPriceWeek {
  //   final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
  //   return formatter.format(priceWeekend);
  // }
  Map<String, dynamic> toJson() {
    return {
      'idSanPham': id,
      'idDanhMuc': idCate,
      'TieuDe': title,
      'NoiDung': desc,
      'Gia': price,
      'MaTinh': idCity,
      'Avatar': avt,
      'Donvitinh': dvt,
      'TenNguoiDung': nameUser,
      'SoDienThoai': phone,
      'Huyen': district,
      'Tinh': city,
      'AnhNen': imageBgr,
      'AnhNen2': images,
      'NgayTao': dateCreate,
    };
  }
}
