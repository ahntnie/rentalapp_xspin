import 'package:dio/dio.dart';
import 'package:thuethietbi/constants/api.dart';
import 'package:thuethietbi/model/message_model.dart';
import 'package:thuethietbi/services/api_services.dart';

class MessageRequest {
  final Dio dio = Dio();

  Future<MessageModel> postMessage(MessageModel message) async {
    try {
      final response = await ApiService().postRequest(
        '${API.HOST_API}${API.POST_MESSAGE}',
        queryParameters: {
          "idBaiDang": message.id,
          "SoDienThoai": message.soDienThoai,
          "Hoten": message.hoTen,
          "NoiDung": message.noiDung,
        },
      );
      print('Response data: ${response.data}');

      if (response.statusCode == API.CODE) {
        if (response.data is String) {
          print('Thông báo từ server: ${response.data}');
          return MessageModel(
            id: message.id,
            soDienThoai: message.soDienThoai,
            hoTen: message.hoTen,
            noiDung: message.noiDung,
          );
        } else if (response.data is Map<String, dynamic>) {
          return MessageModel.fromJson(response.data);
        } else {
          throw Exception('Dữ liệu phản hồi không đúng định dạng.');
        }
      } else {
        throw Exception('Không thể đăng thông điệp');
      }
    } catch (e) {
      print('Lỗi: $e');
      throw Exception('Đã xảy ra lỗi khi gửi thông điệp');
    }
  }
}
