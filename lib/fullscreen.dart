import 'package:flutter/material.dart';



class FullScreen extends StatefulWidget {

  String url;
  FullScreen(this.url);

  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),

      body: Container(

        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(widget.url),fit: BoxFit.fitWidth)
        ),
      ),
    );
  }
}

