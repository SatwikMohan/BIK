import 'package:app_activity_launcher/app_activity_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
class Option5 extends StatefulWidget {
  const Option5({super.key});

  @override
  State<Option5> createState() => _Option5State();
}

class _Option5State extends State<Option5> {

  FlutterTts flutterTts = FlutterTts();
  List<AppInfo> appList = [];

  Future<void> TextToSpeech(String text) async{
    List<dynamic> languages = await flutterTts.getLanguages;
    print("Languages => "+languages.toString());
    await flutterTts.setLanguage("en");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.awaitSynthCompletion(true);
    await flutterTts.speak(text);
  }

  void getAppList() async{
    List<AppInfo> apps = [];
    apps = await InstalledApps.getInstalledApps();
    // ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(apps.toString()),
    //     ));
    setState(() {
      appList = apps;
    });
    listening();
  }

  void listening() async{
    BluetoothConnection connection = await BluetoothConnection.toAddress("00:22:08:31:01:9A");
    connection.input?.listen((event) async {
      print(event);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(event.toString()),
          ));
      int ascii = event[0];
      String ch = String.fromCharCode(ascii);
      if(ch=="A"){
        if(options>=appList.length-1){
          setState(() {
            options=0;
          });                                                                                                                  
        }else{
          setState(() {
            options+=1;
          });
        }
        if(options>=0&&options<appList.length){
          TextToSpeech(appList[options].name);
        }
      }else{
        if(ch=="S"){
          if(options>=0&&options<appList.length){
            TextToSpeech("Opening ${appList[options].name}");
            var _app = AppActivityLauncher();
            await _app.openApp(appId: appList[options].packageName).whenComplete((){
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(appList[options].packageName),
                  ));
            }).onError((error, stackTrace){
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(error.toString()),
                  ));
            });
          }
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAppList();
  }

  int options =-1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(itemCount: appList.length,itemBuilder: (context,index){
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(appList[index].name,style: TextStyle(color: index==options?Colors.blue:Colors.black),),
        );
      }),
    );
  }
}
