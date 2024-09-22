import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:path_provider/path_provider.dart';
import 'package:piyush_dutta_innovation/braille_map.dart';
class Option1 extends StatefulWidget {
  // late BluetoothConnection connection;
  // Option1(this.connection);

  @override
  State<Option1> createState() => _Option1State();
}

class _Option1State extends State<Option1> {

  // late BluetoothConnection connection;
  // _Option1State(this.connection);

  void listening() async{
    String braille_letter="";
    String letter="";
    BluetoothConnection connection = await BluetoothConnection.toAddress("00:22:08:31:01:9A");
    connection.input?.listen((event) async {
      print(event);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(event.toString()),
          ));
      int ascii = event[0];
      String ch = String.fromCharCode(ascii);
      if(ch!="S"){
        braille_letter+=ch;
      }else if(braille_letter!=""){
        letter = braille[braille_letter].toString();
        if(letter!="BackSpace"){
          setState(() {
            text+=letter;
          });
        }else{
          setState(() {
            text = text.substring(0,text.length-1);
          });
        }
        braille_letter="";
      }
      else{
        //Save file
        String name = "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
        final storageRef = FirebaseStorage.instance.ref("MyFolder").child("${name}.txt");
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file = File('${directory.path}/${name}.txt');
        await file.writeAsString(text);
        storageRef.putFile(file).whenComplete((){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("File Saved"),
              ));
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listening();
  }

  String text = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(text,style: TextStyle(color: Colors.black,fontSize: 12,fontWeight: FontWeight.bold),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
