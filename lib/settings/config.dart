import 'package:flutter/material.dart';

class Config {
  static String get applicationName => "Site720";
  static String get apiBaseUrl => "https://s1.site720.com/clientv1/api/";

  static double get cartTileHeight => 60;
  static bool get addButtonInvert => false;
  static Color get themeColor => Color(0XFFF00053c);
  static String get fontFamily => 'VarelaRound-Regular';
  static Color get iconColor => Color(0XFFF00053c);
  static Color get buttonColor => Color(0XFFF00053c);
  static Color get drawerIconColor => Color(0XFFF00053c);
  static Color get shopListingPageMenuHeadingColor => Color(0XFFF00053c);
  static Color get textBoxBorderColor => Color(0XFFF00053c);
  static int get locationId => -1;

  // Developer Only
  static bool get debugger => true;
}
