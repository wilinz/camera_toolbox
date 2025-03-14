import 'dart:async';
import 'dart:io';

import 'package:camera_toolbox/common/logger.dart';
import 'package:camera_toolbox/toast.dart';
import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
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
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    bool isAndroid = Platform.isAndroid;
    int sdkVersion = isAndroid ? (await deviceInfo.androidInfo).version.sdkInt : 0;

    // 创建一个空的权限列表并根据设备平台添加权限
    List<Permission> permissions = [];

    if (isAndroid) {
      if (sdkVersion < 31) permissions.add(Permission.locationWhenInUse);
      permissions.addAll([Permission.bluetoothScan, Permission.bluetoothConnect]);
    } else {
      permissions.addAll([Permission.bluetoothScan, Permission.bluetoothConnect]);
    }

    // 请求权限并判断是否全部授权
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    bool allGranted = statuses.values.every((status) => status.isGranted);

    if (allGranted && (isAndroid && sdkVersion >= 31 || statuses[Permission.locationWhenInUse]?.isGranted == true)) {
      logger.i("权限检查完成");
      return true;
    }

    toastFailure0("位置或蓝牙权限不足，请检查设置！");
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
    toast(
        "尝试连接设备：${device.platformName.isNotEmpty ? device.platformName : '未知设备'} (${device.remoteId})");
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
