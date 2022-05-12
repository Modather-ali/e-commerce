import 'package:flutter/material.dart';
import 'auth/get_started.dart';
import 'auth/sign_in_view.dart';
import 'widgets/theme_button.dart';

class LandingView extends StatelessWidget {
  const LandingView({Key? key}) : super(key: key);

  static const routeName = '/landing_view';

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 80),
        height: _screenHeight,
        width: _screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ClipPath(
            //   clipper: ImageClipper(),
            // child: Container(
            //   color: Colors.orange,
            // )
            // Image.asset(
            //   "assets/images/welcome_image.jpg",
            //   height: _screenHeight * 0.75,
            //   width: _screenWidth,
            //   fit: BoxFit.cover,
            // ),
            // ),
            Image.asset(
              "assets/images/landingpage.png",
              height: _screenHeight * 0.4,
              width: _screenWidth,
            ),
            Column(
              children: const [
                Text(
                  "Welcome to Dmazco Fresh!",
                  style: TextStyle(fontSize: 22),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "Order fresh raw chicken \nat your doorstep.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: _screenWidth,
              child: Row(
                mainAxisAlignment:
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? MainAxisAlignment.spaceEvenly
                        : MainAxisAlignment.spaceAround,
                children: [
                  ThemeButton(
                    title: "Sign in",
                    isDark: true,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignInScreen()));
                    },
                  ),
                  ThemeButton(
                    title: "Get Started",
                    isDark: true,
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const GetStarted()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
