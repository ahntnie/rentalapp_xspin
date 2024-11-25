import 'package:flutter/material.dart';
import 'package:thuethietbi/constants/app_color.dart';
import 'package:thuethietbi/constants/app_fontsize.dart';
import 'package:thuethietbi/viewmodel/product.vm.dart';

void showInfoDialog(BuildContext context, ProductViewModel viewModel, int id) {
  String? phoneError;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            contentPadding: EdgeInsets.all(20),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipOval(
                    child: Image.asset(
                      'assets/logo_app.png',
                      height: 60,
                      width: 60,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Bạn vui lòng điền thông tin để XSPIN có thể tư vấn tốt nhất nhé!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 50),
                  _buildTextField(
                    controller: viewModel.phone,
                    icon: Icons.phone,
                    hintText: "Số điện thoại",
                    errorText: phoneError,
                    type: TextInputType.number,
                    onClear: () {
                      setState(() {
                        viewModel.phone.clear();
                        phoneError = null;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: viewModel.name,
                    icon: Icons.person,
                    hintText: "Họ tên",
                    onClear: viewModel.name.clear,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: viewModel.desc,
                    icon: Icons.description,
                    hintText: "Nội dung",
                    onClear: viewModel.desc.clear,
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      phoneError = viewModel.phone.text.isEmpty
                          ? "Vui lòng nhập số điện thoại"
                          : !RegExp(r'^(?:\+84|0)(3|5|7|8|9)\d{8}$')
                                  .hasMatch(viewModel.phone.text)
                              ? "Vui lòng nhập số điện thoại hợp lệ"
                              : null;
                    });

                    if (phoneError == null) {
                      final name = viewModel.name.text.isEmpty
                          ? "Khách hàng"
                          : viewModel.name.text;
                      final desc = viewModel.desc.text.isEmpty
                          ? "Xin được tư vấn"
                          : viewModel.desc.text;

                      viewModel.name.text = name;
                      viewModel.desc.text = desc;

                      viewModel.post(id);

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Cảm ơn bạn đã quan tâm đến chúng tôi"),
                          backgroundColor: AppColor.greenS,
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Chúng tôi sẽ liên hệ bạn sớm nhất 🤗"),
                          backgroundColor: AppColor.greenS,
                        ),
                      );
                      viewModel.name.clear();
                      viewModel.phone.clear();
                      viewModel.desc.clear();
                    }
                  },
                  child: Text(
                    "Xác nhận",
                    style: TextStyle(
                      color: AppColor.extraColor,
                      fontWeight: FontWeight.bold,
                      fontSize: AppFontSize.sizeSuperSmall,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Widget _buildTextField({
  required TextEditingController controller,
  required IconData icon,
  required String hintText,
  TextInputType? type,
  String? errorText,
  required VoidCallback onClear,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextField(
        keyboardType: type,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          suffixIcon: IconButton(
            onPressed: onClear,
            icon: Icon(Icons.close_sharp),
          ),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey),
          contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade500),
          ),
          errorText: errorText,
        ),
      ),
    ],
  );
}
