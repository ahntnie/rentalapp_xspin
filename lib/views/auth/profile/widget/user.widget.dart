import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:thuethietbi/constants/app_color.dart';
import 'package:thuethietbi/constants/app_fontsize.dart';

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
      // color: Colors.grey[200],
      child: Row(
        children: [
          ClipOval(
            child: Image.asset(
              'assets/logo_app.png',
              width: 70,
              height: 70,
            ),
          ),
          SizedBox(width: 10),
          Row(
            children: [
              Text(
                'HOTLINE: ',
                style: TextStyle(
                    fontSize: AppFontSize.sizeMedium,
                    fontWeight: AppFontWeight.bold,
                    color: AppColor.darkColor),
              ),
              InkWell(
                onTap: () {
                  FlutterPhoneDirectCaller.callNumber('0915660068');
                },
                child: Text('0915 660 068',
                    style: TextStyle(
                        fontSize: AppFontSize.sizeSmall,
                        fontWeight: FontWeight.w600,
                        color: AppColor.oceanColor)),
              )
            ],
          )
        ],
      ),
    );
  }
}
