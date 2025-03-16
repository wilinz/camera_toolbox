import 'dart:convert';

import 'package:camera_toolbox/common/logger.dart';
import 'package:camera_toolbox/routes/routes.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final deviceInfo = (await DeviceInfoPlugin().deviceInfo).data;
  logger.d("device info: ${JsonEncoder.withIndent("  ").convert(deviceInfo)}");
  runApp(CameraBleApp());
}

class CameraBleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: FToastBuilder(),
      debugShowCheckedModeBanner: false,
      title: 'Camera Toolbox',
      theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink.shade400)),
      getPages: AppRoute.routes,
    );
  }
}
