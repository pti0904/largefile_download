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
  bool downloading = false;
  var progressString = "";
  String file = "";

  TextEditingController? _editingController;

  @override
  void initState() {
    super.initState();
    _editingController = new TextEditingController(
      text: 'https://images.pexels.com/photos/240040/pexels-photo-240040.jpeg?auto=compress');
  }



  /*dio 선언한 후 내부 디렉토리 가져옴 getApplicationDocumentsDirectory()함수는
  * path_provider 패키지가 제공하며 플러터 앱의 내부 디렉토리를 가져오는 역할을 한다.
  * dio.download 이용해 url에 담긴 주소에서 파일을 내려받음, 파일은 myimage.jpg로 저장됨
  * 데이터 받을때 마다 onReceiveProgress 이벤트가 발생하며 받은 데이터의 크기를 확인할 수 있다.
  * 이 함수가 전달받은 rec는 받은 데이터, total은 전체크기, 내려받기 시작되면 downloading= true 선언
  * 얼마나 받았는지 계산하고 프로그레스에 표시할 문자열에 입력 다 내려받으면 downloading = false되고 문자열 complete
  * */
  Future<void> downloadFile() async {
    Dio dio = Dio();
    try {
      var dir = await getApplicationDocumentsDirectory();
      await dio.download(_editingController!.value.text, '${dir.path}/myimage.jpg',
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _editingController,
          style: TextStyle(color: Colors.white),
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: 'Enter URL'),
        ),
      ),
      body: Center(
          child: downloading ? Container(
            height: 120.0,
            width: 200.0,
            child: Card(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Downloading File : $progressString',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          )
          : FutureBuilder(
            builder : (context, snapshot){
            switch(snapshot.connectionState){
              //none : FutureBuilder.future가 null일 때
            //waiting : FutureBuilder.future가 아직 실행되지 않은 상태일 때
            //active : FutureBuilder.future가 실행되고 있는 상태일 때
            //done : FutureBuilder.future가 완료된 상태일 때

              case ConnectionState.none:
                print('waiting');
                return CircularProgressIndicator();
              case ConnectionState.active:
                print('active');
                return CircularProgressIndicator();
              case ConnectionState.done:
                print('done');
                if (snapshot.hasData) {
                  return snapshot.data as Widget;
                }
            }
              print('end process');
            return Text('데이터 없음');
            },
          future: downloadWidget(file)
          )


          ),
        // downloading이 false일 때 코드는 다음단계에서 작성함
          floatingActionButton: FloatingActionButton(
          onPressed: () {
    downloadFile();
    },
      child: Icon(Icons.file_download),

    ),
    );
  }
  Future<Widget> downloadWidget(String filePath) async {
    File file = File(filePath);
    bool exist = await file.exists();

    //캐시 초기화하기
    new FileImage(file).evict();

    if (exist) {
      return Center(
        child: Column(
          children: <Widget>[Image.file(File(filePath))],
        ),
      );
    } else {
      return Text('없음');
    }
  }
}
