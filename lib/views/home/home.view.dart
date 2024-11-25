import 'package:flutter/material.dart';
import 'package:thuethietbi/base/base.page.dart';
import 'package:thuethietbi/constants/app_color.dart';
import 'package:thuethietbi/constants/app_fontsize.dart';
import 'package:thuethietbi/viewmodel/categories.vm.dart';
import 'package:thuethietbi/viewmodel/index.vm.dart';
import 'package:thuethietbi/viewmodel/product.vm.dart';
import 'package:thuethietbi/views/home/widget/detailCaterories/detail.cate.widget.dart';
import 'package:thuethietbi/views/home/widget/item.product.widget.dart';
import 'package:thuethietbi/views/home/widget/menu.widget.dart';
import 'package:thuethietbi/views/home/widget/slide/slide.widget.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatefulWidget {
  final ProductViewModel productViewModel;
  final IndexViewModel indexViewModel;

  HomeView({
    super.key,
    required this.indexViewModel,
    required this.productViewModel,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<void> _refreshData() async {
    await widget.productViewModel.getAllProducts();
    setState(() {});
  }

  final CarouselController controller = CarouselController();
  bool _isScrollToTopButtonVisible = false;
  @override
  void initState() {
    super.initState();
    widget.productViewModel.scrollController.addListener(() {
      if (widget.productViewModel.scrollController.position.pixels >=
          widget.productViewModel.scrollController.position.maxScrollExtent -
              200) {}
    });
    initializeViewModels();
    widget.productViewModel.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    bool isScrolled = widget.productViewModel.scrollController.offset >= 300;

    if (isScrolled && !_isScrollToTopButtonVisible) {
      setState(() {
        _isScrollToTopButtonVisible = true;
      });
    } else if (!isScrolled && _isScrollToTopButtonVisible) {
      setState(() {
        _isScrollToTopButtonVisible = false;
      });
    }
  }

  void initializeViewModels() async {
    CategoriesViewModel categoriesViewModel = CategoriesViewModel();
    ProductViewModel productViewModel = ProductViewModel();
    await categoriesViewModel.loadCategories();

    productViewModel.setCategories(categoriesViewModel.lstCate);
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        disposeViewModel: false,
        onViewModelReady: (viewModel) async {
          viewModel.viewContext = context;
          if (viewModel.productViewModel.lstAllProducts.isEmpty) {
            await viewModel.productViewModel.getAllProducts();
          }
          if (viewModel.categoriesViewModel.lstCate.isEmpty) {
            await viewModel.categoriesViewModel.loadCategories();
          }
          widget.productViewModel
              .setCategories(viewModel.categoriesViewModel.lstCate);
        },
        viewModelBuilder: () => widget.indexViewModel,
        builder: (context, viewModel, child) {
          return BasePage(
            showSearch: false,
            showFloating: true,
            floating: _isScrollToTopButtonVisible
                ? FloatingActionButton(
                    onPressed: () {
                      widget.productViewModel.scrollController.animateTo(
                        0,
                        duration: Duration(milliseconds: 700),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Icon(
                      Icons.arrow_upward,
                      color: AppColor.darkColor,
                      size: 28,
                    ),
                    backgroundColor: AppColor.unSelectColor.withOpacity(0.5),
                  )
                : null,
            search: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.8,
                  height: 40,
                  child: GestureDetector(
                    onTap: () {
                      viewModel.categoriesViewModel.loadCategoriesChild(0);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewProductByCate(
                                    categoryId: 0,
                                    isShowTextField: true,
                                    indexViewModel: widget.indexViewModel,
                                    productViewModel: widget.productViewModel,
                                  )));
                    },
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColor.extraColor,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        hintText: 'Tìm kiếm',
                        hintStyle: TextStyle(
                            fontSize: AppFontSize.sizeSuperSmall,
                            fontWeight: AppFontWeight.bold),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          borderSide: BorderSide(
                            color: AppColor.primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColor.primaryColor,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Image.asset(
                    'assets/XSPIN-CTTB.png',
                    width: MediaQuery.of(context).size.width / 3,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            body: widget.productViewModel.isBusy
                ? Center(
                    child: CircularProgressIndicator(
                    color: AppColor.primaryColor,
                  ))
                : RefreshIndicator(
                    color: AppColor.primaryColor,
                    onRefresh: _refreshData,
                    child: widget.productViewModel.isBusy
                        ? Center(
                            child: CircularProgressIndicator(
                            color: AppColor.primaryColor,
                          ))
                        : CustomScrollView(
                            controller:
                                viewModel.productViewModel.scrollController,
                            slivers: [
                              SliverToBoxAdapter(
                                child: Column(
                                  children: [
                                    Slide(),
                                    MenuWidget(
                                      indexViewModel: viewModel,
                                      categoriesList:
                                          viewModel.categoriesViewModel.lstCate,
                                      cateViewModel: widget
                                          .indexViewModel.categoriesViewModel,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15, top: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Thiết bị cho thuê',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                  ],
                                ),
                              ),
                              if (widget
                                  .productViewModel.lstAllProducts.isEmpty)
                                SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        1.5,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/empty.png'),
                                          SizedBox(height: 10),
                                          Text(
                                            'Không có sản phẩm nào hết!',
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              else
                                SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing:
                                        MediaQuery.of(context).size.width *
                                            0.02,
                                    mainAxisSpacing:
                                        MediaQuery.of(context).size.width *
                                            0.02,
                                    childAspectRatio: 0.57,
                                  ),
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      return ItemProduct(
                                        onTap: () {
                                          viewModel.productViewModel
                                                  .detailProducts =
                                              viewModel.productViewModel
                                                  .lstAllProducts[index];
                                          viewModel.productViewModel
                                              .viewContext = context;
                                          viewModel.productViewModel
                                              .nextDetailProduct();
                                        },
                                        productViewModel:
                                            widget.productViewModel,
                                        data: widget.productViewModel
                                            .lstAllProducts[index],
                                      );
                                    },
                                    childCount: viewModel
                                        .productViewModel.lstAllProducts.length,
                                  ),
                                ),
                            ],
                          ),
                  ),
          );
        });
  }
}
