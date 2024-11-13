import 'package:flutter/material.dart';
import 'package:products_app/base/base.page.dart';
import 'package:products_app/constants/app_color.dart';
import 'package:products_app/constants/app_fontsize.dart';
import 'package:products_app/viewmodel/categories.vm.dart';
import 'package:products_app/viewmodel/index.vm.dart';
import 'package:products_app/viewmodel/product.vm.dart';
import 'package:products_app/views/home/widget/detailCaterories/widget/fillter.widget.dart';
import 'package:products_app/views/home/widget/detailCaterories/widget/fliter.location.widget.dart';
import 'package:products_app/views/home/widget/detailCaterories/widget/list.item.cate.widget.dart';
import 'package:products_app/views/view_product/widget/listview/item.product.dart';
import 'package:stacked/stacked.dart';

class ViewProductByCate extends StatefulWidget {
  final ProductViewModel productViewModel;
  final IndexViewModel indexViewModel;
  final int categoryId;
  final bool isShowTextField;
  const ViewProductByCate(
      {super.key,
      this.isShowTextField = false,
      required this.indexViewModel,
      required this.productViewModel,
      required this.categoryId});

  @override
  State<ViewProductByCate> createState() => _ViewProductByCateState();
}

class _ViewProductByCateState extends State<ViewProductByCate> {
  late TextEditingController _searchController;
  bool _isScrollToTopButtonVisible = false;
  bool isSelectedFromMenu = false;
  bool isCategoryListVisible = true;
  // bool isAllSelectedCategory = false;
  // bool isAllSelectedLocation = false;
  bool isLocationListVisible = true;
  Map<String, String> _selectedOptions = {
    'Khu vực': 'Toàn quốc',
    'Loại sản phẩm': 'Tất cả',
  };
  String _selectedCategoryId = '';
  String _selectedCityId = '';

  void _handleOptionSelected(String filterType, String option) {
    setState(() {
      _selectedOptions[filterType] = option;
    });

    if (filterType == 'Khu vực') {
      if (option == "Toàn quốc") {
        isLocationListVisible = true;
        _selectedCityId = '';
      } else {
        isLocationListVisible = false;
        final selectedLocation = widget
            .indexViewModel.locationViewModel.lstLocation
            .firstWhere((location) => location.name == option);
        _selectedCityId = selectedLocation.id;
      }
    } else if (filterType == 'Loại sản phẩm') {
      if (option == "Tất cả" || option.isEmpty) {
        isCategoryListVisible = true;
        _selectedCategoryId = '';
        widget.productViewModel.lstFilterProduct.clear();
      } else {
        isCategoryListVisible = false;

        final selectedCategory = widget
            .indexViewModel.categoriesViewModel.lstCate
            .firstWhere((category) => category.name == option);

        _selectedCategoryId = selectedCategory.id.toString(); // Lưu ID danh mục
        int selectedIdCate = int.tryParse(_selectedCategoryId) ?? 0;
        widget.productViewModel.getFilterProducts(selectedIdCate, '').then((_) {
          setState(() {});
        });
      }
    }
    int selectedIdCate = int.tryParse(_selectedCategoryId) ?? 0;
    if (isCategoryListVisible && isLocationListVisible) {
      widget.productViewModel.getFilterProducts(0, '').then((_) {
        setState(() {});
      });
    } else if (isCategoryListVisible && !isLocationListVisible) {
      widget.productViewModel.getFilterProducts(0, _selectedCityId).then((_) {
        setState(() {});
      });
    } else if (!isCategoryListVisible && isLocationListVisible) {
      widget.productViewModel.getFilterProducts(selectedIdCate, '').then((_) {
        setState(() {});
      });
    } else {
      widget.productViewModel
          .getFilterProducts(selectedIdCate, _selectedCityId)
          .then((_) {
        setState(() {});
      });
    }
  }

  Future<void> _isBusy() async {
    setState(() {
      widget.productViewModel.setBusy(true);
    });
  }

  Future<void> _notBusy() async {
    setState(() {
      widget.productViewModel.setBusy(false);
    });
  }

