import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socketexample/features/sign_up/sign_up_provider.dart';
import 'package:socketexample/utils/global_widgets/loading_indicator.dart';

import '../../di.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sl<SignUpProvider>().scaffoldKey,
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: sl<SignUpProvider>().nameController,
              textInputAction: TextInputAction.next,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(sl<SignUpProvider>().emailFocus);
              },
              decoration: InputDecoration(hintText: 'name'),
            ),
            TextField(
              controller: sl<SignUpProvider>().emailController,
              focusNode: sl<SignUpProvider>().emailFocus,
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              onEditingComplete: () {
                FocusScope.of(context)
                    .requestFocus(sl<SignUpProvider>().passwordFocus);
              },
              decoration: InputDecoration(hintText: 'email'),
            ),
            TextField(
              controller: sl<SignUpProvider>().passwordController,
              focusNode: sl<SignUpProvider>().passwordFocus,
              textInputAction: TextInputAction.done,
              obscureText: true,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(FocusNode());
              },
              decoration: InputDecoration(hintText: 'password'),
            ),
            Spacer(),
            RaisedButton(
              onPressed: () {
                sl<SignUpProvider>().signUp();
              },
              child: Consumer<SignUpProvider>(
                builder: (_, instance, child) {
                  if (instance.isSignUpLoading) {
                    return LoadingIndicator(color: Colors.blue);
                  }
                  return Text('Sign Up');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
