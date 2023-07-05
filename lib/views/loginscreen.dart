import 'package:filmfusion/services/auth.dart';
import 'package:filmfusion/utils/consts.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Container(
      color: background_primary,
      height: size.height,
      width: size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: size.height * 0.3,
          ),
          Lottie.asset(
            'assets/AuthDuck.json',
            width: size.width * 0.60,
            frameRate: FrameRate(60),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              width: double.infinity,
              height: 72,
              child: ElevatedButton.icon(
                onPressed: () {
                  final provider =
                      Provider.of<GoogleSignInProvider>(context, listen: false);
                  provider.googleLogin();
                },
                icon: const Icon(
                  FontAwesomeIcons.google,
                  color: Colors.white,
                ),
                label: const Text(
                  'Sign in with Google',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    backgroundColor: const Color(0xFF2A292F)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(28, 0, 28, 24),
            child: const Text(
              'Sign in to access and save your personal movie and show collection on FilmFusion. Start your journey through the world of film and television today!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF423E50)),
            ),
          )
        ],
      ),
    ));
  }
}
