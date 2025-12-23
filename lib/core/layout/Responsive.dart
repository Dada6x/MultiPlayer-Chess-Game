import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 500;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 500 &&
      MediaQuery.sizeOf(context).width < 1280;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= 1280;

  static double widthPercent(BuildContext context, double percent) =>
      MediaQuery.sizeOf(context).width * percent;

  static double heightPercent(BuildContext context, double percent) =>
      MediaQuery.sizeOf(context).height * percent;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width >= 1280) {
      return desktop;
    } else if (width >= 500) {
      return tablet;
    } else {
      return mobile;
    }
  }
}
