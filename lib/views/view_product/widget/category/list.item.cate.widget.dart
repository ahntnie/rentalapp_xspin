import 'package:flutter/material.dart';
import 'package:products_app/viewmodel/categories.vm.dart';
import 'package:products_app/views/view_product/widget/category/item.cate.widget.dart';

// ignore: must_be_immutable
class ListItemCateWidget extends StatefulWidget {
  ListItemCateWidget(
      {super.key, required this.cateViewModel, required this.onOptionSelected});
  CategoriesViewModel cateViewModel;
  final void Function(String, String) onOptionSelected;
  @override
  State<ListItemCateWidget> createState() => _ListItemCateWidgetState();
}

class _ListItemCateWidgetState extends State<ListItemCateWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Chiều cao của widget, có thể thay đổi theo yêu cầu
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Cuộn ngang
        itemCount: widget.cateViewModel.lstCate.length,
        itemBuilder: (context, index) {
          final category = widget.cateViewModel.lstCate[index];
          final String idCate = category.id.toString();
          return Container(
            width: MediaQuery.of(context).size.width / 3,
            child: ItemCateWidget(
              data: category,
              cateViewModel: widget.cateViewModel,
              onTap: () {
                widget.cateViewModel.detailCate = category;
                widget.cateViewModel.viewContext = context;
                widget.onOptionSelected('Loại sản phẩm', category.name ?? '');
                print("Chọn danh mục có ID: $idCate và tên: ${category.name}");
              },
            ),
          );
        },
      ),
    );
  }
}
