import 'package:flutter/material.dart';
import 'package:products_app/model/products.model.dart';
import 'package:products_app/viewmodel/product.vm.dart';
import 'package:products_app/views/home/widget/item.product.widget.dart';

class LstProductScroll extends StatefulWidget {
  final ProductViewModel productViewModel;
  final List<Products> data;

  const LstProductScroll({
    super.key,
    required this.data,
    required this.productViewModel,
  });

  @override
  State<LstProductScroll> createState() => _ListProductsState();
}

class _ListProductsState extends State<LstProductScroll> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 350,
      child: ListView.builder(
        padding: EdgeInsets.all(8.0),
        scrollDirection: Axis.horizontal,
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          return Container(
            width: 200,
            margin: EdgeInsets.only(right: 8.0),
            child: ItemProduct(
              onTap: () {
                widget.productViewModel.detailProducts = widget.data[index];
                widget.productViewModel.viewContext = context;
                widget.productViewModel.nextDetailProduct();
              },
              productViewModel: widget.productViewModel,
              data: widget.data[index],
            ),
          );
        },
      ),
    );
  }
}
