import 'package:flutter/material.dart';

class FullImagePage extends StatefulWidget {
  String imageUrl;
  FullImagePage(this.imageUrl);

  @override
  _FullImagePageState createState() => _FullImagePageState();
}

class _FullImagePageState extends State<FullImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width * 1,
          child: Center(
            child: InteractiveViewer(
                clipBehavior: Clip.none,
                panEnabled: true, // Set it to false
                boundaryMargin: EdgeInsets.all(20.0),
                minScale: 0.1,
                maxScale: 8,
                child: Image.network(widget.imageUrl)),
          )),
    );
  }
}
