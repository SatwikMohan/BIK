import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:piyush_dutta_innovation/braille_map.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
class DialPhone extends StatefulWidget {
  const DialPhone({super.key});

  @override
  State<DialPhone> createState() => _DialPhoneState();
}

class _DialPhoneState extends State<DialPhone> {

  void listening() async{
    String braille_letter="";
    String num="";
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
        num = numBraille[braille_letter]!=null?numBraille[braille_letter].toString():"0";
        if(num!="BackSpace"){
          setState(() {
            phoneNum+=num;
          });
        }else{
          setState(() {
            phoneNum = phoneNum.substring(0,phoneNum.length-1);
          });
        }
        braille_letter="";
      }else{
        //Dial Number
        String number = "+91${phoneNum}";
        await FlutterPhoneDirectCaller.callNumber(number);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Text(phoneNum,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14),)
          ],
        ),
      ),
    );
  }
}
