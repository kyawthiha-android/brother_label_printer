import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:brother_label_printer/file_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PDFCreator {
  final pdf = pw.Document();

  create(BuildContext context) async {
    TextTheme textTheme = Theme.of(context).textTheme;

    // Uint8List image = await imageAsset('marigold.jpg');
    pw.MemoryImage image = await pw.MemoryImage(
      (await rootBundle.load('assets/marigold.jpg')).buffer.asUint8List(),
    );

    pdf.addPage(pw.Page(
      // pageFormat: const PdfPageFormat(60, 150),
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) => pw.Container(
        color: PdfColors.white,
        child: pw.Center(
          child: pw.Column(
            children: [
              pw.Container(
                height: 150,
                width: 150,
                decoration: pw.BoxDecoration(
                  shape: pw.BoxShape.circle,
                  image:
                      pw.DecorationImage(image: image, fit: pw.BoxFit.contain),
                ),
              ),
              // pw.Image(image, height: 50, width: 50),
              pw.Text('MARI GOLD',
                  style:
                      pw.TextStyle(fontSize: textTheme.labelLarge?.fontSize)),
              pw.SizedBox(height: 8),
              pw.Text('Hello'),
              pw.Text('Hello'),
              pw.Text('Hello'),
              pw.Text('Hello'),
              pw.Text('Hello'),
              pw.Text('Hello'),
            ],
          ),
        ),
      ),
    ));
    String folder = await createFolderInAppDocDir('pdf');
    final file = File(folder + '${DateTime.now().microsecondsSinceEpoch}.pdf');
    print(file.path);
    await file.writeAsBytes(await pdf.save());
    // printJob(file.path);
    print('success');
    pdfToImage(pdf);
  }

  Future<String> createFolderInAppDocDir(String folderName) async {
    //Get this App Document Directory
    Directory? _baseDir;
    if (Platform.isAndroid) {
      _baseDir = Directory("storage/emulated/0/$folderName");
    } else {
      _baseDir = await getApplicationDocumentsDirectory();
    }
    final Directory _appDocDirFolder =
        Directory('${_baseDir.path}/$folderName/');
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

  void pdfToImage(pw.Document doc) async {
    // doc.document.pdfPageList.pages;
    // Stream<PdfRaster> ls = Printing.raster(await doc.save(),
    //     pages: [0, doc.document.pdfPageList.pages.length - 1], dpi: 72);
    // FileUtils fileUtils = FileUtils();
    // ls.listen((page) async {
    //   final image = await page.toImage();
    //   fileUtils.createImageFile(image);
    // });

    File? imgFile = null;

    await for (var page
        in Printing.raster(await doc.save(), pages: [0], dpi: 160)) {
      ui.Image image = await page.toImage();

      final directory = await FileUtils().createFolderInAppDocDir('image');
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List? pngBytes = byteData?.buffer.asUint8List();
      print(pngBytes);
      imgFile = File('$directory${DateTime.now().microsecondsSinceEpoch}.png');
      print(imgFile.path);
      imgFile.writeAsBytes(pngBytes!);
    }
    if (imgFile != null) printJob(imgFile.path);
  }

  // void holy(ui.Image image) async {
  //   String folder = await FileUtils().createFolderInAppDocDir('image');
  //   File file = File(folder + 'xxx.png');
  //   final data = await image.toByteData(format: ui.ImageByteFormat.png);
  //   final bytes = data!.buffer.asUint64List();
  //
  //   file = await file.writeAsBytes(bytes, flush: true);
  //   print(file.path);
  // }

  // Future printPng() async {
  //   try {
  //     RenderRepaintBoundary boundary = _globalKey.currentContext!
  //         .findRenderObject() as RenderRepaintBoundary;
  //
  //     // if it needs repaint, we paint it.
  //     if (boundary.debugNeedsPaint) {
  //       Timer(const Duration(seconds: 1), () => printPng());
  //       return null;
  //     }
  //
  //     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //     ByteData? byteData =
  //     await image.toByteData(format: ui.ImageByteFormat.png);
  //     var pngBytes = byteData!.buffer.asUint8List();
  //
  //     final imageToPrint = await flutterImageProvider(MemoryImage(pngBytes));
  //     final doc = pw.Document();
  //     doc.addPage(pw.Page(build: (pw.Context context) {
  //       return pw.Center(child: pw.Image(imageToPrint)); // Center
  //     }));
  //     await Printing.layoutPdf(
  //         onLayout: (PdfPageFormat format) async => doc.save());
  //     return pngBytes;
  //   } catch (e) {
  //     print(e);
  //     return null;
  //   }
  // }

  String uint8ListTob64(Uint8List uint8list) {
    String base64String = base64Encode(uint8list);
    String header = "data:image/png;base64,";
    return header + base64String;
  }

  Future<Uint8List> imageAsset(String name) async {
    final data = await rootBundle.load(name);
    return data.buffer.asUint8List();
  }

  void printJob(String filePath) {
    MethodChannel methodChannel = const MethodChannel("file_receiver");
    methodChannel
        .invokeMethod("method", {'file_path': filePath})
        .then((value) => print)
        .catchError((e) => print);
  }
}
