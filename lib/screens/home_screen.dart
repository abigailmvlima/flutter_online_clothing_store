import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:online_clothing_store/tabs/home_tab.dart';
import 'package:online_clothing_store/tabs/products_tab.dart';
import 'package:online_clothing_store/widgets/cart_button.dart';
import 'package:online_clothing_store/widgets/custom_drawer.dart';
import 'package:logger/logger.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );
  User? _currentUser;
  final Logger _logger = Logger(); // Instância do logger

  @override
  void initState() {
    super.initState();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    // Certifique-se de que o Firebase foi inicializado
    await Firebase.initializeApp();
    _currentUser = _auth.currentUser;
    _logger.i("Usuário logado atualmente: $_currentUser");
    setState(() {});
  }

  Future<User?> _signInWithGoogle() async {
    try {
      _logger.i("Tentando login com Google...");

      // Faz login com o Google

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        _logger.i("Login cancelado pelo usuário");
        return null; // Usuário cancelou o login
      }

      _logger.i(
          "Login com Google bem-sucedido, usuário: ${googleUser.displayName}");

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        _logger.e("Erro: accessToken ou idToken está nulo.");
        return null;
      }

      _logger.i("Access Token: ${googleAuth.accessToken}");
      _logger.i("ID Token: ${googleAuth.idToken}");

      _logger.i(
          "Autenticação do Google obtida. Access Token: ${googleAuth.accessToken}");

      // Usa o token do Google para autenticar no Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Faz o login no Firebase usando o token do Google
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      _logger
          .i("Login com Firebase bem-sucedido, usuário: ${user?.displayName}");

      return user;
    } catch (error) {
      _logger.e("Erro no login com Google: $error");
      return null;
    }
  }

  Future<void> _signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();

    setState(() {
      _currentUser = null;
    });
    _logger.i("Usuário deslogado");
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: const NeverScrollableScrollPhysics(),
      // appBar: AppBar(
      //   title: const Text("Login com Google"),
      // ),
      // body: Center(
      //   child:
      //       _currentUser == null ? _buildSignInButton() : _buildUserDetails(),
      // ),

      children: <Widget>[
        Scaffold(
          body: const HomeTab(),
          drawer: CustomDrawer(_pageController),
          floatingActionButton: const CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 211, 118, 130),
            title: const Text(
              "Produtos",
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
          ),
          drawer: CustomDrawer(_pageController),
          body: const ProductsTab(),
          floatingActionButton: const CartButton(),
        ),
        Container(
          color: Colors.red,
        ),
      ],
    );
  }

  // ignore: unused_element
  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: () async {
        _logger.i("Tentando login...");
        final user = await _signInWithGoogle();
        if (user != null) {
          _logger.i("Login bem-sucedido: ${user.displayName}");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Bem-vindo, ${user.displayName}!")),
            );
          }
          setState(() {
            _currentUser = user;
          });
        } else {
          _logger.w("Falha no login");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Falha no login")),
            );
          }
        }
      },
      child: const Text("Login com Google"),
    );
  }

  // ignore: unused_element
  Widget _buildUserDetails() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_currentUser?.photoURL != null)
          CircleAvatar(
            backgroundImage: NetworkImage(_currentUser!.photoURL!),
            radius: 40,
          ),
        const SizedBox(height: 16),
        Text("Nome: ${_currentUser!.displayName}"),
        Text("Email: ${_currentUser!.email}"),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _signOut,
          child: const Text("Sair"),
        ),
      ],
    );
  }
}
