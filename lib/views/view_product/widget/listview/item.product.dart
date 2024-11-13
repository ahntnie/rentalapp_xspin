import 'package:flutter/material.dart';
import 'package:products_app/constants/api.dart';
import 'package:products_app/constants/app_color.dart';
import 'package:products_app/constants/app_fontsize.dart';
import 'package:products_app/model/products.model.dart';
import 'package:products_app/viewmodel/product.vm.dart';

class ItemProductList extends StatefulWidget {
  final ProductViewModel productViewModel;
  final VoidCallback onTap;
  final Products data;
  ItemProductList({
    super.key,
    required this.onTap,
    required this.data,
    required this.productViewModel,
  });

  @override
  State<ItemProductList> createState() => _ItemProductState();
}

class _ItemProductState extends State<ItemProductList> {
  @override
  Widget build(BuildContext context) {
    String categoryName =
        widget.productViewModel.getCategoryNameForProduct(widget.data);
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 2,
          color: AppColor.extraColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          '${API.HOST_IMAGE}${widget.data.imageBgr}', // Thay link ảnh sản phẩm
                          width: 150, // Chiều rộng mong muốn
                          height: 160,

                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 120, // Chiều rộng mong muốn
                              height: 140,
                              color: AppColor.extraColor,
                              child: const Icon(
                                Icons
                                    .image_not_supported, // Biểu tượng thay thế
                                color: Colors.grey,
                                size: 24,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      // Product Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.data.title ?? '',
                              style: TextStyle(
                                fontSize: AppFontSize.sizeSmall,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${widget.data.formattedPrice} / ${widget.data.dvt}',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: AppFontSize.sizeSmall,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (widget.data.avt != null)
                                  ClipOval(
                                    child: Image.network(
                                      '${API.HOST_IMAGE}${widget.data.avt}',
                                      width: 30,
                                      height: 30,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                else if (widget.data.avt!.isEmpty ||
                                    widget.data.avt == '')
                                  Image.asset(
                                    'assets/logo_app.png',
                                    width: 25,
                                    height: 25,
                                    fit: BoxFit.cover,
                                  ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.data.nameUser ?? '',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600]),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_city,
                                  color: AppColor.primaryColor,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    '${widget.data.district} - ${widget.data.city}',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: AppFontSize.sizeSuperSmall,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 10),

                // Additional Information - this will expand vertically if text is long
              ],
            ),
          ),
        ),
      ),
    );
  }
}
