import 'package:flutter/material.dart';
import 'package:thuethietbi/base/base.page.dart';
import 'package:thuethietbi/constants/app_color.dart';
import 'package:thuethietbi/constants/app_fontsize.dart';
import 'package:thuethietbi/viewmodel/categories.vm.dart';
import 'package:thuethietbi/viewmodel/index.vm.dart';
import 'package:thuethietbi/viewmodel/product.vm.dart';
import 'package:thuethietbi/views/home/widget/detailCaterories/widget/cate_child/list.dart';
import 'package:thuethietbi/views/view_product/widget/category/list.item.cate.widget.dart';
import 'package:thuethietbi/views/view_product/widget/filterBrand/fillter.widget.dart';
import 'package:thuethietbi/views/view_product/widget/filterLocation/fliter.location.widget.dart';
import 'package:thuethietbi/views/view_product/widget/listview/item.product.dart';
import 'package:stacked/stacked.dart';

class ViewProduct extends StatefulWidget {
  final ProductViewModel productViewModel;
  final IndexViewModel indexViewModel;

  const ViewProduct(
      {super.key,
      required this.indexViewModel,
      required this.productViewModel});

  @override
  State<ViewProduct> createState() => _ViewProductState();
}

class _ViewProductState extends State<ViewProduct> {
  late TextEditingController _searchController;
  bool _isScrollToTopButtonVisible = false;
  bool isCategoryListVisible = true;
  bool isAllSelectedCategory = false;
  bool isAllSelectedLocation = false;
  bool isLocationListVisible = true;
  bool isSelectedChildCate = false;

  Map<String, String> _selectedOptions = {
    'Khu vực': 'Toàn quốc',
    'Loại sản phẩm': 'Tất cả',
    'Hạng mục': 'Tất cả'
  };
  String _selectedCategoryId = '';
  String _selectedCityId = '';
  int? idChaView;
  void _handleOptionSelectedChildCate(String filterType, String option) {
    setState(() {
      _selectedOptions[filterType] = option;

      if (option == "Tất cả" || option.isEmpty) {
        isSelectedChildCate = true;
        _selectedCategoryId = '';
        widget.productViewModel
            .getFilterProductView(0, _selectedCityId)
            .then((_) {
          setState(() {});
        });
      } else {
        isSelectedChildCate = false;
        final selectedChildCategory = widget
            .indexViewModel.categoriesViewModel.lstCateChild
            .firstWhere((child) => child.name == option);
        idChaView = widget.productViewModel.idChaView;
        if (selectedChildCategory != null) {
          _selectedCategoryId = selectedChildCategory.id.toString();
        }
      }
    });
    if (_selectedCategoryId.isNotEmpty) {
      int selectedChildId = int.tryParse(_selectedCategoryId) ?? 0;
      widget.productViewModel
          .getFilterProductView(selectedChildId, _selectedCityId)
          .then((_) {
        setState(() {
          print(
              'Chọn danh mục với idDanhMuc là: ${selectedChildId} và idCity: ${_selectedCityId}');
        });
      });
    }
  }

