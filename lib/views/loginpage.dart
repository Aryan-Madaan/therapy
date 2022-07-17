import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:therapy/views/home_tab_view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isAuthenticated = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  _pushPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomeTabView()));
  }

  _showError() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Something Went wrong')));
  }

  Future<void> signUp() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        UserCredential result = await auth.signInWithCredential(authCredential);
        User? user = result.user;
        if (user != null) {
          setState(() {
            isAuthenticated = true;
          });
        }
      } else {
        _showError();
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Something Went wrong')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Login Page",
              style: TextStyle(
                  color: Colors.amber,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).scaffoldBackgroundColor,
                  onPrimary: Theme.of(context).primaryColor,
                  minimumSize: const Size(200, 50),
                ),
                icon: const Icon(
                  Icons.login_outlined,
                  color: Colors.red,
                ),
                label: const Text(
                  "Sign in with Google",
                  style: TextStyle(fontFamily: 'Century Gothic'),
                ),
                onPressed: () async {
                  await signUp();
                  if (isAuthenticated) {
                    _pushPage();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
