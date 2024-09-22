import 'package:flutter/material.dart';
import 'package:piyush_dutta_innovation/home.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  void process(){
    Future.delayed(Duration(seconds: 2),(){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context){
        return Home();
      }));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    process();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Align(
          alignment: Alignment.center,
          child: Center(
            child: Column(
              children: [
                Image.network("https://s3-alpha-sig.figma.com/img/6b00/8c79/c34906cb8e84aaa0a9e6872b10ffb29b?Expires=1710720000&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=CAAnHsF6No4uhYTPdl7FzlxBaJIoncyzMR8g2-XmxP2DfBWdaKG3EqroPZqJNmaMnJDBXkrfSrS~rWC1jZHxZ-yvZPdXCOX4GSfvOFxB5hsJjs3Af2IJMlrzL~1vRzba24e~fZEGIirQEkDK4JEFWR4QVIu~y0rpwsZPKwpwTFzsA6h7AwpuRjm4t5Fe87cpzDMgvKzkvPkUCtVc5jjjjogzJgZB6W-9EYWT0A8H92acPtOxJ7mjBpU96KYArJ4k5ZrtaD6p4WevgKqyr4r7pzmi-b-erlytmZctrqAPItnMTL3LhWjT5YY8fDolicFNJCXEjHed2Ss9LSYO0ImNKQ__",width: 100,height: 100,),
                SizedBox(height: 15,),
                Text("YUKTA", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 30),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