  void _handleOptionSelected(String filterType, String option) {
    setState(() {
      _selectedOptions[filterType] = option;
    });

    if (filterType == 'Khu vực') {
      if (option == "Toàn quốc") {
        isAllSelectedLocation = true;
        isLocationListVisible = true;
        _selectedCityId = '';
      } else {
        isAllSelectedLocation = false;
        isLocationListVisible = false;
        final selectedLocation = widget
            .indexViewModel.locationViewModel.lstLocation
            .firstWhere((location) => location.name == option);
        print('ID Cha hiện tại: ${widget.productViewModel.idChaView}');

        _selectedCityId = selectedLocation.id;
        if (widget.productViewModel.idChaView != 0) {
          widget.productViewModel
              .getFilterProductView(
                  widget.productViewModel.idChaView ?? 0, _selectedCityId)
              .then((_) {
            setState(() {
              print('ID Cha hiện tại: ${widget.productViewModel.idChaView}');
            });
          });
        } else {
          widget.productViewModel
              .getFilterProductView(0, _selectedCityId)
              .then((_) {
            setState(() {});
          });
        }
      }
    } else if (filterType == 'Loại sản phẩm') {
      if (option == "Tất cả" || option.isEmpty) {
        isAllSelectedCategory = true;
        isCategoryListVisible = true;
        isSelectedChildCate = false;

        _selectedCategoryId = '';
        if (_selectedCityId.isNotEmpty) {
          widget.productViewModel
              .getFilterProductView(0, _selectedCityId)
              .then((_) {
            setState(() {});
          });
        } else {
          widget.productViewModel.getFilterProductView(0, '').then((_) {
            setState(() {});
          });
        }
        widget.indexViewModel.categoriesViewModel.lstCateChild.clear();
      } else {
        isCategoryListVisible = false;
        isAllSelectedCategory = false;
        final selectedCategory = widget
            .indexViewModel.categoriesViewModel.lstCate
            .firstWhere((category) => category.name == option);
        _selectedCategoryId = selectedCategory.id.toString();
        widget.productViewModel.idChaView = selectedCategory.id;
        widget.indexViewModel.categoriesViewModel
            .loadCategoriesChild(selectedCategory.id ?? 0)
            .then((_) {
          setState(() {
            isSelectedChildCate = widget
                .indexViewModel.categoriesViewModel.lstCateChild.isNotEmpty;
          });
        });
        widget.productViewModel
            .getFilterProductView(selectedCategory.id ?? 0, '')
            .then((_) {
          setState(() {});
        });
        isSelectedChildCate = true;
      }
    }

    int selectedIdCate = int.tryParse(_selectedCategoryId) ?? 0;
    if (isCategoryListVisible && isLocationListVisible) {
      widget.productViewModel.getFilterProductView(0, '').then((_) {
        setState(() {});
      });
    } else if (!isAllSelectedCategory && isAllSelectedLocation) {
      widget.productViewModel
          .getFilterProductView(selectedIdCate, '')
          .then((_) {
        setState(() {});
      });
    } else if (!isAllSelectedCategory && !isAllSelectedLocation) {
      widget.productViewModel
          .getFilterProductView(selectedIdCate, _selectedCityId)
          .then((_) {
        setState(() {
          print('ID Cha hiện tại: ${widget.productViewModel.idChaView}');
        });
      });
    }
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
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() {
      _onSearchChanged();
    });
    widget.productViewModel.scrollController1.addListener(() {
      if (widget.productViewModel.scrollController1.position.pixels >=
          widget.productViewModel.scrollController1.position.maxScrollExtent -
              200) {
        // Khi cuộn gần tới cuối danh sách
        print('Reached near the end of the list');
        // widget.productViewModel
        //     .loadMoreProducts(); // Gọi hàm load thêm sản phẩm
      }
    });
    isAllSelectedCategory = true;
    widget.productViewModel.getFilterProductView(0, '');
    widget.productViewModel.scrollController1.addListener(_scrollListener);
    initializeViewModels();
  }

  void _scrollListener() {
    bool isScrolled = widget.productViewModel.scrollController1.offset >= 1000;

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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    widget.productViewModel.updateSearchQueryy('');
    widget.productViewModel.filterDataView();
    FocusScope.of(context).unfocus();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    widget.productViewModel.updateSearchQueryy(query);
    widget.productViewModel.filterDataView();
    setState(() {
      widget.productViewModel.suggestionsView =
          widget.productViewModel.getSuggestionsView(query);
    });
  }

  void initializeViewModels() async {
    CategoriesViewModel categoriesViewModel = CategoriesViewModel();
    ProductViewModel productViewModel = ProductViewModel();
    await categoriesViewModel.loadCategories();
    productViewModel.setCategories(categoriesViewModel.lstCate);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ViewModelBuilder.reactive(
          disposeViewModel: false,
          onViewModelReady: (viewModel) async {
            viewModel.viewContext = context;

            await viewModel.locationViewModel.loadLocations();
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
                        widget.productViewModel.scrollController1.animateTo(
                          0,
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
              search: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width / 1.8,
                    height: 40,
                    child: TextField(
                      onSubmitted: (value) {
                        widget.productViewModel.updateSearchQueryy(value);
                        widget.productViewModel.filterDataView();
                        FocusScope.of(context).unfocus();
                        setState(() {
                          widget.productViewModel.suggestionsView = [];
                        });
                      },
                      controller: _searchController,
                      maxLines: 1,
                      decoration: InputDecoration(
                          filled: true,
                          isDense: false,
                          fillColor: AppColor.extraColor,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
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
              body: widget.productViewModel.isBusy &&
                      viewModel.categoriesViewModel.isBusy
                  ? Center(
                      child: CircularProgressIndicator(
                      color: AppColor.primaryColor,
                    ))
                  : RefreshIndicator(
                      onRefresh: _refreshData,
                      color: AppColor.primaryColor,
                      child: CustomScrollView(
                        controller: widget.productViewModel.scrollController1,
                        slivers: [
                          SliverToBoxAdapter(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                FliterButtonLocation(
                                  selectedOptions: {
                                    'Khu vực': _selectedOptions['Khu vực']!
                                  },
                                  icon: Icons.location_on_outlined,
                                  nameFilter: 'Khu vực',
                                  filterOptions: [
                                    FilterOptionLocation(
                                      title: 'Khu vực',
                                      options: viewModel
                                          .locationViewModel.lstLocation,
                                    ),
                                  ],
                                  // selectedOptions: _selectedOptions,
                                  onOptionSelected: _handleOptionSelected,
                                ),
                                FilterButton(
                                  selectedOptions: {
                                    'Loại sản phẩm':
                                        _selectedOptions['Loại sản phẩm']!,
                                  },
                                  icon: Icons.filter_alt_outlined,
                                  nameFilter: 'Lọc',
                                  filterOptions: [
                                    FilterOption(
                                      title: 'Loại sản phẩm',
                                      options:
                                          viewModel.categoriesViewModel.lstCate,
                                    ),
                                  ],
                                  onOptionSelected: _handleOptionSelected,
                                ),
                                if (widget.indexViewModel.categoriesViewModel
                                        .lstCateChild.isNotEmpty &&
                                    !isAllSelectedCategory)
                                  FilterButton(
                                    selectedOptions: {
                                      'Hạng mục': _selectedOptions['Hạng mục']!,
                                    },
                                    icon: Icons.filter_alt_outlined,
                                    nameFilter: 'Hạng mục',
                                    filterOptions: [
                                      FilterOption(
                                        title: 'Hạng mục',
                                        options: widget.indexViewModel
                                            .categoriesViewModel.lstCateChild,
                                      ),
                                    ],
                                    onOptionSelected:
                                        _handleOptionSelectedChildCate,
                                  ),
                                SizedBox(
                                  height: 10,
                                ),
                                if (isCategoryListVisible)
                                  ListItemCateWidget(
                                    cateViewModel: widget
                                        .indexViewModel.categoriesViewModel,
                                    onOptionSelected: _handleOptionSelected,
                                  ),
                                if (isSelectedChildCate &&
                                    _selectedOptions['Loại sản phẩm'] !=
                                        'Tất cả')
                                  ListItemChildCate(
                                      productViewModel: widget.productViewModel,
                                      cateViewModel: widget
                                          .indexViewModel.categoriesViewModel,
                                      onOptionSelected:
                                          _handleOptionSelectedChildCate),
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
                                        'Thiết bị cho thuê ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
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
                                height:
                                    MediaQuery.of(context).size.height / 1.5,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColor.primaryColor,
                                  ),
                                ),
                              ),
                            )
                          else if ((isAllSelectedCategory &&
                                  isAllSelectedLocation &&
                                  widget.productViewModel
                                      .lstFilterProductsSearch.isEmpty) ||
                              (!isAllSelectedCategory &&
                                  !isAllSelectedLocation &&
                                  widget.productViewModel
                                      .lstFilterProductsSearch.isEmpty) ||
                              (isAllSelectedLocation &&
                                  !isAllSelectedCategory &&
                                  widget.productViewModel
                                      .lstFilterProductsSearch.isEmpty) ||
                              (!isAllSelectedLocation &&
                                  isAllSelectedCategory &&
                                  widget.productViewModel
                                      .lstFilterProductsSearch.isEmpty))
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height /
                                    1.5, // Chiều cao đầy đủ màn hình
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/empty.png'),
                                      SizedBox(
                                          height:
                                              10), // Khoảng cách giữa ảnh và text
                                      Text(
                                        'Không có sản phẩm nào hết!',
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
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
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
                                      //           .lstAllProducts[index];
                                      //   viewModel.productViewModel.viewContext =
                                      //       context;
                                      //   widget.productViewModel
                                      //       .nextDetailProduct();
                                      // } else {
                                      widget.productViewModel.detailProducts =
                                          widget.productViewModel
                                              .lstFilterProductsSearch[index];
                                      viewModel.productViewModel.viewContext =
                                          context;
                                      widget.productViewModel
                                          .nextDetailProduct();
                                      // }
                                    },
                                    productViewModel: widget.productViewModel,
                                    data:
                                        // isCategoryListVisible &&
                                        //         isLocationListVisible
                                        //     ? widget.productViewModel
                                        //         .lstAllProducts[index]
                                        //     :
                                        widget.productViewModel
                                            .lstFilterProductsSearch[index],
                                  );
                                },
                                childCount:
                                    // isCategoryListVisible && isLocationListVisible
                                    //     ? widget.productViewModel.lstAllProducts
                                    //         .length
                                    //     :
                                    widget.productViewModel
                                        .lstFilterProductsSearch.length,
                              ),
                            ),
                          if (widget.productViewModel.lstFilterProductsSearch
                                      .length ==
                                  1 ||
                              widget.productViewModel.lstFilterProductsSearch
                                      .length ==
                                  0)
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height / 2,
                              ),
                            )
                          else if (widget.productViewModel
                                      .lstFilterProductsSearch.length <
                                  5 &&
                              widget.productViewModel.lstFilterProductsSearch
                                      .length >
                                  1)
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
      _buildSuggestionsOverlay()
    ]);
  }

  Widget _buildSuggestionsOverlay() {
    if (widget.productViewModel.suggestionsView.isEmpty) {
      return SizedBox.shrink(); // Không hiển thị gì nếu không có gợi ý
    }

    return Positioned(
      left: 20,
      right: 20,
      top: 100,
      child: Material(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        elevation: 4.0,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: widget.productViewModel.suggestionsView.length,
          itemBuilder: (context, index) {
            final suggestion = widget.productViewModel.suggestionsView[index];
            return InkWell(
              onTap: () {
                _searchController.text = suggestion.title ?? '';
                widget.productViewModel
                    .updateSearchQueryy(suggestion.title ?? '');
                widget.productViewModel.filterDataView();
                FocusScope.of(context).unfocus();
                setState(() {
                  widget.productViewModel.suggestionsView = [];
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
