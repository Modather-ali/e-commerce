import '/providers/product_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_theme.dart';
import 'screens/inner_screens/bottom_nav_view.dart';
import 'screens/landing_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dmazco Fresh',
        theme: lightThemeData(context),
        home: _userRegistration(),
      ),
    );
  }

  Widget _userRegistration() {
    User? user = FirebaseAuth.instance.currentUser;

    String _userRole = "user";

    if (user == null) {
      return const LandingView();
    } else {
      // _userRole = await _database.getUserRole(
      //   userId: FirebaseAuth.instance.currentUser!.uid,
      // );
      // if (_userRole == "user") {
      return const BottomNavView();
      // } else {
      //   return AdminDashboard();
      // }
    }
  }
}
