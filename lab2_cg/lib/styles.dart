import 'package:flutter/material.dart';

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  hintStyle: TextStyle(color: Color(0xFF757575)),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF303F9F), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF303F9F), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

var kButtonStyle = TextButton.styleFrom(
  minimumSize: Size(10, 60),
    backgroundColor: Color(0xFF303F9F),
    textStyle: TextStyle(color: Colors.white),
);

const kTextStyle=TextStyle(
  color: Colors.white,
);

var kFrame=BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(32)),
    border: Border.all(color: Color(0xFF9E9E9E)));

const kSubtitle=TextStyle(
    color:Color(0xFF212121),
    fontWeight: FontWeight.w700,
    fontSize: 20
);

const kButtonText=TextStyle(
    color: Color(0xFF303F9F)
);