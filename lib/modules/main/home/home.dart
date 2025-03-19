import 'package:camera_toolbox/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Create an instance of HomeController
    final HomeController c = Get.put(HomeController());

    // Load saved BLE devices on initialization
    c.loadSavedDevices();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Camera Toolbox"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          const Text(
            "已保存设备",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // Use DeviceListWidget to show the saved devices
          Expanded(
            child: DeviceListWidget(controller: c),
          ),
          // Add the camera capture button at the bottom
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                c.shoot();
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text("拍摄"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                c.strrtWIFI();
              },
              icon: const Icon(Icons.camera_alt),
              label: const Text("开启 WIFI"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DeviceListWidget extends StatelessWidget {
  final HomeController controller;

  const DeviceListWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: controller.savedDevices.length + 1,
        // Add 1 for the scan button
        itemBuilder: (context, index) {
          // Last item is the scan/add device button
          if (index == controller.savedDevices.length) {
            return GestureDetector(
              onTap: () {
                Get.toNamed(AppRoute.bleScanPage)?.then((_) =>
                    controller.loadSavedDevices());
              },
              child: Container(
                margin: const EdgeInsets.only(top: 8, bottom: 16),
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_a_photo_outlined, color: Colors.white, size: 28),
                    SizedBox(width: 12),
                    Text(
                      "添加新设备",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final device = controller.savedDevices[index];
          bool isSelected() => controller.currentDevice.value == device;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                if (isSelected()){
                  controller.currentDevice.value = null;
                } else {
                  controller.selectDevice(device); // Select the device
                }
              },
              onLongPress: () => controller.confirmDelete(device),
              child: Obx(() =>
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected() ? Colors.blueAccent.withOpacity(0.2) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.bluetooth, size: 32, color: Colors.blueAccent),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Obx(() => Text(
                                device.name,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected() ? Colors.blueAccent : Colors.black,
                                ),
                              )),
                              const SizedBox(height: 4),
                              Text(
                                device.remoteId,
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.sync, color: Colors.blueAccent),
                      ],
                    ),
                  )),
            ),
          );
        },
      );
    });
  }
}
