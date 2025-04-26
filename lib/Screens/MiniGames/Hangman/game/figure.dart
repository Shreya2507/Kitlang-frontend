import 'package:flutter/material.dart';

Widget figure(String path, bool isVisible) {
  return Container(
    width: 250,
    height: 250,
    child: Visibility(
      visible: isVisible,
      child: Image.asset(path),
    ),
  );
}
