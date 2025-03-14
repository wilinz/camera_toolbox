import 'package:camera_toolbox/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

void main() => runApp(CameraBleApp());

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
