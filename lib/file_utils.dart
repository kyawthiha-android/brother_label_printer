import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  void createImageFile(Image image) async {
    String folderPath = await createFolderInAppDocDir('printer');
    File file = File(
        folderPath + DateTime.now().microsecondsSinceEpoch.toString() + '.png');
    print(file.path);
    ByteData? data = await image.toByteData();
    List<int> list = data!.buffer.asUint8List();
    print(list.length);
    file.writeAsBytesSync(list);
    print('hello');
  }

  Future<String> createFolderInAppDocDir(String folderName) async {
    //Get this App Document Directory
    Directory? _baseDir;
    if (Platform.isAndroid) {
      // _baseDir = await getExternalStorageDirectory();
      _baseDir = Directory("storage/emulated/0/printer/$folderName");
      // _baseDir = await getExternalStorageDirectory();
    } else {
      _baseDir = await getApplicationDocumentsDirectory();
    }
    final Directory _appDocDirFolder = Directory('${_baseDir.path}/');
    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      return _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }
}
