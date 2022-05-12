import '../inner_screens/bottom_nav_view.dart';
import 'package:flutter/material.dart';
import '../../screens/auth/new_customer.dart';
import '../../services/firebase_authentication.dart';
import '../../services/firebase_database.dart';
import '../../utils/important_enums.dart';
import '../widgets/snack_bar.dart';
import '../widgets/text_span_button.dart';
import 'sign_in_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/theme_button.dart';

class GetStarted extends StatefulWidget {
  const GetStarted({Key? key}) : super(key: key);

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  final FirebaseDatabase _database = FirebaseDatabase();

  final GoogleAuthentication _googleAuthentication = GoogleAuthentication();

  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    return _isloading
        ? const LoadingView()
        : Scaffold(
            appBar: AppBar(),
            body: Stack(
              children: [
                Positioned(
                  top:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? _screenHeight * 0.35
                          : 0.0,
                  right: _screenWidth * 0.16,
                  left: _screenWidth * 0.16,
                  child: SizedBox(
                    height: _screenHeight * 0.7,
                    width: _screenWidth,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        const Text(
                          "Create Account",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 16),
                        ThemeButton(
                          title: "Continue with Google",
                          onPressed: () async {
                            setState(() {
                              _isloading = true;
                            });
                            GoogleSignInResults _resulte =
                                await _googleAuthentication.signInWithGoogle();
                            setState(() {
                              _isloading = false;
                            });
                            if (_resulte ==
                                GoogleSignInResults.signInCompleted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                snackBar(message: "Registration Completed"),
                              );
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BottomNavView()),
                                ModalRoute.withName(''),
                              );
                            } else {}
                          },
                        ),
                        const SizedBox(height: 16),
                        ThemeButton(
                          title: "Username or email",
                          isDark: true,
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateAccount()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24.0,
                  child: MediaQuery.of(context).orientation ==
                          Orientation.portrait
                      ? TextSpanButton(
                          questionText: "Already have an account? ",
                          buttonText: "Sign in",
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SignInScreen()));
                          },
                        )
                      : const SizedBox(height: 0.0, width: 0.0),
                ),
              ],
            ),
          );
  }
}
