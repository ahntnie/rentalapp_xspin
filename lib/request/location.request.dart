import 'package:dio/dio.dart';
import 'package:thuethietbi/constants/api.dart';
import 'package:thuethietbi/model/location.model.dart';
import 'package:thuethietbi/services/api_services.dart';

class LocationRequest {
  final Dio dio = Dio();
  Future<List<Location>> getLocations() async {
    List<Location> lstLocation = [];
    try {
      final response = await ApiService().getRequest(
        '${API.HOST_API}${API.LOCATION}',
      );
      if (response.statusCode == API.CODE) {
        List<dynamic> data = response.data;
        lstLocation = data.map((json) => Location.fromJson(json)).toList();
      } else {
        throw Exception('Không tải được sản phẩm');
      }
    } catch (e) {
      print('Lỗsssi: $e');
    }
    return lstLocation;
  }
}
