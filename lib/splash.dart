import 'dart:async';
import 'package:bjp_pdf/register.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => Register(
                      restorationId: "main",
                    ))));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            //  width: MediaQuery.of(context).size.width,
            // decoration: BoxDecoration(
            //     // borderRadius: BorderRadius.circular(20.0),
            //     gradient: LinearGradient(
            //         begin: Alignment.topRight,
            //         end: Alignment.bottomLeft,
            //         colors: [Colors.green, Colors.orange, Colors.white])),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                Image.asset(
                  'images/bjp_logo.png',
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.2,
                ),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                // Text(
                //   'Bharatiya Janata Party',
                //   style: TextStyle(
                //       color: Colors.white,
                //       fontWeight: FontWeight.bold,
                //       fontSize: 30),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
