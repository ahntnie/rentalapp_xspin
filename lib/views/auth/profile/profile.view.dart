import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:thuethietbi/base/base.page.dart';
import 'package:thuethietbi/constants/api.dart';
import 'package:thuethietbi/constants/app_color.dart';
import 'package:thuethietbi/views/auth/profile/widget/button.widget.dart';
import 'package:thuethietbi/views/auth/profile/widget/selection.widget.dart';
import 'package:thuethietbi/views/auth/profile/widget/user.widget.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  String version = '';
  final Uri _url = Uri.parse('https://thuethietbisukien.com');
  Future<void> openWeb() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
    print(_url);
  }

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  Future<void> _getAppVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = 'Phiên bản ${packageInfo.version}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showAppBar: false,
      body: Column(
        children: [
          Container(
            height: 200,
            width: double.infinity,
            child: Image.network(
              API.HOST_IMAGE_USER,
              fit: BoxFit.fill,
              scale: 1,
              errorBuilder: (context, error, stackTrace) {
                // Hiển thị khung màu vàng nếu có lỗi
                return Container(
                  height: 200,
                  color: AppColor.extraColor,
                  child: const Icon(
                    Icons.image_not_supported, // Biểu tượng thay thế
                    color: Colors.grey,
                    size: 80,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                UserInfo(),
                SectionTitle(title: 'Chi tiết'),
                ButtonWidget(
                  onTap: () {
                    FlutterPhoneDirectCaller.callNumber('0915660068');
                  },
                  icon: Icons.support_agent,
                  color: Colors.pink,
                  title: 'Hỗ trợ tư vấn',
                ),
                ButtonWidget(
                  onTap: () {},
                  icon: Icons.article,
                  color: Colors.blue,
                  title: 'Điều khoản và chính sách',
                ),
                ButtonWidget(
                  onTap: openWeb,
                  icon: Icons.public,
                  color: AppColor.primaryColor,
                  title: 'Website',
                ),
                ButtonWidget(
                  showLead: false,
                  onTap: () {},
                  icon: Icons.update,
                  color: Colors.orange,
                  title: version,
                ),
              ],
            ),
          ),
        ],
      ),
      title: 'Cá nhân',
    );
  }
}
