import 'package:flutter/material.dart';

import 'package:products_app/constants/app_color.dart';

class HomeNavigationBar extends StatefulWidget {
  const HomeNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });
  final int currentIndex;
  final Future<void> Function(int) onTabSelected;

  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.transparent
                .withOpacity(0.1), // Hoặc màu mong muốn cho gạch ngang
            width: 1.0, // Độ rộng của gạch ngang
          ),
        ),
      ),
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColor.navBarColor,
        currentIndex: widget.currentIndex,
        fixedColor: AppColor.fontNavBar,
        unselectedItemColor: AppColor.nav_un,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(),
        onTap: (index) async {
          await widget.onTabSelected(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 24),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_module_rounded, size: 24),
            label: 'Xem sản phẩm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 24),
            label: 'Thông tin',
          ),
        ],
      ),
    );
  }
}
