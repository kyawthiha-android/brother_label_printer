// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:screenshot/screenshot.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         textTheme: TextTheme(
//             headline6: TextStyle(
//               color: Colors.yellow,
//               fontSize: 50,
//             )),
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(title: 'Screenshot Demo Home Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key? key, required this.title}) : super(key: key);
//   final String title;
//
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   //Create an instance of ScreenshotController
//   ScreenshotController screenshotController = ScreenshotController();
//
//   @override
//   void initState() {
//     // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Screenshot(
//               controller: screenshotController,
//               child:  Container(
//                 color: Colors.red,
//                 child: ListView.builder(
//                   itemCount: 3,
//                   physics: const NeverScrollableScrollPhysics(),
//                   shrinkWrap: true,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text('product $index'),
//                       trailing: const Text('2000'),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 25,
//             ),
//             ElevatedButton(
//               child: Text(
//                 'Capture Above Widget',
//               ),
//               onPressed: () {
//                 screenshotController
//                     .capture(delay: Duration(milliseconds: 10))
//                     .then((capturedImage) async {
//                   ShowCapturedWidget(context, capturedImage!);
//                 }).catchError((onError) {
//                   print(onError);
//                 });
//               },
//             ),
//             ElevatedButton(
//               child: Text(
//                 'Capture An Invisible Widget',
//               ),
//               onPressed: () {
//                 var container = Container(
//                     padding: const EdgeInsets.all(30.0),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.blueAccent, width: 5.0),
//                       color: Colors.redAccent,
//                     ),
//                     child: Text(
//                       "This is an invisible widget",
//                       style: Theme.of(context).textTheme.headline6,
//                     ));
//                 screenshotController
//                     .captureFromWidget(
//                     InheritedTheme.captureAll(
//                         context, Material(child: container)),
//                     delay: Duration(seconds: 1))
//                     .then((capturedImage) {
//                   ShowCapturedWidget(context, capturedImage);
//                 });
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Future<dynamic> ShowCapturedWidget(
//       BuildContext context, Uint8List capturedImage) {
//     return showDialog(
//       useSafeArea: false,
//       context: context,
//       builder: (context) => Scaffold(
//         appBar: AppBar(
//           title: Text("Captured widget screenshot"),
//         ),
//         body: Center(
//             child: capturedImage != null
//                 ? Image.memory(capturedImage)
//                 : Container()),
//       ),
//     );
//   }
//
// // _saved(File image) async {
// //   // final result = await ImageGallerySaver.save(image.readAsBytesSync());
// //   print("File Saved to Gallery");
// // }
// }
//
// // import 'dart:io';
// // import 'dart:math';
// // import 'dart:typed_data';
// // import 'dart:ui' as ui;
// //
// // import 'package:brother_label_printer/file_utils.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/rendering.dart';
// // import 'package:flutter/services.dart';
// //
// // void main() => runApp(MyApp());
// //
// // class UiImagePainter extends CustomPainter {
// //   final ui.Image image;
// //
// //   UiImagePainter(this.image);
// //
// //   @override
// //   void paint(ui.Canvas canvas, ui.Size size) {
// //     // simple aspect fit for the image
// //     var hr = size.height / image.height;
// //     var wr = size.width / image.width;
// //
// //     double ratio;
// //     double translateX;
// //     double translateY;
// //     if (hr < wr) {
// //       ratio = hr;
// //       translateX = (size.width - (ratio * image.width)) / 2;
// //       translateY = 0.0;
// //     } else {
// //       ratio = wr;
// //       translateX = 0.0;
// //       translateY = (size.height - (ratio * image.height)) / 2;
// //     }
// //
// //     canvas.translate(translateX, translateY);
// //     canvas.scale(ratio, ratio);
// //     canvas.drawImage(image, const Offset(0.0, 0.0), Paint());
// //   }
// //
// //   @override
// //   bool shouldRepaint(UiImagePainter other) {
// //     return other.image != image;
// //   }
// // }
// //
// // class UiImageDrawer extends StatelessWidget {
// //   final ui.Image image;
// //
// //   const UiImageDrawer({Key? key, required this.image}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return CustomPaint(
// //       size: Size.infinite,
// //       painter: UiImagePainter(image),
// //     );
// //   }
// // }
// //
// // class MyApp extends StatefulWidget {
// //   @override
// //   _MyAppState createState() => _MyAppState();
// // }
// //
// // class _MyAppState extends State<MyApp> {
// //   GlobalKey<OverRepaintBoundaryState> globalKey = GlobalKey();
// //
// //   late ui.Image? image = null;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         appBar: AppBar(actions: [
// //           IconButton(
// //               onPressed: () async {
// //                 final directory =
// //                     await FileUtils().createFolderInAppDocDir('image');
// //                 ByteData? byteData =
// //                     await image!.toByteData(format: ui.ImageByteFormat.png);
// //                 Uint8List? pngBytes = byteData?.buffer.asUint8List();
// //                 print(pngBytes);
// //                 File imgFile = File(
// //                     '$directory${DateTime.now().microsecondsSinceEpoch}.png');
// //                 print(imgFile.path);
// //                 imgFile.writeAsBytes(pngBytes!);
// //
// //                 if (imgFile != null) printJob(imgFile.path);
// //               },
// //               icon: const Icon(Icons.save))
// //         ]),
// //         body: image == null
// //             ? Capturer(
// //                 overRepaintKey: globalKey,
// //               )
// //             : UiImageDrawer(image: image!),
// //         floatingActionButton: image == null
// //             ? FloatingActionButton(
// //                 child: Icon(Icons.camera),
// //                 onPressed: () async {
// //                   // var renderObject = globalKey.currentContext?.findRenderObject();
// //                   RenderRepaintBoundary boundary = globalKey.currentContext!
// //                       .findRenderObject() as RenderRepaintBoundary;
// //                   ui.Image captureImage = await boundary.toImage();
// //                   setState(() => image = captureImage);
// //                 },
// //               )
// //             : FloatingActionButton(
// //                 onPressed: () => setState(() => image == null),
// //                 child: Icon(Icons.remove),
// //               ),
// //       ),
// //     );
// //   }
// //
//   void printJob(String filePath) {
//     MethodChannel methodChannel = const MethodChannel("file_receiver");
//     methodChannel
//         .invokeMethod("method", {'file_path': filePath})
//         .then((value) => print)
//         .catchError((e) => print);
//   }
// }
// //
// // class Capturer extends StatelessWidget {
// //   static final Random random = Random();
// //
// //   final GlobalKey<OverRepaintBoundaryState> overRepaintKey;
// //
// //   const Capturer({Key? key, required this.overRepaintKey}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return SingleChildScrollView(
// //       child: OverRepaintBoundary(
// //         key: overRepaintKey,
// //         child: RepaintBoundary(
// //           child: Column(
// //             children: List.generate(
// //               30,
// //               (i) => Container(
// //                 color: Color.fromRGBO(random.nextInt(256), random.nextInt(256),
// //                     random.nextInt(256), 1.0),
// //                 height: 100,
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class OverRepaintBoundary extends StatefulWidget {
// //   final Widget child;
// //
// //   const OverRepaintBoundary({Key? key, required this.child}) : super(key: key);
// //
// //   @override
// //   OverRepaintBoundaryState createState() => OverRepaintBoundaryState();
// // }
// //
// // class OverRepaintBoundaryState extends State<OverRepaintBoundary> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return widget.child;
// //   }
// // }
