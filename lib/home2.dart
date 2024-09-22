import 'dart:async';
import 'dart:convert';

import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:idle_detector_wrapper/idle_detector_wrapper.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:piyush_dutta_innovation/braille_map_new.dart';
class Home2 extends StatefulWidget {
  const Home2({super.key});

  @override
  State<Home2> createState() => _HomeState2();
}

class _HomeState2 extends State<Home2> {

  List<BluetoothDevice> deviceList=<BluetoothDevice>[];
  bool hand1=false,hand2=false;
  late BluetoothConnection connection1,connection2;
  String text="";
  String temp="";
  String getPrompt(String TEXT){
    String prompt="I will give you a text as input. You have to remove the word or substring null from the text if found and replace with possible correct word only if required. Add necessary punctuation, auto type the incomplete words except the last word. No need to auto complete the text, or change the vocabulary or change it. The complete text will be in uppercase change the words into characters with proper case that is whether lower case or upper case. Return your response as a Json string which I can decode by myself and not as a code and no need to say anything else. In the json string the key should be fix_text for the value. The text is : ${TEXT}";
    return prompt;
  }
  void connectToModule(String address) async{
      if(address=="00:22:08:31:01:9A"){
        try{
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Connecting...",),
                duration: Duration(milliseconds: 900),
              ));
          connection1 = await BluetoothConnection.toAddress("00:22:08:31:01:9A");
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(connection1.isConnected.toString()),
                duration: Duration(milliseconds: 700),
              ));
          if(connection1.isConnected){
            print("Connected to ${address}");
            setState(() {
              hand1=true;
            });
            await Future.delayed(Duration(seconds: 2));
          }else{
            print("Failure connecting ${address}");
          }
        }catch(e){
          print("${address}=>>>${e}");
        }
      }else{
        try{
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Connecting...",),
                duration: Duration(milliseconds: 900),
              ));
          connection2 = await BluetoothConnection.toAddress("00:22:12:00:4D:25");
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(connection2.isConnected.toString()),
                duration: Duration(milliseconds: 700),
              ));
          if(connection2.isConnected){
            print("Connected to ${address}");
            setState(() {
              hand2=true;
            });
            await Future.delayed(Duration(seconds: 2));
          }else{
            print("Failure connecting ${address}");
          }
        }catch(e){
          print("${address}=>>>${e}");
        }
      }
      if(hand1&&hand2){
        connection1.input?.listen((event){
          print(event);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(event.toString()),
                duration: Duration(milliseconds: 500),
              ));
          int ascii = event[0];
          String ch = String.fromCharCode(ascii);
          if(ch!='S'){
            temp+=ch;
          }else{
            if(temp.isNotEmpty) {
              setState(() {
                text+=BRAILLE[temp].toString();
              });
              temp="";
            }else{
              if(text.length>=5){
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Fixing text"),
                      duration: Duration(milliseconds: 500),
                    ));
                final gemini = Gemini.instance;
                gemini.text(getPrompt(text))
                    .then((value){
                      if(value!=null){
                        if(value.output!=null){
                          String jsonString  = value.output!;
                          print(jsonString);
                          final result = jsonDecode(jsonString);
                          setState(() {
                            text=result["fix_text"].toString();
                          });
                        }else{
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(
                          //       content: Text("Cannot fix text at this moment due to no valid response"),
                          //     ));
                          print("null output");
                        }
                      }else{
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(
                        //       content: Text("Cannot fix text at this moment due to no valid response"),
                        //     ));
                        print("null value");
                      }
                }) /// or value?.content?.parts?.last.text
                    .catchError((e){
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Cannot fix text at this moment"),
                      ));
                });
              }
            }
          }
        }).onDone((){
          setState(() {
            hand1=false;
          });
        });
        connection2.input?.listen((event){
          print(event);
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(event.toString()),
                duration: Duration(milliseconds: 500),
              ));
          int ascii = event[0];
          String ch = String.fromCharCode(ascii);
          if(ch!='S'){
            temp+=ch;
          }else{
            if(temp.isNotEmpty) {
              setState(() {
                text+=BRAILLE[temp].toString();
              });
              temp="";
            }else{
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Fixing text"),
                  ));
            }
          }
        }).onDone((){
          setState(() {
            hand2=false;
          });
        });
      }
  }
  void scanDevices() async{
    setState(() {
      deviceList.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Scanning devices please wait'),
        duration: Duration(milliseconds: 700),
      ),
    );
    StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
          print("${r.device.name} ${r.device.address}");
          setState(() {
            deviceList.add(r.device);
          });
          if(r.device.name.toString()=="HC-05"){// 00:22:08:31:01:9A
            print("***${r.device.name} ${r.device.address}***");
          }
        });

    _streamSubscription.onDone(() {
      //_streamSubscription.cancel();
      for(var device in deviceList){
        if((device.address.toString()=="00:22:08:31:01:9A")||(device.address.toString()=="00:22:12:00:4D:25")){// 00:22:08:31:01:9A
          connectToModule(device.address.toString());
        }
      }
    });


    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stop Scan Called'),
          duration: Duration(milliseconds: 700),
        ));

    print('Stop Scan Called');

  }


  void EnableBluetooth() async{
    await Permission.bluetooth.request();
    await Permission.bluetoothConnect.request();
    await Permission.bluetoothScan.request();

    BluetoothEnable.enableBluetooth.then((result) {
      if (result == "true") {
        // Bluetooth has been enabled
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Bluetooth has been enabled'),
            duration: Duration(milliseconds: 500),
          ),
        );

        scanDevices();

      }
      else if (result == "false") {
        // Bluetooth has not been enabled
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Bluetooth cannot be enabled')
          ),
        );
      }
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EnableBluetooth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(hand1?"Connected":"Disconnected",style: GoogleFonts.orbitron(color: Colors.white,fontWeight: FontWeight.bold),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(hand2?"Connected":"Disconnected",style: GoogleFonts.orbitron(color: Colors.white,fontWeight: FontWeight.bold),),
          ),
          ElevatedButton(onPressed:  (){
            setState(() {
              text="";
            });
          }, child: Text('reset'))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(text,style: GoogleFonts.patrickHand(color: Colors.white,fontSize: 24,fontWeight: FontWeight.bold),),
      ),
    );
  }
}
