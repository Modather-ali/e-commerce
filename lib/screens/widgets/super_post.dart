import 'package:flutter/material.dart';
class SuperPost extends StatelessWidget {
  const SuperPost({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {},
      child: Card(
        elevation: 8,
        child: ClipPath(
          clipper: ShapeBorderClipper(shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16))),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1/1,
                child: Container(
                  width: _screenWidth * 0.5,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset('assets/images/trai_logo_color.png'),
                ),
                title: Text('Post Title', style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text('username'),
                trailing: OutlinedButton(onPressed: (){}, child: const Text(' Download'),)
              ),
            ],
          ),
        ),
      ),
    );
  }
}
