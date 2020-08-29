import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socketexample/utils/colors.dart';
import 'package:socketexample/utils/global_widgets/custom_flat_button.dart';
import 'package:socketexample/utils/global_widgets/loading_indicator.dart';

import '../../di.dart';
import 'sign_up_provider.dart';

class SignUpStep2 extends StatefulWidget {
  @override
  _SignUpStep2State createState() => _SignUpStep2State();
}

class _SignUpStep2State extends State<SignUpStep2> {
  bool hidePassword = true;
  bool hidePasswordConf = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sl<SignUpProvider>().signUp2Key,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/wallpaper.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Add Password',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
              ),
            ),
            SizedBox(height: 40),
            TextField(
              controller: sl<SignUpProvider>().passwordController,
              obscureText: hidePassword,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: Colors.white),
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(
                  sl<SignUpProvider>().passwordCondFocus,
                );
              },
              decoration: InputDecoration(
                hintText: 'PASSWORD',
                hintStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Color(0x88FFFFFF),
                suffixIcon: IconButton(
                  icon: Icon(
                    hidePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: sl<SignUpProvider>().passwordConfController,
              focusNode: sl<SignUpProvider>().passwordCondFocus,
              obscureText: hidePasswordConf,
              style: TextStyle(color: Colors.white),
              textInputAction: TextInputAction.done,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                hintText: 'CONFIRM PASSWORD',
                hintStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Color(0x88FFFFFF),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                suffixIcon: IconButton(
                  icon: Icon(
                    hidePasswordConf ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      hidePasswordConf = !hidePasswordConf;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            CustomFlatButton(
              color: blue34BBB3.withOpacity(0.8),
              onPressed: () {
                sl<SignUpProvider>().signUp();
              },
              child: Consumer<SignUpProvider>(
                builder: (_, instance, child) {
                  if (instance.isSignUpLoading) {
                    return LoadingIndicator(
                      color: Colors.white,
                      size: 20,
                    );
                  }
                  return Text(
                    'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
