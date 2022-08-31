import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'PDF Brother printer'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScreenshotController screenshotController = ScreenshotController();
  List<String> printerList = ['W29', 'W90'];
  int selectedPrinterIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Printer'),
      ),
      body: Column(
        children: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (builder) => Dialog(
                          child: ListView.builder(
                              itemCount: printerList.length,
                              itemBuilder: (context, index) {
                                return Material(
                                  child: RadioListTile<int>(
                                      value: index,
                                      title:
                                          Text(printerList[index].toString()),
                                      groupValue: selectedPrinterIndex,
                                      onChanged: (selectedPrinter) {
                                        setState(() {
                                          selectedPrinterIndex =
                                              selectedPrinter ?? 0;
                                          Navigator.pop(context);
                                        });
                                      }),
                                );
                              }),
                        ));
              },
              icon: const Icon(Icons.panorama_photosphere)),
          if (selectedPrinterIndex == 3)
            Screenshot(
              controller: screenshotController,
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: selectedPrinterIndex == 0
                      ? MainAxisAlignment.start
                      : MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        BarcodeWidget(
                          data: '7876537890932',
                          drawText: true,
                          errorBuilder: (context, error) => Text(error),
                          // barcode: Barcode.ean13(),
                          barcode: Barcode.qrCode(),
                          // width: selectedPrinterIndex == 0 ? 200 : null,
                          // // height: 80,
                          // height: selectedPrinterIndex == 0 ? 100 : null,
                          // data: 'https://pub.dev/packages/barcode_widget',
                        ),
                        const Align(
                          alignment: Alignment.center,
                          child: Text('product name'),
                        ),
                        // const SizedBox(height: 16)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          Screenshot(
            controller: screenshotController,
            child: Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BarcodeWidget(
                    data: '7876537890932',
                    drawText: true,
                    errorBuilder: (context, error) => Text(error),
                    // barcode: Barcode.ean13(),
                    barcode: Barcode.qrCode(),
                    // width: selectedPrinterIndex == 0 ? 200 : null,
                    // // height: 80,
                    // height: selectedPrinterIndex == 0 ? 100 : null,
                    // data: 'https://pub.dev/packages/barcode_widget',
                  ),
                  Column(
                    children: const [
                      Align(
                        alignment: Alignment.center,
                        child: Text('product name'),
                      ),
                      // SizedBox(height: 16)
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          String? path = await screenshotController
              .captureAndSave('storage/emulated/0/printer/ss/');
          printJob(path ?? '');
        },
      ),
    );
  }

  void printJob(String filePath) {
    MethodChannel methodChannel = const MethodChannel("file_receiver");
    methodChannel
        .invokeMethod("method",
            {'file_path': filePath, 'roll_index': selectedPrinterIndex})
        .then((value) => print)
        .catchError((e) => print);
  }
}
