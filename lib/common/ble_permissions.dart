import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import 'logger.dart';

Future<bool> checkBluetoothPermissions() async {
  if (!GetPlatform.isMobile) return true;
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool isAndroid = Platform.isAndroid;
  int sdkVersion =
      isAndroid ? (await deviceInfo.androidInfo).version.sdkInt : 0;

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

  if (allGranted &&
      (isAndroid && sdkVersion >= 31 ||
          statuses[Permission.locationWhenInUse]?.isGranted == true)) {
    logger.i("权限检查完成");
    return true;
  }

  logger.i("位置或蓝牙权限不足，请检查设置！");
  return false;
}
