import 'package:dio/dio.dart';
import 'package:thuethietbi/constants/api.dart';
import 'package:thuethietbi/model/products.model.dart';
import 'package:thuethietbi/services/api_services.dart';

class ProductRequest {
  final Dio dio = Dio();

  Future<List<Products>> getLstProduct() async {
    List<Products> lstProductAll = [];
    try {
      final response = await ApiService().getRequest(
        '${API.HOST_API}${API.PRODUCT}',
      );

      if (response.statusCode == API.CODE) {
        List<dynamic> data = response.data;
        // print('-----> data: $data');
        lstProductAll = data.map((json) => Products.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Products');
      }
    } catch (e) {
      print('Error: $e');
    }
    return lstProductAll;
  }

  Future<List<Products>> getProductsByCategory(int id) async {
    List<Products> lstProducts = [];
    try {
      final response = await ApiService().getRequest(
          '${API.HOST_API}${API.PRODUCT_BY_CATEGORY}?idDanhMuc=${id}',
          queryParams: {'idDanhMuc': id});

      if (response.statusCode == API.CODE) {
        List<dynamic> data = response.data;
        lstProducts = data.map((json) => Products.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Products');
      }
    } catch (e) {
      print('Error: $e');
    }
    return lstProducts;
  }

//Danh muc con
  Future<List<Products>> getProductsByCategoryChild(int id) async {
    List<Products> lstProducts = [];
    try {
      final response = await ApiService().getRequest(
          '${API.HOST_API}${API.PRODUCT_BY_CATEGORY_CHILD}?idDanhMuc=${id}',
          queryParams: {'idDanhMuc': id});

      if (response.statusCode == API.CODE) {
        List<dynamic> data = response.data;
        lstProducts = data.map((json) => Products.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Products');
      }
    } catch (e) {
      print('Error: $e');
    }
    return lstProducts;
  }

  Future<List<Products>> getProductFilter(int idCate, String idCity) async {
    List<Products> lstProductFilter = [];
    final Map<String, dynamic> body = {'idDanhMuc': idCate, 'MaTinh': idCity};
    try {
      final response = await ApiService().getRequest(
          '${API.HOST_API}${API.FILTER_PRODUCT}?idDanhMuc=${idCate}&MaTinh=${idCity}',
          queryParams: body);

      if (response.statusCode == API.CODE) {
        List<dynamic> data = response.data;
        print('--------------------- ${data}');
        lstProductFilter = data.map((json) => Products.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Products');
      }
    } catch (e) {
      print('Error: $e');
    }
    return lstProductFilter;
  }

  Future<List<Products>> getProductFilterLocation(String idCity) async {
    List<Products> lstProductFilterLocation = [];
    try {
      final response = await ApiService().getRequest(
          '${API.HOST_API}${API.FILTER_PRODUCT_LOCATION}?MaTinh=${idCity}',
          queryParams: {'MaTinh': idCity});

      if (response.statusCode == API.CODE) {
        List<dynamic> data = response.data;
        print('--------------------- ${data}');
        lstProductFilterLocation =
            data.map((json) => Products.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load Products');
      }
    } catch (e) {
      print('Error: $e');
    }
    return lstProductFilterLocation;
  }
}
