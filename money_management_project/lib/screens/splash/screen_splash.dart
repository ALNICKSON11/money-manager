import 'package:flutter/material.dart';
import 'package:money_management_project/screens/home/screen_home.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {

  @override
  void initState() {
    goToHomeScreen();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('Money Manager', style: TextStyle(fontSize: 32, color: Colors.lightBlue.shade500, fontWeight: FontWeight.bold),),
              Container(
                padding: const EdgeInsets.all(50),
                child: Image.asset('assets/images/splash_image.png'),
              ),
              const Text('    Money is not everything\nBut everything needs Money', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey),),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> goToHomeScreen() async{
    await Future.delayed(const Duration(seconds: 2));
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx)=>ScreenHome()));
  }
}