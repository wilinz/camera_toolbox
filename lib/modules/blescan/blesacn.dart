import 'package:camera_toolbox/modules/blescan/blesacn_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BLEScanPage extends StatelessWidget {
  const BLEScanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = BLEScanController();
    return Scaffold(
      appBar: AppBar(
        title: Text("扫描蓝牙设备"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
              children: [
                Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    width: double.infinity,
                    child: Obx(() => ElevatedButton(
                          onPressed: c.isScanning.value
                              ? null
                              : () {
                                  c.startScan();
                                },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("扫描设备"),
                              if (c.isScanning.value)
                                Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                                ),
                            ],
                          ),
                        )),
                  ),
                ),
                if (c.scanResults.isNotEmpty)
                  Text("共扫描到 ${c.scanResults.length} 台设备"),
                Expanded(
                  child: Obx(() => SizedBox(
                        child: c.scanResults.isEmpty
                            ? Center(child: Text("未扫描到设备"))
                            : ListView.builder(
                                itemCount: c.scanResults.length,
                                itemBuilder: (context, index) {
                                  final result = c.scanResults[index];
                                  return ListTile(
                                    title: Text(
                                        result.device.platformName.isNotEmpty
                                            ? result.device.platformName
                                            : "未知设备"),
                                    subtitle:
                                        Text(result.device.remoteId.toString()),
                                    trailing: TextButton(
                                      child: Text("连接"),
                                      onPressed: () {
                                        c.connectToDevice(result.device);
                                      },
                                    ),
                                  );
                                },
                              ),
                      )),
                )
              ],
            )),
      ),
    );
  }
}
