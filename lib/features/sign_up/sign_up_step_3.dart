import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socketexample/services/navigation_service.dart';
import 'package:socketexample/utils/colors.dart';
import 'package:socketexample/utils/global_widgets/custom_flat_button.dart';
import 'package:socketexample/utils/global_widgets/loading_indicator.dart';
import 'package:socketexample/utils/routing/routes.dart';

import '../../di.dart';
import 'sign_up_provider.dart';

class SignUpStep3 extends StatefulWidget {
  @override
  _SignUpStep3State createState() => _SignUpStep3State();
}

class _SignUpStep3State extends State<SignUpStep3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: sl<SignUpProvider>().signUp3Key,
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/wallpaper.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FlatButton(
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    onPressed: () {
                      sl<NavigationService>().navigateToAndRemove(mainScreen);
                    },
                  ),
                ],
              ),
              Spacer(),
              Text(
                'Add a profile picture!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 38,
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<SignUpProvider>(
                    builder: (_, instance, child) {
                      return Material(
                        color: Colors.white,
                        clipBehavior: Clip.hardEdge,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(150)),
                            side: BorderSide(width: 2, color: Colors.white)),
                        child: InkWell(
                          onTap: () => instance.getImage(),
                          child: Container(
                            height: 100,
                            width: 100,
                            child: instance.image == null
                                ? Icon(
                                    Icons.person,
                                    size: 40,
                                  )
                                : Image.file(
                                    File(instance.image.path),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 40),
              CustomFlatButton(
                color: blue34BBB3.withOpacity(0.8),
                child: Consumer<SignUpProvider>(
                  builder: (_, instance, child) {
                    if (instance.isUploadingProfileImage) {
                      return LoadingIndicator(
                        color: Colors.white,
                        size: 20,
                      );
                    }

                    return child;
                  },
                  child: Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                onPressed: () {
                  sl<SignUpProvider>().setProfileImage();
                },
              ),
              FlatButton(
                child: Text(''),
                onPressed: () {},
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
