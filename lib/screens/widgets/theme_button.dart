import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ThemeButton extends StatelessWidget {
  ThemeButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.isDark = false,
  }) : super(key: key);

  void Function()? onPressed;
  final String title;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: _screenHeight * 0.06,
      width: _screenWidth * 0.4,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: isDark ? Colors.deepOrange : Colors.white,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.deepOrange,
          ),
        ),
      ),
    );
  }
}
