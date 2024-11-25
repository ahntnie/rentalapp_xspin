import 'package:flutter/material.dart';
import 'package:thuethietbi/constants/api.dart';
import 'package:thuethietbi/constants/app_color.dart';
import 'package:thuethietbi/model/caterogies_model.dart';
import 'package:thuethietbi/viewmodel/categories.vm.dart';

class ItemChildCate extends StatefulWidget {
  CategoriesViewModel cateViewModel;
  final Categories data;
  VoidCallback onTap;
  ItemChildCate(
      {super.key,
      required this.onTap,
      required this.cateViewModel,
      required this.data});

  @override
  State<ItemChildCate> createState() => _ItemChildCateState();
}

class _ItemChildCateState extends State<ItemChildCate> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: GestureDetector(
        onTap: widget.onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: 70,
                height: 70,
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
