import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          )),
        );
    return Stack(
      children: [
        buildBodyBack(),
        CustomScrollView(slivers: <Widget>[
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
              )),
          FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection("home")
                .orderBy("pos")
                .get(),
            builder: (context, snapshot) {
              print(123);
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
                print(snapshot.data!.docs.length);
                return SliverToBoxAdapter(
                  child: Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: Container()),
                );
              }
            },
          )
        ]),
      ],
    );
  }
}
