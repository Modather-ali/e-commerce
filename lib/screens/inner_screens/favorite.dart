import 'package:flutter/material.dart';

import '../../services/firebase_database.dart';
import '../widgets/snack_bar.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final FirebaseDatabase _database = FirebaseDatabase();

  var userData;

  List<Map<String, dynamic>?> userFavorite = [];

  _getUserFavorite() async {
    userData = await _database.getUserData();
    userFavorite =
        await _database.getUserFavorite(productsIDs: userData["favorite"]);
    setState(() {});
  }

  @override
  void initState() {
    _getUserFavorite();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your Favorite"),
          centerTitle: true,
        ),
        body: ListView.builder(
          itemCount: userFavorite.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {},
              leading: Image.network(
                userFavorite[index]!["productImage"],
              ),
              title: Text(userFavorite[index]!["productTitle"]),
              subtitle: Text(
                "\$ " +
                    (userFavorite[index]!["units"].values.first * 0.1)
                        .toString(),
                style: const TextStyle(color: Colors.green),
              ),
              trailing: IconButton(
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(snackBar(
                    message: "Removing " +
                        userFavorite[index]!["productTitle"] +
                        " ...",
                    color: Colors.red,
                  ));
                  await _database.updateUserFavorite(
                      productsID: userFavorite[index]!["productId"]);
                  _getUserFavorite();
                },
                icon: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                ),
              ),
            );
          },
        ));
  }
}
