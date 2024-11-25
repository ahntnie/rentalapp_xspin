import 'package:flutter/material.dart';
import 'package:thuethietbi/viewmodel/categories.vm.dart';
import 'package:thuethietbi/viewmodel/product.vm.dart';
import 'package:thuethietbi/views/home/widget/detailCaterories/widget/cate_child/item.dart';

class ListItemChildCate extends StatefulWidget {
  ListItemChildCate(
      {super.key,
      required this.cateViewModel,
      required this.onOptionSelected,
      required this.productViewModel});
  CategoriesViewModel cateViewModel;
  ProductViewModel productViewModel;
  final void Function(String, String) onOptionSelected;
  @override
  State<ListItemChildCate> createState() => _ListItemChildCateState();
}

class _ListItemChildCateState extends State<ListItemChildCate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // Cuộn ngang
        itemCount: widget.cateViewModel.lstCateChild.length,
        itemBuilder: (context, index) {
          final category = widget.cateViewModel.lstCateChild[index];
          final String idCate = category.id.toString();
          return Container(
            width: MediaQuery.of(context).size.width / 3,
            child: ItemChildCate(
              data: category,
              cateViewModel: widget.cateViewModel,
              onTap: () async {
                widget.cateViewModel.detailCate = category;
                widget.cateViewModel.viewContext = context;
                widget.onOptionSelected('Hạng mục', category.name ?? '');
                print("Chọn danh mục có ID: $idCate và tên: ${category.name}");
                int selectedIdCate = int.tryParse(idCate) ?? 0;
                await widget.productViewModel
                    .getFilterProductChildCate(selectedIdCate);
              },
            ),
          );
        },
      ),
    );
  }
}
