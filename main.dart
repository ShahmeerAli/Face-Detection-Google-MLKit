import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:travelmate/FaceDetection.dart';

late List<CameraDescription> cameras;
void main() async {
  cameras = await availableCameras();
  await requestPermission();
  runApp(MyApp());
}

Future<void> requestPermission() async {
  final status = await Permission.camera.request();
  if (!status.isGranted) {
    runApp(PermissionDeniedApp());
  }
}

class PermissionDeniedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: AlertDialog(
            title: Text("Permission Denied"),
            content: Text("Camera access is required for verification."),
            actions: [
              TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: Text("OK"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// permission for the camera is added
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //use your own lottie file here
            Lottie.asset("assets/raw/face.json", width: 250, height: 250),
            Text(
              "Lets get Verified!",
              style: TextStyle(fontSize: 30, color: Colors.green),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 150,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final camera = await availableCameras();
                    if (camera.isNotEmpty) {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FaceDetection(),
                        ),
                      );

                      if (result == true) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //use your own lottie file here
                                  Lottie.asset(
                                    "assets/raw/ok.json",
                                    width: 200,
                                    height: 200,
                                  ),
                                  Text("Verification Successful"),
                                  //Move to the next screen
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            content: Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //use your own lottie file here
                                  Lottie.asset(
                                    "assets/raw/failed.json",
                                    width: 200,
                                    height: 200,
                                  ),
                                  Text("Verification Failed! Try Again"),
                                  //try again
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  child: Text("Start", style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
