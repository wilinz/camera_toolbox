import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

Future<GetStorage> newAppSupportGetStorage({required String container}) async {
  Directory supportDirectory = await getApplicationSupportDirectory();

  final file = File(supportDirectory.path);

  if (!await file.exists()) {
    supportDirectory.create(recursive: true);
  }

  return GetStorage(container, file.path);
}