import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: Colors.black,
        child: LoadingAnimationWidget.inkDrop(
          color: Colors.orange,
          size: 50,
        ),
      ),
    );
  }
}
