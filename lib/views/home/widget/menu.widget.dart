import 'package:flutter/material.dart';
import 'package:thuethietbi/constants/app_color.dart';
import 'package:thuethietbi/model/caterogies_model.dart';
import 'package:thuethietbi/viewmodel/categories.vm.dart';
import 'package:thuethietbi/viewmodel/index.vm.dart';
import 'package:thuethietbi/views/home/widget/detailCaterories/detail.cate.widget.dart';
import 'package:thuethietbi/views/home/widget/item.menu.widget.dart';

class MenuWidget extends StatefulWidget {
  MenuWidget(
      {super.key,
      required this.cateViewModel,
      required this.categoriesList,
      required this.indexViewModel});
  final CategoriesViewModel cateViewModel;
  final List<Categories> categoriesList;
  final IndexViewModel indexViewModel;
  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình
    final screenWidth = MediaQuery.of(context).size.width;

    return Card(
      color: AppColor.extraColor,
      elevation: 5,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: screenWidth * 0.03),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Danh mục cho thuê',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                InkWell(
                  onTap: () {
                    widget.cateViewModel.loadCategoriesChild(0);
                    widget.cateViewModel.viewContext = context;
                    widget.indexViewModel.productViewModel
                        .getFilterProducts(0, '')
                        .then((_) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewProductByCate(
                            indexViewModel: widget.indexViewModel,
                            productViewModel:
                                widget.indexViewModel.productViewModel,
                            categoryId: 0,
                          ),
                        ),
                      );
                    });
                  },
                  child: Text(
                    'Xem tất cả >',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth * 0.03,
                      color: AppColor.oceanColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenWidth * 0.025,
          ),
          Wrap(
            spacing: screenWidth * 0.05,
            runSpacing: screenWidth * 0.07,
            children: widget.categoriesList.take(8).map((category) {
              return SizedBox(
                width: screenWidth * 0.2,
                child: ItemMenu(
                  cate: category,
                  cateViewModel: widget.cateViewModel,
                  onTap: () async {
                    widget.cateViewModel.detailCate =
                        widget.cateViewModel.lstCate.firstWhere(
                      (cate) => cate.id == category.id,
                    );
                    widget.cateViewModel.loadCategoriesChild(category.id ?? 0);
                    widget.cateViewModel.viewContext = context;
                    await widget.indexViewModel.productViewModel
                        .getFilterProducts(category.id ?? 0, '');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ViewProductByCate(
                          indexViewModel: widget.indexViewModel,
                          productViewModel:
                              widget.indexViewModel.productViewModel,
                          categoryId: category.id ?? 0,
                        ),
                      ),
                    );
                  },
                ),
              );
            }).toList(),
          ),
          SizedBox(
            height: screenWidth * 0.04,
          ),
        ],
      ),
    );
  }
}
