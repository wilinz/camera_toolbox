import 'package:flutter_blue_plus/flutter_blue_plus.dart';

abstract class BLEFeature {
  final BluetoothDevice device;

  BLEFeature({required this.device});
}