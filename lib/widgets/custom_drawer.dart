import 'package:flutter/material.dart';
import 'package:online_clothing_store/models/user_model.dart';
import 'package:online_clothing_store/screens/login_screen.dart';
import 'package:online_clothing_store/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  final PageController _pageController;
  CustomDrawer(this._pageController);

  @override
  Widget build(BuildContext context) {
    Widget buildDrawerBack() => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 244, 171, 227),
                Colors.white,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        );

    return Drawer(
      child: Stack(
        children: [
          buildDrawerBack(),
          ListView(
            padding: const EdgeInsets.only(left: 32.0, top: 16.0),
            children: [
              const Positioned(
                top: 8.0,
                left: 0.0,
                child: Text(
                  "Flutter's\nClothing",
                  style: TextStyle(
                    fontSize: 34.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Positioned(
                  left: 0.0,
                  bottom: 0.0,
                  child: ScopedModelDescendant<UserModel>(
                      builder: (context, child, model) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Olá, ${model.isLoading || model.firebaseUser == null ? "" : model.userData["name"] ?? "Visitante"}",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          child: Text(
                            model.firebaseUser == null
                                ? "Entre ou cadastre-se >"
                                : "Sair",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {
                            if (!model.isLoading ||
                                model.firebaseUser == null) {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                            } else {
                              model.signOut();
                            }
                          },
                        ),
                        Divider(),
                        DrawerTile(Icons.home, "Início", _pageController, 0),
                        DrawerTile(Icons.list, "Produtos", _pageController, 1),
                        DrawerTile(
                            Icons.location_on, "Lojas", _pageController, 2),
                        DrawerTile(Icons.playlist_add_check, "Meus Pedidos",
                            _pageController, 3),
                      ],
                    );
                  })),
            ],
          )
        ],
      ),
    );
  }
}