  @override
  void initState() {
    super.initState();
    _isBusy();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      _onSearchChanged();
    });
    print("Category ID: ${widget.categoryId}");
    if (widget.categoryId > 0) {
      _selectedOptions['Loại sản phẩm'] = widget
              .indexViewModel.categoriesViewModel.lstCate
              .firstWhere((cate) => cate.id == widget.categoryId)
              .name ??
          'Không xác định';
      isSelectedFromMenu = true;
      widget.productViewModel.getFilterProducts(widget.categoryId, '');
    } else if (widget.categoryId == 0) {
      isSelectedFromMenu = true;
      isCategoryListVisible = true;
      widget.productViewModel.getFilterProducts(0, '');
      // print(
      //     'data khi khởi tạo --> ${widget.productViewModel.lstFilterProduct.length}');
    }

    // Đặt sự kiện listener cho scrollController
    widget.productViewModel.scrollController3.addListener(() {
      if (widget.productViewModel.scrollController3.position.pixels >=
          widget.productViewModel.scrollController3.position.maxScrollExtent -
              200) {
        print('Reached near the end of the list');
      }
    });
    widget.productViewModel.scrollController3.addListener(_scrollListener);
    initializeViewModels();
    _notBusy();
  }

  void _scrollListener() {
    bool isScrolled = widget.productViewModel.scrollController3.offset >= 1000;

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

  Future<void> _refreshData() async {
    int selectedIdCate = int.tryParse(_selectedCategoryId) ?? 0;
    String cityId = _selectedCityId;

    await widget.productViewModel.getFilterProductView(selectedIdCate, cityId);
    await widget.indexViewModel.categoriesViewModel.loadCategories();
    await widget.indexViewModel.locationViewModel.loadLocations();
    setState(() {});
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    widget.productViewModel.updateSearchQuery('');
    widget.productViewModel.filterData();
    FocusScope.of(context).unfocus();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    widget.productViewModel.updateSearchQuery(query);
    widget.productViewModel.filterData();
    setState(() {
      widget.productViewModel.suggestions =
          widget.productViewModel.getSuggestions(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ViewModelBuilder.reactive(
          disposeViewModel: false,
          onViewModelReady: (viewModel) async {
            viewModel.viewContext = context;
            await viewModel.locationViewModel.loadLocations();
            await viewModel.categoriesViewModel.loadCategories();
            widget.productViewModel
                .setCategories(viewModel.categoriesViewModel.lstCate);
          },
          viewModelBuilder: () => widget.indexViewModel,
          builder: (context, viewModel, child) {
            return BasePage(
              showFloating: true,
              floating: _isScrollToTopButtonVisible
                  ? FloatingActionButton(
                      onPressed: () {
                        // Sử dụng scrollController để cuộn lên đầu
                        widget.productViewModel.scrollController3.animateTo(
                          0, // Vị trí 0 là đầu danh sách
                          duration:
                              Duration(milliseconds: 700), // Thời gian cuộn
                          curve: Curves.easeInOut, // Hiệu ứng cuộn
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
              showSearch: false,
              search: Container(
                width: MediaQuery.of(context).size.width /
                    0.9, // Đặt chiều rộng của TextField
                height: 40,
                child: TextField(
                  onSubmitted: (value) {
                    widget.productViewModel.updateSearchQuery(value);
                    widget.productViewModel.filterData();
                    FocusScope.of(context).unfocus();
                    setState(() {
                      widget.productViewModel.suggestions = [];
                    });
                  },
                  controller: _searchController,
                  maxLines: 1,
                  autofocus: widget.isShowTextField,
                  decoration: InputDecoration(
                      filled: true,
                      isDense: false,
                      fillColor: AppColor.extraColor,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      hintText: 'Tìm kiếm',
                      hintStyle:
                          TextStyle(fontSize: AppFontSize.sizeSuperSmall),
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
                      suffixIcon: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          _clearSearch();
                        },
                      )),
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: AppFontSize.sizeSuperSmall),
                ),
              ),
              body: RefreshIndicator(
                onRefresh: _refreshData,
                color: AppColor.primaryColor,
                child: CustomScrollView(
                  controller: widget.productViewModel.scrollController3,
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          FilterLocationButton(
                            selectedOptions: {
                              'Khu vực': _selectedOptions['Khu vực']!
                            },
                            icon: Icons.location_on_outlined,
                            nameFilter: 'Khu vực',
                            filterOptions: [
                              FilterLocations(
                                title: 'Khu vực',
                                options:
                                    viewModel.locationViewModel.lstLocation,
                              ),
                            ],
                            // selectedOptions: _selectedOptions,
                            onOptionSelected: _handleOptionSelected,
                          ),
                          FilterButtonByCate(
                            selectedOptions: {
                              'Loại sản phẩm':
                                  _selectedOptions['Loại sản phẩm']!,
                            },
                            icon: Icons.filter_alt_outlined,
                            nameFilter: 'Lọc',
                            filterOptions: [
                              FilterOptionsByCate(
                                title: 'Loại sản phẩm',
                                options: viewModel.categoriesViewModel.lstCate,
                              ),
                            ],
                            onOptionSelected: _handleOptionSelected,
                            isSelectedFromMenu: isSelectedFromMenu,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          if (!isSelectedFromMenu ||
                              _selectedOptions['Loại sản phẩm'] == 'Tất cả')
                            ListItemWidget(
                              cateViewModel:
                                  widget.indexViewModel.categoriesViewModel,
                              onOptionSelected: _handleOptionSelected,
                            ),
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            thickness: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Thiết bị cho thuê',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.productViewModel.isBusy)
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 1.5,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColor.primaryColor,
                            ),
                          ),
                        ),
                      )
                    else if ((isCategoryListVisible &&
                            isLocationListVisible &&
                            widget.productViewModel.searchData.isEmpty) ||
                        (!isCategoryListVisible &&
                            !isLocationListVisible &&
                            widget.productViewModel.searchData.isEmpty) ||
                        (isCategoryListVisible &&
                            !isLocationListVisible &&
                            widget.productViewModel.searchData.isEmpty) ||
                        (!isCategoryListVisible &&
                            isLocationListVisible &&
                            widget.productViewModel.searchData.isEmpty))
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height /
                              1.5, // Chiều cao đầy đủ màn hình
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/empty.png'),
                                SizedBox(
                                    height: 10), // Khoảng cách giữa ảnh và text
                                Text(
                                  'Không có sản phẩm!',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 0.0,
                          childAspectRatio: 3 / 1.6,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return ItemProductList(
                                onTap: () {
                                  // if (isCategoryListVisible &&
                                  //     isLocationListVisible) {
                                  //   widget.productViewModel.detailProducts =
                                  //       widget.productViewModel
                                  //           .lstFilterProductAll[index];
                                  //   viewModel.productViewModel.viewContext =
                                  //       context;
                                  //   widget.productViewModel
                                  //       .nextDetailProduct();
                                  // } else {
                                  widget.productViewModel.detailProducts =
                                      widget.productViewModel.searchData[index];
                                  viewModel.productViewModel.viewContext =
                                      context;
                                  widget.productViewModel.nextDetailProduct();
                                  // }
                                },
                                productViewModel: widget.productViewModel,
                                data:
                                    // isCategoryListVisible &&
                                    //         isLocationListVisible
                                    //     ? widget.productViewModel
                                    //         .lstFilterProductAll[index]
                                    //     :
                                    widget.productViewModel.searchData[index]);
                          },
                          childCount:
                              // isCategoryListVisible && isLocationListVisible
                              //     ? widget.productViewModel
                              //         .lstFilterProductAll.length
                              //     :
                              widget.productViewModel.searchData.length,
                        ),
                      ),
                    if (widget.productViewModel.searchData.length == 1 ||
                        widget.productViewModel.searchData.length == 0)
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 2,
                        ),
                      )
                    else if (widget.productViewModel.searchData.length < 5 &&
                        widget.productViewModel.searchData.length > 1)
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height / 7,
                        ),
                      )
                  ],
                ),
              ),
            );
          }),
      _buildSuggestionsOverlay(),
    ]);
  }

  Widget _buildSuggestionsOverlay() {
    if (widget.productViewModel.suggestions.isEmpty) {
      return SizedBox.shrink(); // Không hiển thị gì nếu không có gợi ý
    }

    return Positioned(
      left: 20,
      right: 20,
      top: 100, // Vị trí bên dưới `TextField`
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        elevation: 4.0,
        child: ListView.builder(
          padding: EdgeInsets.zero, // Bỏ padding của ListView
          shrinkWrap: true,
          itemCount: widget.productViewModel.suggestions.length,
          itemBuilder: (context, index) {
            final suggestion = widget.productViewModel.suggestions[index];
            return InkWell(
              onTap: () {
                _searchController.text = suggestion.title ?? '';
                widget.productViewModel
                    .updateSearchQuery(suggestion.title ?? '');
                widget.productViewModel.filterData();
                FocusScope.of(context).unfocus();
                setState(() {
                  widget.productViewModel.suggestions = [];
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey[600], size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        suggestion.title ?? '',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
