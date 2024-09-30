import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  CategoryTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    var data = snapshot.data() as Map<String, dynamic>;

    return ListTile(
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(data["img"]),
      ),
      title: Text(data["title"]),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {},
    );
  }
}
