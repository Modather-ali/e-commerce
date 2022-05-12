import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextSpanButton extends StatelessWidget {
  TextSpanButton(
      {Key? key,
      required this.questionText,
      required this.buttonText,
      required this.onTap})
      : super(key: key);
  final String questionText;
  final String buttonText;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 60.0,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xFFEEEEEE),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: questionText,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            WidgetSpan(
              child: InkWell(
                onTap: onTap,
                child: Text(
                  buttonText,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.indigo,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
