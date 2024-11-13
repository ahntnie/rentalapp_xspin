import 'package:flutter/material.dart';
import 'package:products_app/base/base.page.dart';
import 'package:products_app/base/nav_bar.page.dart';
import 'package:products_app/viewmodel/index.vm.dart';

import 'package:stacked/stacked.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  late IndexViewModel indexViewModel;
  @override
  void initState() {
    super.initState();
    indexViewModel = IndexViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<IndexViewModel>.reactive(
      viewModelBuilder: () => indexViewModel,
      builder: (context, viewModel, child) => BasePage(
        showAppBar: false,
        body: IndexedStack(
          index: viewModel.currentIndex,
          children: viewModel.getPages(),
        ),
        bottomNav: HomeNavigationBar(
          currentIndex: viewModel.currentIndex,
          onTabSelected: (index) => viewModel.setIndex(index),
        ),
      ),
    );
  }
}
