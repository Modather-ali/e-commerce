import 'package:flutter/material.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.deepOrange,
        fontSize: 21,
      ),
    ),
    textTheme: Theme.of(context).textTheme.apply(
          fontFamily: "BeVietnamPro-Regular",
        ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      elevation: 4,
      primary: Colors.deepOrange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    )),
    cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    )),
    iconTheme: const IconThemeData(color: Colors.black),
    colorScheme: const ColorScheme.light(),
    navigationBarTheme: const NavigationBarThemeData(
      backgroundColor: Colors.deepOrange,
      indicatorColor: Colors.white,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: Colors.black,
        fontFamily: "BeVietnamPro-Regular",
      ),
    ),
  );
}

// ThemeData darkThemeData(BuildContext context) {
//   return ThemeData.dark().copyWith(
//     appBarTheme: AppBarTheme(
//       backgroundColor: Colors.black,
//       elevation: 0.0,
//       iconTheme: IconThemeData(color: Colors.white),
//     ) ,
//     iconTheme: IconThemeData(color: Colors.white),
//     colorScheme: ColorScheme.dark().copyWith(
//     ),
//     bottomNavigationBarTheme: BottomNavigationBarThemeData(
//       backgroundColor: Color(0xFF1D1D35),
//       selectedItemColor: Colors.white70,
//       unselectedItemColor: Color(0xFFF5FCF9).withOpacity(0.32),
//       selectedIconTheme: IconThemeData(color: ),
//       showUnselectedLabels: true,
//     ),
//   );
// }