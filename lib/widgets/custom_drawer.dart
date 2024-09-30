import 'package:flutter/material.dart';
import 'package:online_clothing_store/tiles/drawer_tile.dart';

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Olá,",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        child: const Text(
                          "Entre ou cadastre-se >",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onTap: () {},
                      ),
                      Divider(),
                      DrawerTile(Icons.home, "Início", _pageController, 0),
                      DrawerTile(Icons.list, "Produtos", _pageController, 1),
                      DrawerTile(
                          Icons.location_on, "Lojas", _pageController, 2),
                      DrawerTile(Icons.playlist_add_check, "Meus Pedidos",
                          _pageController, 3),
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }
}
