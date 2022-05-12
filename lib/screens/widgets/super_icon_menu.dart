import 'package:flutter/material.dart';

class SuperIconMenu extends StatelessWidget {
  SuperIconMenu({
    Key? key,
    this.iconMenu,
    this.title,
    this.bgColor,
    this.radius,
    this.fontSize,
    this.onTap,
  }) : super(key: key);

  final double? radius;
  final double? fontSize;
  final IconData? iconMenu;
  final Color? bgColor;
  final String? title;
  void Function()? onTap = () {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: CircleAvatar(
            radius: radius,
            backgroundColor: bgColor,
            child: Icon(
              iconMenu,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            title!,
            style: TextStyle(fontSize: fontSize),
          ),
        ),
      ],
    );
  }
}
