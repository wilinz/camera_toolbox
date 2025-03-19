import 'package:camera_toolbox/core/ble/features/camera_controller.dart';
import 'package:camera_toolbox/core/ble/features/wifi_controller.dart';
import 'package:camera_toolbox/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../../../core/ble/device.dart';
import '../../../core/ble/device_manager.dart';

// Controller class for managing BLE devices
class HomeController extends GetxController {
  // Reactive list of saved BLE devices
  var savedDevices = <BLEDeviceDesc>[].obs;

  // Reactive variable for the currently selected BLE device
  var currentDevice = Rx<BLEDeviceDesc?>(null);

  // Load saved BLE devices
  Future<void> loadSavedDevices() async {
    final manager = await BLEDeviceManager.instance;
    savedDevices.value = manager.getSavedDevices();
  }

  // Reconnect to a BLE device
  Future<BluetoothDevice?> reconnect(BLEDeviceDesc device) async {
    final manager = await BLEDeviceManager.instance;
    try {
      final blueDevice = BluetoothDevice.fromId(device.remoteId);
      await manager.connectToDevice(
        blueDevice,
        autoReconnect: true,
      );
      Get.snackbar('重连成功', '${device.name} 已连接');
      return blueDevice;
    } catch (e) {
      Get.snackbar('重连失败', '无法连接到 ${device.name}');
    }
    return null;
  }

  // Delete a BLE device
  Future<void> deleteDevice(BLEDeviceDesc device) async {
    final manager = await BLEDeviceManager.instance;
    await manager.removeSavedDevice(device.remoteId);
    await loadSavedDevices(); // Refresh the device list
    Get.snackbar('设备已删除', '${device.name} 已移除');
  }

  // Confirm delete dialog for BLE device
  void confirmDelete(BLEDeviceDesc device) {
    Get.defaultDialog(
      title: "删除设备",
      middleText: "确定要删除 ${device.name} 吗？",
      textCancel: "取消",
      textConfirm: "删除",
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        deleteDevice(device);
      },
    );
  }

  // Set the current BLE device
  void selectDevice(BLEDeviceDesc device) {
    currentDevice.value = device;
  }

  shoot() async {
    if (currentDevice.value == null) {
      toastFailure0("请先点击选择设备");
      return;
    }
    final ble = await BLEDeviceManager.instance;
    final deviceAndServices = await ble.getConnectedDevice(currentDevice.value!.remoteId);
    final controller = BLECameraController(
        device: deviceAndServices,
    );
    await controller.shoot();
  }

  strrtWIFI() async {
    if (currentDevice.value == null) {
      toastFailure0("请先点击选择设备");
      return;
    }
    final ble = await BLEDeviceManager.instance;
    final deviceAndServices = await ble.getConnectedDevice(currentDevice.value!.remoteId);
    final controller = BLEWiFiController(
      device: deviceAndServices,
    );
    await controller.setupWiFiAP(ssid: "Canon-EOS-R8", password:"asdfghjkl");
  }

}
