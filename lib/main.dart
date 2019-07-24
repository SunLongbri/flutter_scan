import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrscan/qrscan.dart' as scanner;

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

//我在这边添加了一行注释 ......
class _MyAppState extends State<MyApp> {
  String barcode = "";
  String btnText = '点击扫描';

  @override
  initState() {
    super.initState();
    requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
        child: MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('二维码扫描'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(barcode),
              MaterialButton(
                onPressed: () {
                  if (btnText.contains('点击扫描')) {
                    scan();
                  } else if (btnText.contains('点击开启扫码权限')) {
                    requestPermission();
                  }
                },
                child: Text(btnText),
                color: Colors.blue,
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Future scan() async {
    try {
      String barcode = await scanner.scan();
      setState(() => this.barcode = '扫描结果为:${barcode}');
    } on Exception catch (e) {
      if (e == scanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        print('scanner.CamerAccessDenied:${scanner.CameraAccessDenied}');
        setState(() => this.barcode = 'Unknown error: $e');
      }
    }
  }

  Future requestPermission() async {
    // 申请权限
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.camera]);

    // 申请结果
    PermissionStatus permission =
        await PermissionHandler().checkPermissionStatus(PermissionGroup.camera);

    if (permission == PermissionStatus.granted) {
      print('权限申请通过!');
      setState(() {
        btnText = '点击扫描';
      });
    } else {
      print('权限申请被拒绝!');
      showToast("扫描需要相机权限呦!",position: ToastPosition.bottom);
      setState(() {
        btnText = '点击开启扫码权限';
      });
    }
  }
}

class Qrscan {}
