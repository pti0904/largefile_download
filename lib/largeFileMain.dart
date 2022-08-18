import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
//io 파일 입출력 돕는 패키지

class LargeFileMain extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LargeFileMain();
}
//StatefulWidget 상속받는 largeFileMain class생성 후 _LargeFileMain 함수를 반환, State<LargeFileMain>
//을 상속받는 클래스

class _LargeFileMain extends State<LargeFileMain> {
  final imgUrl =
      'http://images.pexels.com/photos/240040/pexels-photo-240040.jpeg?auto=compress';
  bool downloading = false;
  var progressString = "";
  String file = "";

  @override
  Widget build(BuildContext context) {
    return null;
  }

  Future<void> downloadFile() async {
    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory();
      await dio.download(imgUrl, '${dir.path}/myimage.jpg',
          onReceiveProgress: (rec, total) {
        print("Rec: $rec, Total: $total");
        file = '${dir.path}/myimage.jpg';
        setState(() {
          downloading = true;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      });
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = 'Completed';
    });
    print('Download completed');
  }
}
