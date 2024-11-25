import 'package:flutter/material.dart';
import 'package:thuethietbi/model/caterogies_model.dart';
import 'package:thuethietbi/model/message_model.dart';
import 'package:thuethietbi/model/products.model.dart';
import 'package:thuethietbi/request/categories.request.dart';
import 'package:thuethietbi/request/message_request.dart';
import 'package:thuethietbi/request/product.request.dart';
import 'package:thuethietbi/viewmodel/index.vm.dart';
import 'package:thuethietbi/views/home/widget/detailitem.widget.dart';
import 'package:stacked/stacked.dart';

class ProductViewModel extends BaseViewModel {
  late BuildContext viewContext;
  ProductRequest productRequest = ProductRequest();
  CategoriesRequest categoriesRequest = CategoriesRequest();
  late IndexViewModel indexViewModel;
  final ScrollController scrollController = ScrollController();
  final ScrollController scrollController1 = ScrollController();
  final ScrollController scrollController3 = ScrollController();
  String searchQuery = '';
  Products? data;
  int? idCha;
  int? idChaView;
  Categories? detailCate;

  final messageRequest = MessageRequest();
  late Products detailProducts;
  List<Categories> lstCategory = [];

  List<Categories> lstCateChild = [];
  List<Products> lstFilterProduct = [];
  List<Products> lstAllProducts = [];
  List<Products> lstFilterProductView = [];
  List<Products> searchData = [];
  List<Products> lstFilterProductsSearch = [];
  TextEditingController phone = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController desc = TextEditingController();

  void setCategories(List<Categories> categories) {
    lstCategory = categories;
    notifyListeners();
  }

  Future<void> getCategoryById(int id) async {
    detailCate = await categoriesRequest.getCategoryById(id);
    print('Data danh mục :${detailCate!.name}');

    notifyListeners();
  }

  void post(int id) async {
    final message = MessageModel(
      id: id,
      soDienThoai: phone.text,
      hoTen: name.text,
      noiDung: desc.text,
    );

    try {
      final response = await messageRequest.postMessage(message);
      print('Phản hồi từ server: ${response.toJson()}');
    } catch (e) {
      print('Đã xảy ra lỗi: $e');
    }
  }

  List<Products> getSimilarProducts(int categoryId, int currentProductId) {
    return lstAllProducts
        .where((product) =>
            product.idCate == categoryId && product.id != currentProductId)
        .toList();
  }

  Future<void> getFilterProductChildCate(int idDanhMuc) async {
    setBusy(true);
    lstFilterProduct =
        await productRequest.getProductsByCategoryChild(idDanhMuc);
    // print('ID cấp cha ở mục con: ${idCha}');
    print('ID cấp cha ở mục con: ${idChaView}');

    print('Có ${lstFilterProduct.length} sản phẩm trong danh mục ${idDanhMuc}');
    setBusy(false);
    filterData();
    notifyListeners();
  }

  Future<void> getFilterProductChildCateView(int idDanhMuc) async {
    setBusy(true);
    lstFilterProductView =
        await productRequest.getProductsByCategoryChild(idDanhMuc);
    // print('ID cấp cha ở mục con: ${idCha}');
    print('ID cấp cha ở mục con: ${idChaView}');
    print('Có ${lstFilterProduct.length} sản phẩm trong danh mục ${idDanhMuc}');
    setBusy(false);
    filterDataView();
    notifyListeners();
  }

