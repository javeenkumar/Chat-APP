import 'package:flutter/material.dart';

Widget ElButton(
    BuildContext context,
    Color colors, {
      String text = 'Button',
      double width = 0.7,
      double height = 50,
      double fontSize = 16,
      FontWeight fweight = FontWeight.normal,
      Color textColor = Colors.black87,
      VoidCallback? onPressed,
      double borderWidth = 0,
      Color borderColor = Colors.transparent,
      bool isloading = false,
    }) {
  return ElevatedButton(
    onPressed: onPressed ?? () {},
    style: ElevatedButton.styleFrom(
      minimumSize: Size(width, height), // responsive width
      backgroundColor: colors,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(width: borderWidth, color: borderColor),
      ),
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fweight,
      ),
    ),
    child: isloading ?Center(child: CircularProgressIndicator(color: Colors.black54,),) : Text(
      text,
      style: TextStyle(color: textColor),
    ),
  );
}
