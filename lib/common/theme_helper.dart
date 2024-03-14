import 'package:flutter/material.dart';

class ThemeHelper {
  InputDecoration textInputDecoration(String labelText, String hintText) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: TextStyle(color: Colors.black,fontSize: 16),
      hintStyle: TextStyle(color: Colors.grey),
      fillColor: Colors.white,
      filled: true,
      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.grey.shade400)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: Colors.red, width: 2.0)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100.0),
          borderSide: BorderSide(color: Colors.red, width: 2.0)),
    );
  }

  BoxDecoration inputBoxDecorationShadow() {
    return BoxDecoration(boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.7),
        blurRadius: 20,
        offset: const Offset(0, 5),
      )
    ]);
  }

  BoxDecoration buttonBoxDecoration(BuildContext context, String s, String s1, {Color? color1, Color? color2}) {
    Color c1 = Theme.of(context).primaryColor;
    Color c2 = Theme.of(context).hintColor;

    if (Theme.of(context).hintColor == null) {
      // Handle case where accent color is not defined in ThemeData
      // You can provide a default accent color here
      c2 = Colors.green; // For example, setting it to green
    }

    if (color1 != null) {
      c1 = color1;
    }
    if (color2 != null) {
      c2 = color2;
    }

    return BoxDecoration(
      boxShadow: [
        BoxShadow(color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
      ],
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0.0, 1.0],
        colors: [
          c1,
          c2,
        ],
      ),
      color: Colors.deepPurple.shade300,
      borderRadius: BorderRadius.circular(30),
    );
  }

  ButtonStyle buttonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      minimumSize: MaterialStateProperty.all(Size(50, 50)),
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
      shadowColor: MaterialStateProperty.all(Colors.transparent),
    );
  }

  AlertDialog alertDialog(String title, String content, BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black38)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class LoginFormStyle {}