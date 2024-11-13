import 'package:flutter/material.dart';
import 'package:products_app/model/caterogies_model.dart';
import 'package:products_app/request/categories.request.dart';
import 'package:products_app/viewmodel/index.vm.dart';
import 'package:stacked/stacked.dart';

class CategoriesViewModel extends BaseViewModel {
  late BuildContext viewContext;
  late IndexViewModel indexViewModel;
  late Categories detailCate;
  CategoriesRequest categoriesRequest = CategoriesRequest();
  List<Categories> lstCate = [];

  // init() async {
  //   loadCategories();
  // }

  Future<void> loadCategories() async {
    setBusy(true);
    lstCate = await categoriesRequest.getCategories();
    setBusy(false);
    notifyListeners();
  }
}
