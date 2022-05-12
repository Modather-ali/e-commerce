import 'package:dmazcofresh/screens/landing_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/firebase_authentication.dart';

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final GoogleAuthentication _googleAuthentication = GoogleAuthentication();

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              MediaQuery.of(context).orientation == Orientation.landscape
                  ? const SizedBox()
                  : Container(
                      height: 100,
                      color: Colors.deepOrange,
                    ),
              Container(
                height:
                    MediaQuery.of(context).orientation == Orientation.landscape
                        ? _screenHeight * 0.5
                        : _screenHeight * 0.65,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 250,
                          height: 80,
                          padding: const EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "userName",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text("userEmail"),
                                ],
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.edit,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    listTile(icon: Icons.shop_outlined, title: "Orders"),
                    listTile(
                        icon: Icons.location_on_outlined,
                        title: "Delivery Address"),
                    listTile(
                        icon: Icons.person_outline, title: "Refer a friend"),
                    listTile(icon: Icons.add_chart, title: "About"),
                    listTile(
                        onTap: () async {
                          await _googleAuthentication.logOut();
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const LandingView()));
                        },
                        icon: Icons.exit_to_app_outlined,
                        title: "Log Out"),
                  ],
                ),
              )
            ],
          ),
          MediaQuery.of(context).orientation == Orientation.landscape
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(top: 40, left: 30),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: const AssetImage(
                        "assets/images/dmazco-logo.png",
                      ),
                      radius: 45,
                    ),
                  ),
                )
        ],
      ),
    );
  }

  Widget listTile(
      {required IconData icon, required String title, void Function()? onTap}) {
    return Column(
      children: [
        const Divider(
          height: 1,
        ),
        ListTile(
          onTap: onTap,
          leading: Icon(icon),
          title: Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
          ),
          trailing: const Icon(Icons.arrow_forward_ios),
        )
      ],
    );
  }
}
