import 'dart:async';
import 'dart:io';

import 'package:camera_toolbox/common/logger.dart';
import 'package:camera_toolbox/core/ble/device_manager.dart';
import 'package:camera_toolbox/core/ble/handshake.dart';
import 'package:camera_toolbox/toast.dart';
import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

import '../../common/ble_permissions.dart';

class BLEScanController extends GetxController {
  final isScanning = false.obs;
  final scanResults = <ScanResult>[].obs;

  StreamSubscription<List<ScanResult>>? _scanSubscription;

  Future<void> startScan() async {
    if (await FlutterBluePlus.isSupported == false) {
      logger.i("Bluetooth not supported by this device");
      toastFailure0("此设备不支持蓝牙");
      return;
    }

    final hasPermissions = await checkBluetoothPermissions();
    if (!hasPermissions) {
      toastFailure0("请授予蓝牙权限");
      return;
    }

    // 检查蓝牙是否开启
    if (await FlutterBluePlus.adapterState.first != BluetoothAdapterState.on) {
      if (!kIsWeb && Platform.isAndroid) {
        await FlutterBluePlus.turnOn();
      } else {
        toastFailure0("请先开启蓝牙");
        isScanning.value = false;
        return;
      }
    }

    toast("开始扫描设备...");

    scanResults.clear();
    isScanning.value = true;

    try {
      await FlutterBluePlus.startScan(
          timeout: Duration(seconds: 10),
          removeIfGone: Duration(seconds: 10),
          continuousUpdates: true,
          withKeywords: ["EOS"]);
      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        scanResults.value = results.sortedBy((e) {
          return e.device.platformName.isNotEmpty ? e.device.platformName : "z";
        });
      });
      FlutterBluePlus.cancelWhenScanComplete(_scanSubscription!);
    } catch (e, st) {
      logger.e("扫描过程中出现异常", error: e, stackTrace: st);
      toast("扫描过程中出现异常：$e");
    }

    await Future.delayed(Duration(seconds: 10));
    await FlutterBluePlus.stopScan();
    isScanning.value = false;
    toast("扫描结束");
  }

  @override
  void dispose() {
    super.dispose();
    _scanSubscription?.cancel();
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await (await BLEDeviceManager.instance).connectToDevice(device);
  }

}
