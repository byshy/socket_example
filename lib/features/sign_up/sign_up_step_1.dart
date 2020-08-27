import 'package:flutter/material.dart';
import 'package:socketexample/features/sign_up/sign_up_provider.dart';
import 'package:socketexample/utils/colors.dart';

import '../../di.dart';

class SignUpStep1 extends StatefulWidget {
  @override
  _SignUpStep1State createState() => _SignUpStep1State();
}

class _SignUpStep1State extends State<SignUpStep1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sl<SignUpProvider>().signUp1Key,
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
              'Create Account',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
              ),
            ),
            SizedBox(height: 40),
            TextField(
              controller: sl<SignUpProvider>().nameController,
              textInputAction: TextInputAction.next,
              style: TextStyle(color: Colors.white),
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(
                  sl<SignUpProvider>().usernameFocus,
                );
              },
              decoration: InputDecoration(
                hintText: 'NAME',
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
              controller: sl<SignUpProvider>().usernameController,
              focusNode: sl<SignUpProvider>().usernameFocus,
              style: TextStyle(color: Colors.white),
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(
                  sl<SignUpProvider>().emailFocus,
                );
              },
              decoration: InputDecoration(
                hintText: 'USERNAME',
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
              controller: sl<SignUpProvider>().emailController,
              focusNode: sl<SignUpProvider>().emailFocus,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors.white),
              textInputAction: TextInputAction.done,
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
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
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  color: Colors.white,
                  clipBehavior: Clip.hardEdge,
                  borderRadius: BorderRadius.all(Radius.circular(150)),
                  child: InkWell(
                    onTap: () {
                      sl<SignUpProvider>().goToPage2();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(150),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              blue4C7C8C,
                              blue34BBB3,
                            ],
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
