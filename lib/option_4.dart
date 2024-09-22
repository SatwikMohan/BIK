
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
class Option4 extends StatefulWidget {
  const Option4({super.key});

  @override
  State<Option4> createState() => _Option4State();
}

class _Option4State extends State<Option4> {

  List<File> files = [];

  FlutterTts flutterTts = FlutterTts();

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

  void listening() async{
    BluetoothConnection connection = await BluetoothConnection.toAddress("00:22:08:31:01:9A");
    connection.input?.listen((event) {
      print(event);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(event.toString()),
          ));
      int ascii = event[0];
      String ch = String.fromCharCode(ascii);
      if(ch=="A"){
        if(options>=files.length-1){
          setState(() {
            options=0;
          });
        }else{
          setState(() {
            options+=1;
          });
        }
        TextToSpeech("File $options");
      }else{
        if(ch=="S"){
          if(options>=0&&options<files.length){
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(files[options].readAsStringSync()),
                ));
            TextToSpeech(files[options].readAsStringSync());
          }
        }else{

        }
      }
    });
  }

  void loadFiles() async{
    final ref= FirebaseStorage.instance.ref("MyFolder/");
    ref.list().then((value){
      final list = value.items;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(list.toString()),
            duration: Duration(seconds: 4),
          ));
      list.forEach((element) async{
        String name = "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}-${DateTime.now().microsecond}";
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file = File('${directory.path}/${name}.txt');
        element.writeToFile(file);
        setState(() {
          files.add(file);
        });
      });
      listening();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero,(){
      loadFiles();
    });
  }

  int options=-1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        itemCount: files.length,
          itemBuilder: (context,index){
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("File${index}",style: TextStyle(color: options==index?Colors.blue:Colors.black,fontWeight: FontWeight.bold),),
          );
      })
    );
  }
}
