import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socketexample/data/api_repository.dart';
import 'package:socketexample/data/local_repository.dart';
import 'package:socketexample/services/navigation_service.dart';
import 'package:socketexample/utils/global_widgets/error_dialog.dart';
import 'package:socketexample/utils/global_widgets/snackbar_error_message.dart';
import 'package:socketexample/utils/routing/routes.dart';

import '../../di.dart';

class SignUpProvider with ChangeNotifier {
  GlobalKey<ScaffoldState> signUp1Key = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> signUp2Key = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> signUp3Key = GlobalKey<ScaffoldState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfController = TextEditingController();

  final FocusNode usernameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode passwordCondFocus = FocusNode();

  bool isSignUpLoading = false;

  PickedFile image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    image = PickedFile(pickedFile.path);
    notifyListeners();
  }

  void signUp() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      showErrorDialog(
        context: signUp2Key.currentState.context,
        title: 'All fields are required',
      );
    } else if (passwordController.text != passwordConfController.text) {
      showErrorDialog(
        context: signUp2Key.currentState.context,
        title: 'Passwords don\'t match',
      );
    } else {
      isSignUpLoading = true;
      notifyListeners();
      sl<ApiRepo>().signUp(data: {
        'name': nameController.text,
        'username': usernameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      }).then((value) {
        isSignUpLoading = false;
        notifyListeners();
        if (value != null) {
          nameController.text = '';
          usernameController.text = '';
          emailController.text = '';
          passwordController.text = '';
          passwordConfController.text = '';
          sl<LocalRepo>().setUser(value);
          refreshToken();
          FocusScope.of(signUp2Key.currentState.context).unfocus();
          sl<NavigationService>().navigateTo(signUpStep3);
        } else {
          signUp1Key.currentState.showSnackBar(
            SnackBar(
              content: SnackBarErrorMessage(message: 'Something went wrong'),
            ),
          );
        }
      });
    }
  }

  void goToPage2() {
    FocusScope.of(signUp1Key.currentState.context).unfocus();
    if (nameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        emailController.text.isEmpty) {
      showErrorDialog(
        context: signUp1Key.currentState.context,
        title: 'All fields are required',
      );
    } else {
      sl<NavigationService>().navigateTo(signUpStep2);
    }
  }

  bool isUploadingProfileImage = false;

  void setProfileImage() async {
    isUploadingProfileImage = true;
    notifyListeners();
    print('${image.path}');
    FormData formData = FormData.fromMap({
      'avatar': await MultipartFile.fromFile(
        image.path,
        filename: 'profile_image',
      ),
    });
    sl<ApiRepo>().setProfileImage(data: formData).then((value) {
      isUploadingProfileImage = false;
      notifyListeners();
      sl<NavigationService>().navigateToAndRemove(mainScreen);
    });
  }
}
