import 'package:dio/dio.dart';
import 'package:products_app/constants/api.dart';
import 'package:products_app/model/caterogies_model.dart';
import 'package:products_app/services/api_services.dart';

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
}
