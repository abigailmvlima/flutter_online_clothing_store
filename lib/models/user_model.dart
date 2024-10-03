import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? firebaseUser;
  Map<String, dynamic> userData = {};

  bool isLoading = false;

  void signUp({
    required Map<String, dynamic> userData,
    required String pass,
    required VoidCallback onSucess,
    required VoidCallback onFaill,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      // Criação de usuário com email e senha
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: userData["email"],
        password: pass,
      );

      // Salvando o usuário autenticado
      firebaseUser = userCredential.user;

      // Verifica se o usuário foi criado e salva os dados
      if (firebaseUser != null) {
        await _saveUserData(userData);
        onSucess();
      } else {
        onFaill();
      }
    } catch (e) {
      onFaill();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;

    try {
      // Salvando dados do usuário no Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser?.uid)
          .set(userData);
    } catch (e) {
      print("Erro ao salvar os dados do usuário: $e");
    }
  }

  void signIn() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(Duration(seconds: 3));

    isLoading = false;
    notifyListeners();
  }

  void recoverPass() {}
}
