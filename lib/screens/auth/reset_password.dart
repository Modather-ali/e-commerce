import 'package:flutter/material.dart';
import '../../services/firebase_authentication.dart';
import '../../services/firebase_database.dart';
import '../widgets/loading_view.dart';
import '../widgets/snack_bar.dart';
import '../widgets/super_text_field.dart';
import '../widgets/text_span_button.dart';
import '../widgets/theme_button.dart';
import 'get_started.dart';
import 'registered_user.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final bool _hidePassword = true;

  final bool _isloading = false;
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
              child: Stack(
                children: [
                  ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SizedBox(height: _screenHeight * 0.2),
                      const Text(
                        "Reset Password",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SuperTextField(
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ThemeButton(
                          title: "Reset Password",
                          onPressed: () async {
                            bool _passwordReset;
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _passwordReset = await _authentication
                                  .resetPassword(email: _email.text);
                              if (_passwordReset) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    snackBar(message: "We sent you an email"));
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const EmailSignIn()),
                                  ModalRoute.withName(''),
                                );
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar(
                                  message: "Error happened",
                                  color: Colors.red,
                                ));
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(height: _screenHeight * 0.3),
                      TextSpanButton(
                        questionText: "New to TRAI Studio? ",
                        buttonText: "Create an account",
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const GetStarted()));
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
