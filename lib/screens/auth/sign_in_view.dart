import 'package:flutter/material.dart';
import '../../screens/auth/registered_user.dart';
import '../../services/firebase_authentication.dart';
import '../../services/firebase_database.dart';
import '../../utils/important_enums.dart';
import '../inner_screens/bottom_nav_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/theme_button.dart';
import '../widgets/text_span_button.dart';
import 'get_started.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GoogleAuthentication _googleAuthentication = GoogleAuthentication();

  final FirebaseDatabase _database = FirebaseDatabase();

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
                  right: _screenWidth * 0.18,
                  left: _screenWidth * 0.18,
                  child: SizedBox(
                    height: _screenHeight * 0.7,
                    width: _screenWidth,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        const Text(
                          "Sign In",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "Sign in with social network",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w200),
                        ),
                        const SizedBox(height: 16),
                        ThemeButton(
                          title: "Continue with Google",
                          onPressed: () async {
                            setState(() {
                              _isloading = true;
                            });
                            // String userRole;
                            GoogleSignInResults _results =
                                await _googleAuthentication.signInWithGoogle();

                            if (_results ==
                                GoogleSignInResults.signInCompleted) {
                              // userRole = await _database.getUserRole(
                              //     userId:
                              //         FirebaseAuth.instance.currentUser!.uid);
                              // print(userRole);
                              // if (userRole == "user") {
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const BottomNavView()),
                                ModalRoute.withName(''),
                              );
                              // } else {
                              //   Navigator.of(context).pushAndRemoveUntil(
                              //     MaterialPageRoute(
                              //         builder: (context) => AdminDashboard()),
                              //     ModalRoute.withName(''),
                              //   );
                              // }
                            } else {}
                            setState(() {
                              _isloading = false;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        ThemeButton(
                          title: "Username or email",
                          isDark: true,
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const EmailSignIn()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 24.0,
                  child:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? TextSpanButton(
                              questionText: "New ? ",
                              buttonText: "Create an account",
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const GetStarted()));
                              },
                            )
                          : const SizedBox(height: 0.0, width: 0.0),
                ),
              ],
            ),
          );
  }
}
