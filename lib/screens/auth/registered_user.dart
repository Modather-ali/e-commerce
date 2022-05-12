import 'package:flutter/material.dart';
import '../../services/firebase_authentication.dart';
import '../../services/firebase_database.dart';
import '../../utils/important_enums.dart';
import '../inner_screens/bottom_nav_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/snack_bar.dart';
import '/screens/widgets/super_text_field.dart';

import '../widgets/theme_button.dart';
import 'reset_password.dart';

class EmailSignIn extends StatefulWidget {
  const EmailSignIn({Key? key}) : super(key: key);

  @override
  State<EmailSignIn> createState() => _EmailSignInState();
}

class _EmailSignInState extends State<EmailSignIn> {
  bool _hidePassword = true;
  bool _isloading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final EmailAuthentication _authentication = EmailAuthentication();
  final FirebaseDatabase _database = FirebaseDatabase();
  bool _wrongEmailOrPassword = false;
  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    return _isloading
        ? const LoadingView()
        : Scaffold(
            appBar: AppBar(),
            body: Form(
              key: _formKey,
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  SizedBox(height: _screenHeight * 0.2),
                  const Text(
                    "Registered Users",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    "Have an account? Sign in now.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
                  ),
                  SuperTextField(
                    controller: _email,
                    fieldName: "Email",
                    textInputType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "This Field is required!";
                      } else if (!emailRegex.hasMatch(value.toString())) {
                        return "Invalid Email!";
                      } else if (value.endsWith(" ")) {
                        return "Pleas delete the empty space!";
                      } else if (_wrongEmailOrPassword) {
                        return "Wrong email or Password!";
                      }
                      return null;
                    },
                    onChanged: (text) {
                      if (_wrongEmailOrPassword) {
                        setState(() {
                          _wrongEmailOrPassword = false;
                        });
                      }
                    },
                  ),
                  SuperTextField(
                    controller: _password,
                    fieldName: "Password",
                    textInputType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    obscureText: _hidePassword,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "This Field is required!";
                      } else if (_wrongEmailOrPassword) {
                        return "Wrong email or Password!";
                      }
                      return null;
                    },
                    onChanged: (text) {
                      if (_wrongEmailOrPassword) {
                        setState(() {
                          _wrongEmailOrPassword = false;
                        });
                      }
                    },
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                      icon: _hidePassword
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ThemeButton(
                    title: "Sign In",
                    onPressed: () async {
                      setState(() {
                        _isloading = true;
                      });
                      EmailSignInResults _results;
                      // String _userRole;

                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _results = await _authentication.signInWithEmail(
                          _email.text,
                          _password.text,
                        );

                        if (_results == EmailSignInResults.signInCompleted) {
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   snackBar(message: "Sign in successful"),
                          // );
                          // _userRole = await _database.getUserRole(
                          //   userId: FirebaseAuth.instance.currentUser!.uid,
                          // );
                          // if (_userRole == "user") {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const BottomNavView()),
                            ModalRoute.withName(''),
                          );
                          // }
                          //  else {
                          //   Navigator.of(context).pushAndRemoveUntil(
                          //     MaterialPageRoute(
                          //         builder: (context) => AdminDashboard()),
                          //     ModalRoute.withName(''),
                          //   );
                          // }
                        } else if (_results ==
                            EmailSignInResults.emailOrPasswordInvalid) {
                          setState(() {
                            _wrongEmailOrPassword = true;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            snackBar(
                              message: "Error.",
                              color: Colors.red,
                            ),
                          );
                        }
                      } else {}
                      setState(() {
                        _isloading = false;
                      });
                    },
                    isDark: true,
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: "Forgot ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        WidgetSpan(
                          child: InkWell(
                            onTap: () {
                              // TODO: some thing is miss here
                            },
                            child: const Text(
                              "username ",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        ),
                        const TextSpan(
                          text: "or ",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        WidgetSpan(
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const ResetPassword()));
                            },
                            child: const Text(
                              "password",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        ),
                        const TextSpan(
                          text: "?",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: Colors.black,
                          ),
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
