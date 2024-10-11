import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:online_clothing_store/models/cart_model.dart';
import 'package:online_clothing_store/models/user_model.dart';
import 'package:online_clothing_store/screens/home_screen.dart';
import 'package:online_clothing_store/screens/login_screen.dart';
import 'package:online_clothing_store/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicializa o Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(builder: (context, child, model) {
        return ScopedModel<CartModel>(
          model: CartModel(model),
          child: MaterialApp(
            title: 'Flutter Clothing Store',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
              primaryColor: const Color.fromARGB(255, 4, 125, 141),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
            home: HomeScreen(),
          ),
        );
      }),
    );
  }
}
