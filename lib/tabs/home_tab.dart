import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildBodyBack() => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 211, 118, 130),
                Color.fromARGB(255, 253, 181, 168),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        );

    return Stack(
      children: [
        buildBodyBack(),
        CustomScrollView(
          slivers: <Widget>[
            const SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Novidades",
                  style: TextStyle(color: Colors.white),
                ),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection("home")
                  .orderBy("pos")
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  );
                } else {
                  return SliverToBoxAdapter(
                    child: StaggeredGrid.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 1.0,
                      children: snapshot.data!.docs.map((doc) {
                        final data = doc.data()
                            as Map<String, dynamic>; // Casting para Map
                        final xCount = data["x"] ?? 1; // Acesso seguro
                        final yCount = data["y"] ?? 1;
                        print(123);
                        print(data);
                        return StaggeredGridTile.count(
                          crossAxisCellCount: xCount,
                          mainAxisCellCount: yCount,
                          child: FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: data["image"] ??
                                "", // Certifique-se de que a chave "image" existe
                            fit: BoxFit.cover,
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
