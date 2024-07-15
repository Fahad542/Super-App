import 'package:flutter/painting.dart';
import 'package:hexcolor/hexcolor.dart';

class AppColors {
  AppColors._();

  static HexColor primary = HexColor("#0a406b");
  static HexColor secondary = HexColor("#5293C7");

  static HexColor grey = HexColor("#949494");
  static HexColor lightGrey = HexColor("#D9D9D9");
  static HexColor darkGrey = HexColor("#474747");
  static HexColor black = HexColor("#000000");
  static HexColor white = HexColor("#ffffff");
  static HexColor peach = HexColor("#FCEFDA");
  static HexColor yellow = HexColor("#FFDB45");
  static HexColor purple = HexColor("#743FA9");
  static HexColor green = HexColor("#41BD6F");
  static HexColor red = HexColor("#BD0000");
  static HexColor boxdsf = HexColor("#80CBC4");

  static List<BoxShadow> primaryBoxShadow = [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.25),
      blurRadius: 2,
      offset: Offset(-2, -2),
    ),
    BoxShadow(
      color: AppColors.primary.withOpacity(0.25),
      blurRadius: 2,
      offset: Offset(2, 2),
    ),
  ];
}
