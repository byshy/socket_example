import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socketexample/data/local_repository.dart';
import 'package:socketexample/services/navigation_service.dart';
import 'package:socketexample/services/socket_service.dart';
import 'package:socketexample/utils/colors.dart';
import 'package:socketexample/utils/routing/routes.dart';

import '../../../di.dart';
import '../home_provider.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.only(top: 40, right: 16, left: 16),
      children: [
        Consumer<HomeProvider>(
          builder: (_, instance, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IntrinsicWidth(
                  child: IntrinsicHeight(
                    child: Stack(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          clipBehavior: Clip.hardEdge,
                          child: Material(
                            child: InkWell(
                              onTap: () => instance.getImage(),
                              child: sl<LocalRepo>().getUser()?.data?.image ==
                                      null
                                  ? Icon(
                                      Icons.person,
                                      size: 45,
                                      color: Colors.white,
                                    )
                                  : CachedNetworkImage(
                                      imageUrl:
                                          sl<LocalRepo>().getUser().data.image,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: blue34BBB3,
                            borderRadius: BorderRadius.all(
                              Radius.circular(100),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 15,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.all(
                                Radius.circular(40),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        SizedBox(height: 30),
        Text(
          'name: ${sl<LocalRepo>().getUser().data.name}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'username: ${sl<LocalRepo>().getUser().data.username}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'email: ${sl<LocalRepo>().getUser().data.email}',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 30),
        RaisedButton(
          onPressed: () {
            sl<NavigationService>().navigateToAndRemove(login);
            sl<HomeProvider>().reset();
            sl<LocalRepo>().removeUser();
            sl<SocketService>().socketIO.disconnect();
          },
          child: Text('Log out'),
        ),
//        RaisedButton(
//          onPressed: () {
//            sl<HomeProvider>().setProfileImage();
//          },
//        ),
      ],
    );
  }
}
