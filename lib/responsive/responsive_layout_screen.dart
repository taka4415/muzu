import 'package:englishapp/utils/hive_method.dart';
import 'package:flutter/material.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webSreenLayout;
  final Widget mobileSreenLayout;
  const ResponsiveLayout({
    Key? key,
    required this.webSreenLayout,
    required this.mobileSreenLayout,
  }) : super(key: key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    // addData();
  }

  // addData() async {
  //   UserProvider _userProvider =
  //       Provider.of<UserProvider>(context, listen: false);
  //   await _userProvider.refreshUser();
  // }

  @override
  Widget build(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    String languageCode = locale.languageCode;
    HiveMethods().setDeviceLocale(languageCode);
    return LayoutBuilder(
      builder: (context, constraints) {
        // if (constraints.minWidth > webScreenSize) {
        //   return widget.webSreenLayout;
        // }
        return widget.mobileSreenLayout;
      },
    );
  }
}
