import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'styles.dart';
import 'point.dart';

class CoordField extends StatelessWidget {
  String hintText;
  double val=1;
  TextEditingController controller;
  CoordField({required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: TextField(
        controller: controller,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^-?[0-9]*\.?[0-9]*$')),
        ],
        textAlign: TextAlign.center,
        onChanged: (value) {
          try{
            hintText=hintText.substring(0, hintText.length-val.toString().length);
            if(value!='-')
              val=double.parse(value);
            hintText+=val.toString();
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

