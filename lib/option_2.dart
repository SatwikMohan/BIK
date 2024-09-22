import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:piyush_dutta_innovation/braille_map.dart';
class Option2 extends StatefulWidget {
  const Option2({super.key});

  @override
  State<Option2> createState() => _Option2State();
}

class _Option2State extends State<Option2> {

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
    String braille_letter ="";
    String letter = "";
    BluetoothConnection connection = await BluetoothConnection.toAddress("00:22:08:31:01:9A");
    connection.input?.listen((event) {
      print(event);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(event.toString()),
          ));
      int ascii = event[0];
      String ch = String.fromCharCode(ascii);

      if(ch!="S"){
        braille_letter+=ch;
      }else{
        if(braille_letter!=""){
          letter = braille[braille_letter].toString();
          if(letter!="BackSpace"){
            setState(() {
              prompt+=letter;
            });
          }else{
            setState(() {
              prompt = prompt.substring(0,prompt.length-1);
            });
          }
          braille_letter="";
        }else{
          //run prompt
          final gemini = Gemini.instance;
          gemini.streamGenerateContent(prompt).listen((event) {
            TextToSpeech(event.output.toString());
          }).onDone(() {
            setState(() {
              prompt="";
            });
          });
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

  String prompt="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(onPressed: (){},child: Icon(Icons.mic,color: Colors.black,),),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(prompt),
            )
          ],
        ),
      ),
    );
  }
}
