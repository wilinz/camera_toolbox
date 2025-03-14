import 'package:camera_toolbox/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera Toolbox"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.toNamed(AppRoute.bleScanPage);
                    },
                    padding: EdgeInsets.all(32),
                    icon: Icon(
                      Icons.add_a_photo_outlined,
                      size: 64,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
