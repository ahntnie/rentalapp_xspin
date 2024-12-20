import 'package:flutter/material.dart';
import 'package:thuethietbi/model/location.model.dart';
import 'package:thuethietbi/request/location.request.dart';
import 'package:thuethietbi/viewmodel/index.vm.dart';
import 'package:stacked/stacked.dart';

class LocationViewModel extends BaseViewModel {
  late BuildContext viewContext;
  late IndexViewModel indexViewModel;
  late Location detailLocation;
  LocationRequest locationRequest = LocationRequest();
  List<Location> lstLocation = [];

  // init() async {
  //   loadCategories();
  // }

  Future<void> loadLocations() async {
    setBusy(true);
    lstLocation = await locationRequest.getLocations();
    setBusy(false);
    notifyListeners();
  }
}
