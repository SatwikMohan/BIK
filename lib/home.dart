import 'dart:async';

import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:piyush_dutta_innovation/braille_map.dart';
import 'package:piyush_dutta_innovation/option_1.dart';
import 'package:piyush_dutta_innovation/option_2.dart';
import 'package:piyush_dutta_innovation/option_3.dart';
import 'package:piyush_dutta_innovation/option_4.dart';
import 'package:piyush_dutta_innovation/option_5.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<BluetoothDevice> deviceList=<BluetoothDevice>[];
  // BluetoothConnection? connection;

  void connectToModule() async{
    BluetoothDevice device=deviceList[deviceList.indexWhere((element)=>
    element.address.toString()=="00:22:08:31:01:9A"
    )];
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(device.name.toString()),
        ));
    try{
      BluetoothConnection connection = await BluetoothConnection.toAddress("00:22:08:31:01:9A");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(connection.isConnected.toString()),
          ));
      if(connection.isConnected){
        TextToSpeech("Successfully Connected to Bik").whenComplete((){
          TextToSpeech("Press A to move through options and press home to select");
        });
      }else{
        TextToSpeech("Failure Connecting to Bik");
      }
      print('Connected to the device');
      String braille_letter = "";
      String letter="";
      connection.input?.listen((event) {
        print(event);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(event.toString()),
            ));
        int ascii = event[0];
        String ch = String.fromCharCode(ascii);

        if(ch=="A"){
          if(options>=5){
            setState(() {
              options=1;
            });
          }else{
            setState(() {
              options+=1;
            });
          }
          if(options==1){
            TextToSpeech("option 1 Start Typing");
          }
          else if(options==2){
            TextToSpeech("option 2 Ask Gemini");
          }
          else if(options==3){
            TextToSpeech("option 3 Call Someone");
          }
          else if(options==4){
            TextToSpeech("option 4 Load My Write Ups");
          }
          else if(options==5){
            TextToSpeech("option 5 Open installed apps from device");
          }
        }else{
          if(ch=="S"){
            TextToSpeech("You selected option $options");
            if(options==1){
              connection.close();
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Option1();
              }));
            }else if(options==2){
              connection.close();
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Option2();
              }));
            }else if(options==3){
              connection.close();
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Option3();
              }));
            }else if(options==4){
              connection.close();
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Option4();
              }));
            }else if(options==5){
              connection.close();
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return Option5();
              }));
            }
          }else{

          }
        }

      });
    }catch(err){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("error while connecting"),
          ));
      print(err);
    }
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
              content: Text('Bluetooth has been enabled')),
        );

        scanDevices();

      }
      else if (result == "false") {
        // Bluetooth has not been enabled
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Bluetooth cannot be enabled')),
        );
      }
    });

  }


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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EnableBluetooth();
  }

  int options = 0;
  FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 90,
              decoration: BoxDecoration(
                color: options==1?Colors.blue:Colors.white
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text("Start Typing",style: TextStyle(fontWeight: FontWeight.bold),),
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 90,
                decoration: BoxDecoration(
                    color: options==2?Colors.blue:Colors.white
                ),
              child: Align(
                alignment: Alignment.center,
                child: Text("Ask Gemini",style: TextStyle(fontWeight: FontWeight.bold),),
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 90,
                decoration: BoxDecoration(
                    color: options==3?Colors.blue:Colors.white
                ),
              child: Align(
                alignment: Alignment.center,
                child: Text("Call someone",style: TextStyle(fontWeight: FontWeight.bold),),
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 90,
                decoration: BoxDecoration(
                    color: options==4?Colors.blue:Colors.white
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Load and Read My Write Ups",style: TextStyle(fontWeight: FontWeight.bold),),
                )
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: 90,
                decoration: BoxDecoration(
                    color: options==5?Colors.blue:Colors.white
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text("Open installed apps",style: TextStyle(fontWeight: FontWeight.bold),),
                )
            ),
          ),
        ],
      ),
    );
  }

  void scanDevices() async{
    setState(() {
      deviceList.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('Scanning devices please wait')),
    );
    StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
          print(r.device.name);
          print(r);
          setState(() {
            deviceList.add(r.device);
          });
          if(r.device.address.toString()=="00:22:08:31:01:9A"){// 00:22:08:31:01:9A
            connectToModule();
          }
        });

    _streamSubscription.onDone(() {

    });


    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Stop Scan Called'),
        ));

    print('Stop Scan Called');

  }



}
