import 'package:flutter/material.dart';

import 'package:products_app/constants/app_color.dart';
import 'package:products_app/constants/app_fontsize.dart';

class BasePage extends StatefulWidget {
  final bool showLogo;
  final bool showSearch;
  final bool showMore;
  final String? title;
  final bool showLogout;
  final bool showAppBar;
  final Widget body;
  final Widget? bottomNav;
  final Widget? search;
  final bool showLeading;
  final VoidCallback? onPressedLeading;
  final Widget? bottomSheet;
  final Widget? floating;
  final bool showFloating;
  const BasePage({
    this.search,
    super.key,
    this.showMore = false,
    this.showLogo = false,
    this.showSearch = true,
    this.title,
    this.floating,
    this.showLogout = false,
    this.showAppBar = true,
    this.showFloating = false,
    this.bottomSheet,
    required this.body,
    this.bottomNav,
    this.showLeading = true,
    this.onPressedLeading,
  });

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.showFloating ? widget.floating : null,
      backgroundColor: AppColor.extraColor,
      appBar: widget.showAppBar
          ? AppBar(
              toolbarHeight: 70,
              backgroundColor: AppColor.appBarColor,
              iconTheme: const IconThemeData(
                color: AppColor.extraColor,
              ),
              title: widget.showSearch
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.title ?? '',
                            style: TextStyle(
                                color: AppColor.extraColor,
                                fontWeight: FontWeight.w800,
                                fontSize: AppFontSize.sizeMedium),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.showMore)
                          IconButton(
                            icon: const Icon(
                              Icons.more_horiz,
                              color: AppColor.extraColor,
                              size: 30,
                            ),
                            onPressed: () {
                              // Xử lý khi người dùng nhấn vào biểu tượng tìm kiếm
                            },
                          ),
                      ],
                    )
                  : widget.search,
            )
          : null,
      body: widget.body,
      bottomNavigationBar: widget.bottomNav,
      bottomSheet: widget.bottomSheet,
    );
  }
}
