import 'package:camera_toolbox/core/ble/features/ble_features.dart';
import 'package:collection/collection.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BLECameraController extends BLEFeature {

  static const String cameraServiceUUID = "00030000-0000-1000-0000-d8492fffa821";
  static const String shootingCharacteristics = "00030030-0000-1000-0000-d8492fffa821";

  BLECameraController({required super.device});

  shoot() async {
    final services = await device.discoverServices();
    BluetoothService? cameraService = services.firstWhereOrNull(
          (s) => s.uuid.toString().toLowerCase() == cameraServiceUUID,
    );
    if (cameraService == null) {
      throw Exception("相机操作服务未找到！");
    }

    BluetoothCharacteristic? shootingChar = cameraService.characteristics.firstWhereOrNull(
          (c) => c.uuid.toString().toLowerCase() == shootingCharacteristics,
    );
    if (shootingChar == null) {
      throw Exception("拍摄按键 characteristic 未找到！");
    }

    try {
      await shootingChar.write([0x00, 0x01], withoutResponse: false);
      print("发送快门按下命令");
      await Future.delayed(Duration(milliseconds: 200));
      await shootingChar.write([0x00, 0x02], withoutResponse: false);
      print("发送快门释放命令");
    } catch (e) {
      print("拍照过程中出现异常：$e");
    }
  }


}