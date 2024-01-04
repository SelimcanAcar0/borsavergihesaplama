import 'package:borsavergihesaplama/constant/CustomColor.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showIndicator = true;
  bool onaylaDeger=false;

  _onaylaDegerAl() async{
    var shared=await SharedPreferences.getInstance();
    onaylaDeger=shared.getBool("onaylandi")??false;
  }
  @override
  void initState() {
    super.initState();
    _onaylaDegerAl();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(
          context, onaylaDeger ? "/anasayfa" : "/sozlesmeSayfa");
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(color: CustomColor.primary),
        child: const Center(
          child: Column(
            children: [
              SizedBox(
                height: 200,
              ),
              Text(
                "Yabancı Borsa Vergi \n Hesaplama",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 36),
              ),
              SizedBox(
                height: 50,
              ),
              Image(
                image: AssetImage("assets/images/logo.png"),
                width: 200,
                height: 200,
              ),
              SizedBox(
                height: 50,
              ),
              CircularProgressIndicator(
                color: Colors.white,
                backgroundColor: CustomColor.primary,
              )
            ],
          ),
        ),
      ),
    );
  }
}
