import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socketexample/data/local_repository.dart';
import 'package:socketexample/services/navigation_service.dart';
import 'package:socketexample/utils/routing/routes.dart';

import '../../../di.dart';
import '../home_provider.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RaisedButton(
          onPressed: () {
            sl<LocalRepo>().removeUser();
            sl<NavigationService>().navigateToAndRemove(login);
          },
          child: Text('Log out'),
        ),
        Consumer<HomeProvider>(
          builder: (_, instance, child) {
            return InkWell(
              onTap: () => instance.getImage(),
              child: instance.image == null
                  ? Icon(
                      Icons.broken_image,
                      color: Colors.white,
                    )
                  : Image.file(
                      File(instance.image.path),
                      height: 200,
                      width: 200,
                    ),
            );
          },
        ),
        RaisedButton(
          onPressed: () {
            sl<HomeProvider>().setProfileImage();
          },
        ),
      ],
    );
  }
}
