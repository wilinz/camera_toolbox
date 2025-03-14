import 'dart:async';

import 'package:camera_toolbox/common/logger.dart';
import 'package:camera_toolbox/toast.dart';
import 'package:collection/collection.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class BLEScanController extends GetxController {
  final isScanning = false.obs;
  final scanResults = [].obs;
  BluetoothDevice? connectedDevice;
  final services = [].obs;

  StreamSubscription<List<ScanResult>>? _scanSubscription;

  Future<bool> _checkPermissions() async {
    var statuses = await [
      Permission.locationWhenInUse,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
    ].request();

    if (statuses[Permission.locationWhenInUse]!.isGranted &&
        statuses[Permission.bluetoothScan]!.isGranted &&
        statuses[Permission.bluetoothConnect]!.isGranted) {
      logger.i("权限检查完成");
      return true;
    } else {
      toastFailure0("位置或蓝牙权限不足，请检查设置！");
    }
    return false;
  }

  Future<void> startScan() async {
    toast("开始扫描设备...");

    final hasPermissions = await _checkPermissions();
    if (!hasPermissions) return;

    // 检查蓝牙是否开启
    if (await FlutterBluePlus.adapterState.first != BluetoothAdapterState.on) {
      toastFailure0("请先开启蓝牙");
      isScanning.value = false;
      return;
    }

    scanResults.clear();
    isScanning.value = true;

    try {
      await FlutterBluePlus.startScan(
        timeout: Duration(seconds: 10),
        removeIfGone: Duration(seconds: 10),
        continuousUpdates: true,
      );
      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        scanResults.value = results.sortedBy((e) {
          return e.device.platformName.isNotEmpty ? e.device.platformName : "z";
        });
      });
    } catch (e, st) {
      logger.e("扫描过程中出现异常", error: e, stackTrace: st);
      toast("扫描过程中出现异常：$e");
    }

    await Future.delayed(Duration(seconds: 10));
    await FlutterBluePlus.stopScan();
    isScanning.value = false;
    toast("扫描结束");
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    toast("尝试连接设备：${device.platformName.isNotEmpty ? device.platformName : '未知设备'} (${device.remoteId})");
    try {
      await device.connect();
      List<BluetoothService> services = await device.discoverServices();
        connectedDevice = device;
        this.services.value = services;
        logger.d("services: $services");
      toastSuccess0("连接成功，发现 ${services.length} 个服务");
    } catch (e) {
      toastFailure0("连接异常：$e");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scanSubscription?.cancel();
  }

}
