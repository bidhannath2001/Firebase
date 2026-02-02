import 'package:flutter/material.dart';

class MessageScreen extends StatefulWidget {
  String id;
  String msg;
   MessageScreen({
   Key? key,
    required this.id,
     required this.msg
  }):super(key: key);


  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Message Screen'+widget.id),
      ),
      body: Center(
        child: Column(
          children: [
            Text(widget.msg)
          ],
        ),
      ),
    );
  }
}
