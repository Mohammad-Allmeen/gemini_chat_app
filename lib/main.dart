import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:gemini_chat/const.dart';
import 'package:image_picker/image_picker.dart';

import 'SpalshScreen.dart';

void main() {
  Gemini.init(
    apiKey: GEMINI_API_KEY,);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
final Gemini gemini = Gemini.instance; // variable that stores gemini instance
  List<ChatMessage> messages = []; // empty list for storing the upcoming messages


// Defining the current user and gemini user
  ChatUser currentUser = ChatUser (id: '0', firstName: 'User');
  ChatUser geminiUser = ChatUser(id: '1',
  firstName: 'Gemini',
    profileImage: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRUHqEyxDd6Wa9oXYfKcoXKMR-8ZyDVXOKL1qBcF_uA2kumDNc9l_VkXENylQ&s" );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       centerTitle: true,
        title: Text("Gemini Chat App"),
      ),

      /*
// Package used from Pub.dev
1. flutter_gemini 2.0.3
//  this is implemented to interact and communicate with gemini api
// the api that we get from gemini ai is free which only allows 60 request per minute

2. image_picker package
- this will allow the feature to pick images from our gallery
*/

      body: _buildUI(),
    );
  }
  //defining the function
  Widget _buildUI()
  {
    return DashChat(
        inputOptions: InputOptions(trailing:
        [IconButton(onPressed: _sendMediaMessage, icon: const Icon(Icons.image))]),
        currentUser: currentUser, onSend: _sendMessage, messages: messages); // this is comming from dash chat package
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages]; //is called spread operator, its functionality is to take the messages list and add in this list// Spread operator to add messages
    });

    try {
      String question = chatMessage.text; // Get the question from user input
      List<Uint8List>? images;
      if(chatMessage.medias?.isNotEmpty?? false)
        {
images = [
  File(chatMessage.medias!.first.url).readAsBytesSync(),];
        }
      gemini.streamGenerateContent(question,images: images,).listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          // Already a response from Gemini, so skip this part
          lastMessage= messages.removeAt(0);
          String response = event.content?.parts
              ?.fold("", (previous, current) => '$previous ${current.text}') ??
              "";
          lastMessage.text+= response;
          setState(() {
            messages= [lastMessage!,...messages];
          });

        } else {
          // Generate the response from Gemini API
          String response = event.content?.parts
              ?.fold("", (previous, current) => '$previous ${current.text}') ??
              ""; // Combine the parts to form the response text

          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );

          setState(() {
            messages = [message, ...messages]; // Update the messages with the new response
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }

void _sendMediaMessage ()async {
    ImagePicker picker = ImagePicker(); // from Image Picker package
    XFile? file = await picker.pickImage(
      source : ImageSource.gallery,
    );
    if (file!=null){
      ChatMessage chatMessage= ChatMessage(user: currentUser,
          createdAt: DateTime.now(),
          text: "Describe this picture",
          medias:  [
            ChatMedia(url: file.path,
              fileName: "",
              type: MediaType.image,)
          ]
      );
    _sendMediaMessage();
    }
}
}


