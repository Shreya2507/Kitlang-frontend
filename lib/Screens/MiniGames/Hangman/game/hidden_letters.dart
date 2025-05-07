import 'package:flutter/material.dart';

Widget hiddenLetter(String char, bool isVisible) {
  return Container(
    alignment: Alignment.center,
    width: 50,
    height: 50,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color.fromARGB(255, 250, 244, 221)),
    child: Visibility(
        visible: !isVisible,
        child: Text(
          char,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Colors.lightGreen),
        )),
  );
}
