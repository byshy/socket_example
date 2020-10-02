import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socketexample/features/chat/private_chat_provider.dart';
import 'package:socketexample/models/active_user.dart';
import 'package:socketexample/models/rooms_list.dart';
import 'package:socketexample/services/navigation_service.dart';
import 'package:socketexample/utils/colors.dart';
import 'package:socketexample/utils/global_widgets/loading_indicator.dart';
import 'package:socketexample/utils/routing/routes.dart';

import '../../../di.dart';
import '../home_provider.dart';

class Home extends StatelessWidget {
  final String username;

  const Home({Key key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (_, instance, child) {
        return SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Chat',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.add,
                        size: 20,
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0x66AFAFAF),
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              instance.connected
                  ? ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 170),
                      child: ListView.separated(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(
                          vertical: 30,
                        ),
                        itemCount: instance.activeUsers.length,
                        itemBuilder: (_, index) {
                          ActiveUser _user = instance.activeUsers[index];

                          if (_user.username == username) return SizedBox();

                          return userItem(
                            user: _user,
                          );
                        },
                        separatorBuilder: (_, index) => SizedBox(width: 10),
                      ),
                    )
                  : ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 170),
                      child: Center(
                        child: Text(
                          'Lost connection to server, reconnecting',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
              Expanded(
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(18, 16, 16, 0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Today',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Material(
                              clipBehavior: Clip.hardEdge,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.more_vert),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: instance.chatRoomsLoading
                            ? Center(
                                child: LoadingIndicator(
                                  size: 40,
                                ),
                              )
                            : ListView.builder(
                                physics: BouncingScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: instance.roomsList.rooms.length,
                                itemBuilder: (_, index) => messageItem(
                                  room: instance.roomsList.rooms[index],
                                ),
                              ),
                      ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget userItem({ActiveUser user}) {
    return InkWell(
      onTap: () {
        sl<NavigationService>().navigateTo(privateChat, args: user.username);
        sl<PrivateChatProvider>().createRoom(to: user.username, toID: user.id);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Container(
                  height: 64,
                  width: 64,
                  clipBehavior: Clip.hardEdge,
                  child: user.image == null
                      ? Icon(
                          Icons.person,
                          size: 45,
                          color: Colors.white,
                        )
                      : CachedNetworkImage(
                          imageUrl: user.image,
                          fit: BoxFit.cover,
                        ),
                  decoration: BoxDecoration(
                    color: blue34BBB3,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: user.active ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '${user?.name}',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageItem({Room room}) {
    String name = room.to != username ? room.to : room.from;
    return ListTile(
      onTap: () {
        sl<NavigationService>().navigateTo(privateChat, args: name);
        sl<PrivateChatProvider>().createRoom(to: name, toID: room.roomID);
      },
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(
          room.image ?? '',
        ),
      ),
      title: Text('$name'),
      subtitle: Text('${room?.msg}'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('${room?.date}'),
          SizedBox(height: 10),
//          Visibility(
//            visible: room.isNew,
//            child: Container(
//              height: 12,
//              width: 12,
//              decoration: BoxDecoration(
//                color: Colors.red,
//                borderRadius: BorderRadius.all(
//                  Radius.circular(20),
//                ),
//              ),
//            ),
//          ),
        ],
      ),
    );
  }
}
