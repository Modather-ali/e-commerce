import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../providers/product_provider.dart';
import '../../services/firebase_database.dart';
import '../widgets/snack_bar.dart';
import 'home.dart';
import 'profile.dart';
import 'search.dart';

class BottomNavView extends StatefulWidget {
  const BottomNavView({Key? key}) : super(key: key);

  static const routeName = '/bottom_nav';

  @override
  State<BottomNavView> createState() => _BottomNavViewState();
}

class _BottomNavViewState extends State<BottomNavView> {
  final FirebaseDatabase _database = FirebaseDatabase();
  int _selectedIndex = 0;
  final List _pages = [
    const HomeView(),
    const SearchScreen(),
    ProfileView(),
  ];
  Map<String, dynamic>? _userData;

  _getUserData() async {
    _userData = await _database.getUserData();
    setState(() {});
  }

  Future _checkPermission() async {
    await Permission.location.request();

    // bool serviceEnabled;
    LocationPermission permission;

    bool _serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!_serviceEnabled) {
      await Permission.location.request();
      ScaffoldMessenger.of(context).showSnackBar(snackBar(
          message: "Please active location service", color: Colors.red));
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Permission.location.request();
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar(
            message: "Please active location service", color: Colors.red));
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar(
          message: "Please active location service", color: Colors.red));
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
  }

  @override
  void initState() {
    _getUserData();
    _checkPermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar:
          Consumer<ProductProvider>(builder: (context, value, child) {
        if (_userData != null) {
          value.userData = _userData!;
        }
        return BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            _bottomNavigationBarItem(
              label: "Products",
              icon: Icons.home_outlined,
              activeIcon: Icons.home_filled,
              isSelected: _selectedIndex == 0,
            ),
            _bottomNavigationBarItem(
              label: "Search",
              icon: Icons.search_outlined,
              activeIcon: Icons.search,
              isSelected: _selectedIndex == 1,
            ),
            _bottomNavigationBarItem(
              label: "Profile",
              icon: Icons.person_outline,
              activeIcon: Icons.person,
              isSelected: _selectedIndex == 2,
            ),
          ],
        );
      }),
    );
  }

  BottomNavigationBarItem _bottomNavigationBarItem({
    required String label,
    required IconData icon,
    required bool isSelected,
    required IconData activeIcon,
  }) {
    return BottomNavigationBarItem(
        icon: Icon(icon), label: label, tooltip: label, activeIcon: Icon(icon));
  }
}
