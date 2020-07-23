import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socketexample/data/api_repository.dart';
import 'package:socketexample/data/local_repository.dart';
import 'package:socketexample/services/navigation_service.dart';
import 'package:socketexample/utils/global_widgets/snackbar_error_message.dart';
import 'package:socketexample/utils/routing/routes.dart';

import '../../di.dart';

class SignUpProvider with ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();

  bool isSignUpLoading = false;

  void signUp() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: SnackBarErrorMessage(message: 'All fields are required'),
        ),
      );
    } else {
      print('name: ${emailController.text}');
      isSignUpLoading = true;
      notifyListeners();
      sl<ApiRepo>().signUp(data: {
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      }).then((value) {
        isSignUpLoading = false;
        notifyListeners();
        if (value != null) {
          sl<LocalRepo>().setUser(value);
          sl<NavigationService>().navigateToAndRemove(groupChat);
          refreshToken();
        } else {
          scaffoldKey.currentState.showSnackBar(
            SnackBar(
              content: SnackBarErrorMessage(message: 'Something went wrong'),
            ),
          );
        }
      });
//      sl<LocalRepo>().setName(name: emailController.text);
//      isLoginLoading = true;
//      notifyListeners();
//      sl<SocketService>().socketIO.sendMessage(
//            'data',
//            json.encode({'name': emailController.text}),
//          );
    }
  }
}
