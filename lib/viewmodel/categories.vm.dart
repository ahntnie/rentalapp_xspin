import 'package:flutter/material.dart';
import 'package:thuethietbi/model/caterogies_model.dart';
import 'package:thuethietbi/request/categories.request.dart';
import 'package:thuethietbi/viewmodel/index.vm.dart';
import 'package:stacked/stacked.dart';

class CategoriesViewModel extends BaseViewModel {
  late BuildContext viewContext;
  late IndexViewModel indexViewModel;
  Categories? detailCate;
  CategoriesRequest categoriesRequest = CategoriesRequest();
  List<Categories> lstCate = [];
  List<Categories> lstCateChild = [];

  // init() async {
  //   loadCategories();
  // }

  Future<void> loadCategories() async {
    setBusy(true);
    lstCate = await categoriesRequest.getCategories();
    setBusy(false);
    notifyListeners();
  }

  Future<void> loadCategoriesChild(int id) async {
    setBusy(true);
    lstCateChild = await categoriesRequest.getCategoriesChild(id);
    print('Có ${lstCateChild.length} đứa con');
    setBusy(false);
    notifyListeners();
  }
}
