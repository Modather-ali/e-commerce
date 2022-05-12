import 'package:flutter/material.dart';

import '../../services/firebase_authentication.dart';
import '../../utils/important_enums.dart';
import '../inner_screens/bottom_nav_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/snack_bar.dart';
import '../widgets/super_text_field.dart';
import '../widgets/theme_button.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  bool _hidePassword = true;
  bool _isloading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  final RegExp emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final EmailAuthentication _authentication = EmailAuthentication();
  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
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
                  SizedBox(height: _screenHeight * 0.1),
                  const Text(
                    "New Customers",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                  const Text(
                    "Create an Account",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w200),
                  ),
                  SuperTextField(
                    controller: _email,
                    fieldName: "Email",
                    textInputType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "This Field is required";
                      } else if (!emailRegex.hasMatch(value.toString())) {
                        return "Invalid Email!";
                      } else if (value.endsWith(" ")) {
                        return "Pleas delete the empty space";
                      }
                      return null;
                    },
                  ),
                  SuperTextField(
                    controller: _username,
                    fieldName: "Username",
                    textInputType: TextInputType.name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "This Field is required";
                      }

                      return null;
                    },
                  ),
                  SuperTextField(
                    controller: _phone,
                    fieldName: "Contact",
                    textInputType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "This Field is required";
                      }
                      if (value.length < 6) {
                        return "Invalid Phone number!";
                      }
                      return null;
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
                        return "This Field is required";
                      }
                      if (value.length < 6) {
                        return "Password weak";
                      }
                      return null;
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
                    title: "Create Account",
                    onPressed: () async {
                      setState(() {
                        _isloading = true;
                      });
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        RegisterWithEmailResults _results =
                            await _authentication.registerWithEmail(
                          _email.text,
                          _password.text,
                          _username.text,
                          _phone.text,
                        );
                        if (_results ==
                            RegisterWithEmailResults.registerCompleted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            snackBar(message: "Registration Completed"),
                          );

                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => const BottomNavView()),
                            ModalRoute.withName(''),
                          );
                        } else if (_results ==
                            RegisterWithEmailResults.emailAlreadyPresent) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            snackBar(
                              message:
                                  "The account already exists for that email.",
                              color: Colors.red,
                            ),
                          );
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
                ],
              ),
            ),
          );
  }
}
