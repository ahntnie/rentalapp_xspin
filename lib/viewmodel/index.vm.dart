import 'package:flutter/material.dart';
import 'package:thuethietbi/viewmodel/categories.vm.dart';
import 'package:thuethietbi/viewmodel/location.vm.dart';
import 'package:thuethietbi/viewmodel/product.vm.dart';
import 'package:thuethietbi/views/auth/profile/profile.view.dart';
import 'package:thuethietbi/views/home/home.view.dart';
import 'package:thuethietbi/views/view_product/view_product.dart';

import 'package:stacked/stacked.dart';

class IndexViewModel extends BaseViewModel {
  late BuildContext viewContext;
  late ProductViewModel productViewModel;
  late CategoriesViewModel categoriesViewModel;
  late LocationViewModel locationViewModel;
  int currentIndex = 0;
  IndexViewModel() {
    productViewModel = ProductViewModel();
    categoriesViewModel = CategoriesViewModel();
    locationViewModel = LocationViewModel();
    initializeData();
  }
  Future<void> setIndex(int index) async {
    if (index == 0) {
      await productViewModel.getAllProducts();
    }
    currentIndex = index;
    notifyListeners();
  }

  Future<void> initializeData() async {
    setBusy(true); // Đặt isBusy thành true khi bắt đầu tải
    await Future.wait([
      productViewModel.getAllProducts(),
      productViewModel.getFilterProductView(0, ''),
      productViewModel.getFilterProducts(0, ''),
      categoriesViewModel.loadCategories(),
      // categoriesViewModel.loadCategoriesChild(productViewModel.data!.idCate?? 0),
    ]);
    setBusy(false); // Đặt isBusy thành false khi tải xong
  }

  List<Widget> getPages() {
    return [
      HomeView(
        indexViewModel: this,
        productViewModel: productViewModel,
      ),
      ViewProduct(
        indexViewModel: this,
        productViewModel: productViewModel,
      ),
      ProfileView()
    ];
  }
}
