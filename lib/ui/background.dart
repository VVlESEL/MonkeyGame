import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final String imgResource;

  Background({@required this.imgResource});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imgResource),
          fit: BoxFit.fill,
        ),
      ),
      child: Container(
        color: Colors.black.withOpacity(0.30),
      ),
    );
  }
}
