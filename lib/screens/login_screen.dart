import 'package:flutter/material.dart';
import 'package:online_clothing_store/models/user_model.dart';
import 'package:online_clothing_store/screens/signup_screen.dart';
import 'package:online_clothing_store/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: const Text(
            "Entrar",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignUpScreen()));
              },
              style: TextButton.styleFrom(
                foregroundColor:
                    Colors.white, // Cor do texto (substituindo textColor)
                // backgroundColor: Colors.blue, // Cor de fundo do botão (opcional)) Colors.white,
              ),
              child: const Text(
                "Criar conta",
                style: TextStyle(fontSize: 15.0),
              ),
            ),
          ],
        ),
        body:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          if (model.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(18.0),
              children: [
                TextFormField(
                  decoration: const InputDecoration(hintText: "E-mail"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text == null || text.isEmpty || !text.contains("@")) {
                      return "E-mail inválido";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18.0),
                TextFormField(
                  decoration: const InputDecoration(hintText: "Senha"),
                  obscureText: true, // Mostra asteriscos ao digitar a senha
                  validator: (text) {
                    if (text == null || text.isEmpty || text.length < 6) {
                      return "E-mail inválido";
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.transparent, // Cor de fundo transparente
                      foregroundColor:
                          Colors.blue, // Cor do texto (pode ser ajustada)
                      shadowColor: Colors.transparent, // Remove a sombra
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.zero, // Remove o raio das bordas
                      ),
                    ),
                    child: const Text(
                      "Esqueci minha senha",
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
                SizedBox(
                  height: 44.0,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {}
                      model.signIn();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, // Cor de fundo do botão
                      foregroundColor: Colors.white, // Cor do texto
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            8.0), // Define o raio das bordas
                      ),
                    ),
                    child: const Text(
                      "Entrar",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ],
            ),
          );
        }));
  }
}
