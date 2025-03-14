import 'package:get/get.dart';

import '../modules/blescan/blesacn.dart';
import '../modules/main/home/home.dart';

class AppRoute {
  static const String mainPage = "/";
  static const String bleScanPage = "/BLEScanPage";

  static List<GetPage> routes = [
    GetPage(
      name: mainPage,
      page: () => HomePage(),
    ),
    GetPage(
      name: bleScanPage,
      page: () => BLEScanPage(),
    ),
  ];
}