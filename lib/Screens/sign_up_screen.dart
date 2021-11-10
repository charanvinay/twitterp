import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:twitterp/Provider/google_sign_in.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: Colors.black,
            minimumSize: Size(double.infinity, 50),
          ),
          onPressed: () {
            Provider.of<GoogleSignInProvider>(context, listen: false)
                .googleLogin();
          },
          icon: FaIcon(FontAwesomeIcons.google, color: Colors.red),
          label: Text("Sign in with Google"),
        ),
      ),
    );
  }
}
