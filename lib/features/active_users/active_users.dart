import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socketexample/data/local_repository.dart';
import 'package:socketexample/features/active_users/active_users_provider.dart';
import 'package:socketexample/features/chat/private_chat_provider.dart';
import 'package:socketexample/models/active_user.dart';
import 'package:socketexample/services/navigation_service.dart';
import 'package:socketexample/utils/routing/routes.dart';

import '../../di.dart';

class ActiveUsers extends StatefulWidget {
  @override
  _ActiveUsersState createState() => _ActiveUsersState();
}

class _ActiveUsersState extends State<ActiveUsers> {
  String email;

  @override
  void initState() {
    super.initState();
    email = sl<LocalRepo>().getUser().data.email;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 20),
            color: Theme.of(context).colorScheme.primary,
            child: ListTile(
              title: Text(
                'username',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<ActiveUsersProvider>(
              builder: (_, instance, child) {
                return ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: instance.activeUsers.length,
                  itemBuilder: (context, index) {
                    ActiveUser user =
                        instance.activeUsers.values.toList()[index];
                    if (user.email == email) {
                      return SizedBox();
                    }

                    return userItem(
                      user: user,
                    );
                  },
                );
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () {
              sl<LocalRepo>().removeUser();
              sl<NavigationService>().navigateToAndRemove(login);
            },
          ),
        ],
      ),
    );
  }

  Widget userItem({ActiveUser user}) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text('${user.name}'),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          color: user.active ? Colors.green : Colors.red,
        ),
      ),
      onTap: () {
        sl<NavigationService>().navigateTo(privateChat, args: user);
        print('user.id: ${user.id}');
        sl<PrivateChatProvider>().createRoom(to: user.email, toID: user.id);
      },
    );
  }
}
