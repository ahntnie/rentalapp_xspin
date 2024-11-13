import 'package:flutter/material.dart';

import 'package:products_app/constants/api.dart';
import 'package:products_app/constants/app_color.dart';
import 'package:products_app/model/caterogies_model.dart';
import 'package:products_app/viewmodel/categories.vm.dart';

class ItemWidget extends StatefulWidget {
  CategoriesViewModel cateViewModel;
  final Categories data;

  VoidCallback onTap;
  ItemWidget(
      {super.key,
      required this.onTap,
      required this.cateViewModel,
      required this.data});

  @override
  State<ItemWidget> createState() => _ItemCateWidgetState();
}

class _ItemCateWidgetState extends State<ItemWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0), // Bo góc nếu cần
              child: Container(
                width: 70, // Chiều rộng mong muốn
                height: 70, // Chiều cao mong muốn
                child: Image.network(
                  '${API.HOST_IMAGE}${widget.data.image}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Hiển thị khung màu vàng nếu có lỗi
                    return Container(
                      width: double.infinity,
                      height: 120,
                      color: AppColor.extraColor,
                      child: const Icon(
                        Icons.image_not_supported, // Biểu tượng thay thế
                        color: Colors.grey,
                        size: 24,
                      ),
                    );
                  },
                ),
              ),
            ),
            Text(widget.data.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold))
          ],
        ),
      ),
    );
  }
}
