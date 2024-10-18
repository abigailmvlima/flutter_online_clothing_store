import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? firebaseUser;
  Map<String, dynamic> userData = {};

  bool isLoading = false;

  // ignore: unused_field
  final Logger _logger = Logger();

  static UserModel of(BuildContext context) => ScopedModel.of(context);

  // SignUp - Criação de conta
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

  // Salvando dados do usuário no Firestore
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser?.uid)
          .set(userData);
    } catch (e) {
      _logger.e("Erro ao salvar os dados do usuário: $e");
    }
  }

  // SignIn - Login
  void signIn({
    required String email,
    required String pass,
    required VoidCallback onSuccess,
    required VoidCallback onFail,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      firebaseUser = userCredential.user;

      // Carrega os dados do Firestore se o login for bem-sucedido
      if (firebaseUser != null) {
        DocumentSnapshot docUser = await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser?.uid)
            .get();

        userData = docUser.data() as Map<String, dynamic>;

        onSuccess();
      } else {
        onFail();
      }
    } catch (e) {
      onFail();
    }

    isLoading = false;
    notifyListeners();
  }

  // SignOut - Logout
  void signOut() async {
    isLoading = true;
    notifyListeners();

    await _auth.signOut();

    userData = {};
    firebaseUser = null;

    isLoading = false;
    notifyListeners(); // Notifica a UI sobre a mudança de estado
  }

  // Recuperar senha
  void recoverPass(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Verifica se o usuário está logado
  bool isLoggedIn() {
    return firebaseUser != null;
  }
}
