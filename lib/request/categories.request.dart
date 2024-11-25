import 'package:dio/dio.dart';
import 'package:thuethietbi/constants/api.dart';
import 'package:thuethietbi/model/caterogies_model.dart';
import 'package:thuethietbi/services/api_services.dart';

class CategoriesRequest {
  final Dio dio = Dio();
  Future<List<Categories>> getCategories() async {
    List<Categories> lstCate = [];
    try {
      final response = await ApiService().getRequest(
        '${API.HOST_API}${API.CATEGORY}',
      );
      if (response.statusCode == API.CODE) {
        List<dynamic> data = response.data;
        lstCate = data.map((json) => Categories.fromJson(json)).toList();
      } else {
        throw Exception('Không tải được sản phẩm');
      }
    } catch (e) {
      print('Lỗsssi: $e');
    }
    return lstCate;
  }

  Future<List<Categories>> getCategoriesChild(int id) async {
    List<Categories> lstCate = [];
    try {
      final response = await ApiService().getRequest(
          '${API.HOST_API}${API.CATEGORY}?idCapCha=${id}',
          queryParams: {'idCapCha:': id});
      if (response.statusCode == API.CODE) {
        List<dynamic> data = response.data;
        lstCate = data.map((json) => Categories.fromJson(json)).toList();
      } else {
        throw Exception('Không tải được sản phẩm');
      }
    } catch (e) {
      print('Lỗsssi: $e');
    }
    return lstCate;
  }

  Future<Categories?> getCategoryById(int id) async {
    try {
      final response = await ApiService().getRequest(
        '${API.HOST_API}${API.CATEGORY_BY_ID}?idDanhMuc=$id',
        queryParams: {'idDanhMuc': id},
      );

      if (response.statusCode == API.CODE) {
        List<dynamic> data = response.data;
        print('Data danh mục $data');
        if (data.isNotEmpty) {
          return Categories.fromJson(data.first);
        } else {
          print('Không tìm thấy danh mục với idCapCha = $id');
          return null; // Hoặc trả về một danh mục mặc định
        }
      } else {
        throw Exception('Lỗi khi tải danh mục');
      }
    } catch (e) {
      print('Lỗi: $e');
      return null; // Hoặc trả về danh mục mặc định
    }
  }
}
