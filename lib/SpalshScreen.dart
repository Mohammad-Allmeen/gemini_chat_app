

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gemini_chat/main.dart';

class SplashScreen extends StatefulWidget
{
  @override
  State<SplashScreen> createState () => _SplashscreenState();
}

class _SplashscreenState extends State<SplashScreen>
{
  @override
  void initState()
  {
    super.initState();
    Timer(Duration(seconds: 3),(){
      Navigator.pushReplacement(context,
      MaterialPageRoute(
          builder: (context)=> const MyHomePage(title: "Gemini Chat App",)),
      );
    }
    );
  }
  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUHqEyxDd6Wa9oXYfKcoXKMR-8ZyDVXOKL1qBcF_uA2kumDNc9l_VkXENylQ&s" ),
              radius: 100,
      ),
      SizedBox(
        height: 12,
      ),
      Text("Gemini Chat App", style: TextStyle(
          fontWeight: FontWeight.bold,
        fontSize: 25,
        color: Colors.lightBlue

      ),),

          ],
        ),
      ),
    );
  }
}