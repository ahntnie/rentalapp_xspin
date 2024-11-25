import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:thuethietbi/constants/api.dart';
import 'package:thuethietbi/constants/app_color.dart';
import 'package:thuethietbi/constants/app_fontsize.dart';
import 'package:thuethietbi/model/caterogies_model.dart';
import 'package:thuethietbi/viewmodel/categories.vm.dart';

class ItemMenu extends StatelessWidget {
  Categories cate;
  CategoriesViewModel cateViewModel;
  VoidCallback onTap;

  ItemMenu({
    super.key,
    required this.cate,
    required this.cateViewModel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: GestureDetector(
      onTap: () {
        onTap();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.network(
              '${API.HOST_IMAGE}${cate.image}',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Hiển thị khung màu vàng nếu có lỗi
                return Container(
                  width: 60,
                  height: 60,
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
          const SizedBox(
            height: 7,
          ),
          Text(
            cate.name ?? '',
            style: TextStyle(fontSize: AppFontSize.sizeSuperSmall),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          )
        ],
      ),
    ));
  }
}
