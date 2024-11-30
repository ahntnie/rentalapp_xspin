import 'package:flutter/material.dart';
import 'package:thuethietbi/constants/api.dart';
import 'package:thuethietbi/constants/app_color.dart';
import 'package:thuethietbi/constants/app_fontsize.dart';
import 'package:thuethietbi/model/products.model.dart';
import 'package:thuethietbi/viewmodel/product.vm.dart';

class ItemProduct extends StatefulWidget {
  ProductViewModel productViewModel;
  final VoidCallback onTap;
  final Products data;
  ItemProduct(
      {super.key,
      required this.onTap,
      required this.data,
      required this.productViewModel});

  @override
  State<ItemProduct> createState() => _ItemProductState();
}

class _ItemProductState extends State<ItemProduct> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.onTap,
        child: SizedBox(
          height: 500,
          child: Card(
              color: AppColor.extraColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        '${API.HOST_IMAGE}${widget.data.imageBgr}', // Thay link ảnh sản phẩm
                        width: double.infinity,
                        height: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 180,
                            color: AppColor.extraColor,
                            child: const Icon(
                              Icons.image_not_supported, // Biểu tượng thay thế
                              color: Colors.grey,
                              size: 80,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      height: 40,
                      child: Text(
                        widget.data.title ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppFontSize.sizeSuperSmall,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        widget.data.nameUser ?? 'Guest',
                        style: TextStyle(
                          fontSize: AppFontSize.sizeSuperSmall,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // SizedBox(height: 2),
                    Flexible(
                      child: Text(
                        '${widget.data.formattedPrice}₫ / ${widget.data.dvt}',
                        style: TextStyle(
                            fontSize: AppFontSize.sizeSuperSmall,
                            color: Colors.red[600],
                            fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.store,
                          color: AppColor.primaryColor,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${widget.data.city}',
                            style: TextStyle(
                                fontSize: AppFontSize.sizeSuperSmall3,
                                fontWeight: FontWeight.w400),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ));
  }
}
