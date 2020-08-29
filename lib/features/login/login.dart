import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socketexample/features/login/login_provider.dart';
import 'package:socketexample/services/navigation_service.dart';
import 'package:socketexample/utils/colors.dart';
import 'package:socketexample/utils/global_widgets/custom_flat_button.dart';
import 'package:socketexample/utils/global_widgets/loading_indicator.dart';
import 'package:socketexample/utils/routing/routes.dart';

import '../../di.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sl<LoginProvider>().scaffoldKey,
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
              'Welcome Back!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
              ),
            ),
            SizedBox(height: 40),
            TextField(
              controller: sl<LoginProvider>().emailController,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white),
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(
                  sl<LoginProvider>().passwordFocus,
                );
              },
              decoration: InputDecoration(
                hintText: 'EMAIL',
                hintStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Color(0x88FFFFFF),
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
              controller: sl<LoginProvider>().passwordController,
              focusNode: sl<LoginProvider>().passwordFocus,
              style: TextStyle(color: Colors.white),
              textInputAction: TextInputAction.done,
              obscureText: true,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
              decoration: InputDecoration(
                hintText: 'PASSWORD',
                hintStyle: TextStyle(color: Colors.white),
                filled: true,
                fillColor: Color(0x88FFFFFF),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FlatButton(
                  onPressed: () {},
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            CustomFlatButton(
              color: blue34BBB3.withOpacity(0.8),
              child: Consumer<LoginProvider>(
                builder: (_, instance, child) {
                  if (instance.isLoginLoading) {
                    return LoadingIndicator(
                      color: Colors.white,
                      size: 20,
                    );
                  }

                  return child;
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              onPressed: () {
                sl<LoginProvider>().login();
              },
            ),
            SizedBox(height: 10),
            FlatButton(
              onPressed: () {
                sl<NavigationService>().navigateTo(signUpStep1);
              },
              child: RichText(
                text: TextSpan(
                  text: 'Don\' have account? ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  children: [
                    TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
