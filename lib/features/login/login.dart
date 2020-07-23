import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socketexample/features/login/login_provider.dart';
import 'package:socketexample/services/navigation_service.dart';
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
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: sl<LoginProvider>().emailController,
            textInputAction: TextInputAction.next,
            onEditingComplete: () {
              FocusScope.of(context)
                  .requestFocus(sl<LoginProvider>().passwordFocus);
            },
            decoration: InputDecoration(
              hintText: 'email',
            ),
          ),
          SizedBox(height: 10),
          TextField(
            controller: sl<LoginProvider>().passwordController,
            focusNode: sl<LoginProvider>().passwordFocus,
            textInputAction: TextInputAction.done,
            onEditingComplete: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            obscureText: true,
            decoration: InputDecoration(
              hintText: 'password',
            ),
          ),
          SizedBox(height: 10),
          RaisedButton(
            child: Consumer<LoginProvider>(
              builder: (_, instance, child) {
                if (instance.isLoginLoading) {
                  return LoadingIndicator();
                }

                return child;
              },
              child: Text('Login'),
            ),
            onPressed: () {
              sl<LoginProvider>().login();
            },
          ),
          SizedBox(height: 10),
          Row(
            children: <Widget>[
              Expanded(
                child: Divider(),
              ),
              SizedBox(width: 20),
              Text(
                'or',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(width: 20),
              Expanded(
                child: Divider(),
              ),
            ],
          ),
          SizedBox(height: 10),
          RaisedButton(
            color: Colors.blue,
            onPressed: () {
              sl<NavigationService>().navigateTo(signUp);
            },
            child: Text(
              'Sign Up',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
