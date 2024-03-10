import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'styles.dart';
import 'point.dart';

class CoordField extends StatelessWidget {
  String hintText;
  double val=-999;
  CoordField({required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
        ],
        textAlign: TextAlign.center,
        onChanged: (value) {
          try{
            val=double.parse(value);
          }
          catch(e){
            val=-999;
          }
        },
        decoration:
        kTextFieldDecoration.copyWith(hintText: hintText),
      ),
    );
  }
}

