import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:piyush_dutta_innovation/braille_map.dart';
import 'package:piyush_dutta_innovation/dial_phone.dart';
class Option3 extends StatefulWidget {
  const Option3({super.key});

  @override
  State<Option3> createState() => _Option3State();
}

class _Option3State extends State<Option3> {

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
        if(options>=2){
          setState(() {
            options=1;
          });
        }else{
          setState(() {
            options+=1;
          });
        }
        if(options==1){
          TextToSpeech("option 1 Dial phone number");
        }
        else if(options==2){
          TextToSpeech("option 2 Dial from contacts");
        }
      }else{
        if(ch=="S"){
          TextToSpeech("You selected option $options");
          if(options==1){
            connection.close();
            Navigator.push(context, MaterialPageRoute(builder: (context){
              return DialPhone();
            }));
          }else if(options==2){
            //connection.close();
            // Navigator.push(context, MaterialPageRoute(builder: (context){
            //   return Option2();
            // }));
          }
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listening();
  }

  String phoneNum = "";
  int options =0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
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
                    child: Text("Dial Phone Number",style: TextStyle(fontWeight: FontWeight.bold),),
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
                    child: Text("Dial from contacts",style: TextStyle(fontWeight: FontWeight.bold),),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }
}
