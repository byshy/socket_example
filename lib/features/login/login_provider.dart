import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:socketexample/data/api_repository.dart';
import 'package:socketexample/data/local_repository.dart';
import 'package:socketexample/services/navigation_service.dart';
import 'package:socketexample/services/socket_service.dart';
import 'package:socketexample/utils/global_widgets/error_dialog.dart';
import 'package:socketexample/utils/routing/routes.dart';

import '../../di.dart';

class LoginProvider with ChangeNotifier {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode passwordFocus = FocusNode();

  bool isLoginLoading = false;

  void login() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showErrorDialog(
        context: scaffoldKey.currentState.context,
        title: 'All fields are required',
      );
    } else {
      isLoginLoading = true;
      notifyListeners();
      sl<ApiRepo>().login(data: {
        'email': emailController.text,
        'password': passwordController.text,
      }).then((value) {
        isLoginLoading = false;
        notifyListeners();
        if (value.errorMessage == null) {
          emailController.text = '';
          passwordController.text = '';
          sl<LocalRepo>().setUser(value);
          // TODO: test if this works
          sl<SocketService>().socketIO.connect();
          sl<NavigationService>().navigateToAndRemove(mainScreen);
          refreshToken();
        } else {
          showErrorDialog(
            context: scaffoldKey.currentState.context,
            title: '${value.errorMessage}',
          );
        }
      });
    }
  }
}
