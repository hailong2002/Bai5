import 'package:flutter/material.dart';

const textInputField = InputDecoration(
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    borderSide: BorderSide(width: 1, color: Colors.grey)
  ),
  focusedBorder:  OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(width: 1, color: Colors.amber)
  ),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      borderSide: BorderSide(width: 1, color: Colors.red)
  ),
);