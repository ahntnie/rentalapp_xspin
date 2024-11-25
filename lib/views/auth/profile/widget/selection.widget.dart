import 'package:flutter/material.dart';

import 'package:thuethietbi/constants/app_color.dart';
import 'package:thuethietbi/constants/app_fontsize.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
            fontSize: AppFontSize.sizeSmall,
            color: AppColor.nav_un,
            fontWeight: FontWeight.w700),
      ),
    );
  }
}
