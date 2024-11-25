import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:thuethietbi/base/base.page.dart';
import 'package:thuethietbi/constants/api.dart';
import 'package:thuethietbi/constants/app_color.dart';
import 'package:thuethietbi/constants/app_fontsize.dart';
import 'package:thuethietbi/model/products.model.dart';
import 'package:thuethietbi/viewmodel/product.vm.dart';
import 'package:thuethietbi/views/home/widget/axis/lst.scroll.widget.dart';
import 'package:thuethietbi/views/home/widget/detailCaterories/widget/dialog/dialog.dart';
import 'package:thuethietbi/views/home/widget/full_image.dart';

class DetailItem extends StatefulWidget {
  final Products data;
  final ProductViewModel productViewModel;
  final int categoryId;
  const DetailItem(
      {super.key,
      required this.productViewModel,
      required this.data,
      required this.categoryId});

  @override
  State<DetailItem> createState() => _DetailItemState();
}

class _DetailItemState extends State<DetailItem> {
  late PageController _pageController;
  int _currentPage = 0;
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _nextPage() {
    if (_currentPage < widget.data.images!.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _loadCategoryDetail() async {
    if (widget.categoryId != 0) {
      await widget.productViewModel.getCategoryById(widget.categoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryName = widget.productViewModel.detailCate?.name ?? 'Unknown';
    return BasePage(
      title: widget.data.title,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.productViewModel.isBusy
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          final images = (widget.data.images == null ||
                                  widget.data.images!.isEmpty)
                              ? ['${API.HOST_IMAGE}${widget.data.imageBgr}']
                              : widget.data.images!
                                  .map((img) => '${API.HOST_IMAGE}$img')
                                  .toList();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImageView(
                                images: images,
                                initialIndex: _currentPage,
                              ),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 300, // Chiều cao cố định cho phần hình ảnh
                          child: (widget.data.images == null ||
                                  widget.data.images!.isEmpty)
                              ? Image.network(
                                  '${API.HOST_IMAGE}${widget.data.imageBgr}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: double.infinity,
                                      color: AppColor.extraColor,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                        size: 60,
                                      ),
                                    );
                                  },
                                ) // Hiển thị imageBgr nếu images rỗng
                              : PageView.builder(
                                  controller: _pageController,
                                  itemCount: widget.data.images!.length,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _currentPage = index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    return Image.network(
                                      '${API.HOST_IMAGE}${widget.data.images![index]}',
                                      fit: BoxFit.contain,
                                      width: double.infinity,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: double.infinity,
                                          color: AppColor.extraColor,
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey,
                                            size: 24,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                        ),
                      ),
                      if (widget.data.images != null &&
                          widget.data.images!.isNotEmpty) ...[
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            color: Colors.black54,
                            child: Text(
                              '${_currentPage + 1}/${widget.data.images!.length}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 100,
                          left: 10,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back,
                                color: AppColor.darkColor),
                            onPressed: _previousPage,
                          ),
                        ),
                        Positioned(
                          top: 100,
                          right: 10,
                          child: IconButton(
                            icon: Icon(Icons.arrow_forward,
                                color: AppColor.darkColor),
                            onPressed: _nextPage,
                          ),
                        ),
                      ]
                    ],
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.data.title ?? '',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: AppFontSize.sizeMedium,
                    fontWeight: FontWeight.w800),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                categoryName,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: AppFontSize.sizeSmall, color: Colors.grey[600]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                '${widget.data.formattedPrice} / ${widget.data.dvt}',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: AppFontSize.sizeMedium,
                    fontWeight: FontWeight.w700,
                    color: Colors.red),
              ),
            ),
            SizedBox(height: 5),
            if (widget.data.district!.isNotEmpty ||
                widget.data.city!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Row(
                  children: [
                    Icon(Icons.location_on_outlined),
                    SizedBox(width: 5),
                    Text(
                      '${widget.data.district} - ${widget.data.city}',
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: AppFontSize.sizeSmall,
                          color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Row(
                children: [
                  Icon(Icons.access_time_outlined),
                  SizedBox(width: 5),
                  Text(
                    widget.data.dateCreate ?? '',
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: AppFontSize.sizeSmall,
                        color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                  horizontal: 10.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade500),
                ),
                child: Row(
                  children: [
                    if (widget.data.avt != null)
                      ClipOval(
                        child: Image.network(
                          '${API.HOST_IMAGE}${widget.data.avt}',
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 30, // Chiều rộng mong muốn
                              height: 30,
                              color: AppColor.extraColor,
                              child: Image.asset(
                                'assets/logo_app.png',
                                width: 25,
                                height: 25,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        ),
                      )
                    else if (widget.data.avt!.isEmpty || widget.data.avt == '')
                      Image.asset(
                        'assets/logo_app.png',
                        width: 50,
                        height: 50,
                      ),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data.nameUser ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: AppFontSize.sizePrice,
                                fontWeight: FontWeight.w900),
                          ),
                          InkWell(
                            onTap: () {
                              FlutterPhoneDirectCaller.callNumber(
                                  '+${widget.data.phone}');
                            },
                            child: Text(
                              widget.data.phone ?? '',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: AppColor.oceanColor,
                                  fontSize: AppFontSize.sizeSuperSmall,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        showInfoDialog(context, widget.productViewModel,
                            widget.data.id ?? 0);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Tư vấn ngay',
                            style: TextStyle(
                              color: AppColor.extraColor,
                              fontWeight: FontWeight.bold,
                              fontSize: AppFontSize.sizeSuperSmall,
                            ),
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.send,
                            color: AppColor.extraColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            Divider(
              thickness: 8,
              color: AppColor.dividerColor,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mô tả chi tiết',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Text(
                    widget.data.desc?.replaceAll('<br>', '\n').trim() ?? '',
                    softWrap: true,
                  ),
                  // if (widget.data.nameUser!.isNotEmpty)
                  //   Row(
                  //     children: [
                  //       Text('Người đăng bài: '),
                  //       Text(
                  //         widget.data.nameUser ?? '',
                  //         maxLines: 1,
                  //         overflow: TextOverflow.ellipsis,
                  //         style: TextStyle(
                  //             fontSize: AppFontSize.sizeSmall,
                  //             fontWeight: FontWeight.w900),
                  //       ),
                  //     ],
                  //   ),
                  // if (widget.data.phone!.isNotEmpty)
                  //   InkWell(
                  //     onTap: () {
                  //       FlutterPhoneDirectCaller.callNumber('+0915660068');
                  //       // launchUrlString('tel:+1231231231232');
                  //     },
                  //     child: Text(
                  //       'Liên hệ ngay: ${widget.data.phone}',
                  //       style: TextStyle(color: AppColor.oceanColor),
                  //     ),
                  //   ),
                ],
              ),
            ),
            Divider(
              thickness: 8,
              color: AppColor.dividerColor,
            ),
            if (widget.productViewModel
                .getSimilarProducts(widget.categoryId, widget.data.id!)
                .isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tin đăng tương tự',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    LstProductScroll(
                      data: widget.productViewModel.getSimilarProducts(
                          widget.categoryId, widget.data.id!),
                      productViewModel: widget.productViewModel,
                    )
                  ],
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tin đăng tương tự',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    LstProductScroll(
                      data: widget.productViewModel.lstAllProducts,
                      productViewModel: widget.productViewModel,
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
