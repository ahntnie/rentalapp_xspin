import 'package:flutter/material.dart';

import 'package:products_app/constants/app_color.dart';

class ButtonWidget extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool showLead;
  ButtonWidget(
      {super.key,
      this.showLead = true,
      required this.icon,
      required this.onTap,
      required this.title,
      required this.color});

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColor.extraColor,
      highlightColor: AppColor.extraColor,
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColor.unSelectColor, width: 1),
          ),
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: widget.color,
            child: Icon(widget.icon, color: AppColor.extraColor),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: TextStyle(),
              ),
              Text(
                widget.showLead ? '>' : '',
                style: TextStyle(color: AppColor.nav_un),
              )
            ],
          ),
        ),
      ),
    );
  }
}
