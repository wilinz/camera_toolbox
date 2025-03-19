import 'dart:io';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';

Future<GetStorage> newAppSupportGetStorage({String container = "default"}) async {
  Directory supportDirectory = await getApplicationSupportDirectory();

  final file = File(supportDirectory.path);

  if (!await file.exists()) {
    supportDirectory.create(recursive: true);
  }

  final gs = GetStorage(container, file.path);
  await gs.initStorage;
  return gs;
}