  Future<void> getFilterProducts(int idDanhMuc, String idCity) async {
    setBusy(true);

    if (idDanhMuc == 0 && idCity.isEmpty) {
      lstFilterProduct = await productRequest.getLstProduct();
      idCha = 0;
      print('Gọi getFilterProducts với idDanhMuc: $idDanhMuc, idCity: $idCity');
    } else if (idCity.isNotEmpty && idDanhMuc == 0) {
      lstFilterProduct = await productRequest.getProductFilterLocation(idCity);
      print('Gọi getFilterProducts với idDanhMuc: $idDanhMuc, idCity: $idCity');
    } else if (idDanhMuc != 0 && idCity.isEmpty) {
      lstFilterProduct = await productRequest.getProductsByCategory(idDanhMuc);
      idCha = idDanhMuc; // Cập nhật danh mục cha
      print('Gọi getFilterProducts với idDanhMuc: $idDanhMuc, idCity: $idCity');
    } else if (idDanhMuc != 0 && idCity.isNotEmpty) {
      lstFilterProduct =
          await productRequest.getProductFilter(idDanhMuc, idCity);
      idCha = idDanhMuc; // Cập nhật danh mục cha
      print('Gọi getFilterProducts với idDanhMuc: $idDanhMuc, idCity: $idCity');
    }

    filterData();
    setBusy(false);
    notifyListeners();
  }

//screen view_product
  Future<void> getAllProducts() async {
    setBusy(true);
    lstAllProducts = await productRequest.getLstProduct();
    print('data all home -----> ${lstAllProducts.length}');
    setBusy(false);
    notifyListeners();
  }

//screen view_product
  Future<void> getFilterProductView(int idDanhMuc, String idCity) async {
    setBusy(true);
    if (idDanhMuc == 0 && idCity.isEmpty) {
      lstFilterProductView = await productRequest.getLstProduct();
      idChaView = 0;
      print(
          'Gọi getFilterProductView với idDanhMuc: $idDanhMuc, idCity: $idCity');
      print('data333 all -----> ${lstFilterProductView.length}');
    } else if (idCity.isNotEmpty && idDanhMuc == 0) {
      lstFilterProductView =
          await productRequest.getProductFilterLocation(idCity);
      print(
          'Gọi getFilterProductView với idDanhMuc: $idDanhMuc, idCity: $idCity');
      print('data222 location -----> ${lstFilterProductView.length}');
    } else if (idDanhMuc != 0 && idCity.isEmpty) {
      lstFilterProductView =
          await productRequest.getProductsByCategory(idDanhMuc);
      idChaView = idDanhMuc;
      print(
          'Gọi getFilterProductView với idDanhMuc: $idDanhMuc, idCity: $idCity');
      print('data111 cate -----> ${lstFilterProductView.length}');
    } else if (idDanhMuc != 0 && idCity.isNotEmpty) {
      lstFilterProductView =
          await productRequest.getProductFilter(idDanhMuc, idCity);
      idChaView = idDanhMuc;
      print(
          'Gọi getFilterProductView với idDanhMuc: $idDanhMuc, idCity: $idCity');
      print('data444 filter -----> ${lstFilterProductView.length}');
    }
    filterDataView();
    setBusy(false);
    notifyListeners();
  }

  void filterData() {
    final query = searchQuery.toLowerCase();
    if (query.isEmpty) {
      searchData = List.from(lstFilterProduct);
    } else {
      searchData = lstFilterProduct.where((data) {
        return _matchesQuery(data, query);
      }).toList();
    }
    notifyListeners();
  }

  void filterDataView() {
    final query = searchFilter.toLowerCase();
    if (query.isEmpty) {
      lstFilterProductsSearch = List.from(lstFilterProductView);
    } else {
      lstFilterProductsSearch = lstFilterProductView.where((data) {
        return _matchesQuery(data, query);
      }).toList();
    }
    notifyListeners();
  }

  List<Products> suggestionsView = [];
  List<Products> getSuggestionsView(String query) {
    if (query.isEmpty) {
      return [];
    }
    return lstFilterProductView
        .where((product) =>
            product.title?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();
  }

  List<Products> suggestions = [];
  List<Products> getSuggestions(String query) {
    if (query.isEmpty) {
      return [];
    }
    return lstFilterProduct
        .where((product) =>
            product.title?.toLowerCase().contains(query.toLowerCase()) ?? false)
        .toList();
  }

  bool _matchesQuery(Products data, String query) {
    return (data.title?.toLowerCase().contains(query) ?? false);
  }

  void updateSearchQuery(String query) {
    searchQuery = query;
    filterData();
  }

  String searchFilter = '';
  void updateSearchQueryy(String query) {
    searchFilter = query;
    filterDataView();
  }

  nextDetailProduct() async {
    print('nhảy');
    await getCategoryById(detailProducts.idCate!);
    Navigator.push(
      viewContext,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => DetailItem(
          categoryId: detailProducts.idCate ?? 0,
          data: detailProducts,
          productViewModel: this,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          // Di chuyển child theo animation
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }
}
