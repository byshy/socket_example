import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socketexample/data/local_repository.dart';
import 'package:socketexample/services/navigation_service.dart';
import 'package:socketexample/utils/routing/routes.dart';

import '../../di.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPage = 0;

  final List<TestUser> users = [
    TestUser(
        name: 'Norhan',
        imageUrl:
            'https://scontent.fgza2-1.fna.fbcdn.net/v/t1.0-1/cp0/p80x80/40143588_2301565873407269_6174368779124867072_n.jpg?_nc_cat=107&_nc_sid=dbb9e7&_nc_ohc=INasWojFi8IAX_43Lcc&_nc_ht=scontent.fgza2-1.fna&oh=269beabf83d74768fbd99b6d869e22a6&oe=5F6B5197'),
    TestUser(
        name: 'Basel',
        imageUrl:
            'https://scontent.fgza2-1.fna.fbcdn.net/v/t1.0-9/16266053_1187679181327221_2725687006967874096_n.jpg?_nc_cat=100&_nc_sid=09cbfe&_nc_ohc=1BFsk4vdk1cAX8X9acl&_nc_ht=scontent.fgza2-1.fna&oh=c55fabb61a0667715d6626a040251fc2&oe=5F6C84D7'),
    TestUser(name: 'test1', imageUrl: ''),
    TestUser(name: 'test2', imageUrl: ''),
    TestUser(name: 'test3', imageUrl: ''),
    TestUser(name: 'test4', imageUrl: ''),
    TestUser(name: 'test4', imageUrl: ''),
    TestUser(name: 'test4', imageUrl: ''),
  ];

  List<Chat> chats;

  @override
  void initState() {
    super.initState();
    chats = List.generate(
      users.length,
      (index) => Chat(
          user: users[index],
          message: 'message #$index',
          isNew: index % 2 == 0,
          time: '2:45 PM'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: currentPage == 3 ? Profile() : scaffoldBodyBuilder(),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget scaffoldBodyBuilder() {
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
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 170),
            child: ListView.separated(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 40.0,
              ),
              itemCount: users.length,
              itemBuilder: (_, index) => userItem(user: users[index]),
              separatorBuilder: (_, index) => SizedBox(width: 10),
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
                            'Toady',
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
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: chats.length,
                      itemBuilder: (_, index) => messageItem(
                        chat: chats[index],
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
  }

  Widget userItem({TestUser user}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: CachedNetworkImageProvider(user.imageUrl ?? ''),
        ),
        SizedBox(height: 10),
        Text(
          '${user.name}',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget messageItem({Chat chat}) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(
          chat.user.imageUrl,
        ),
      ),
      title: Text('${chat.user.name}'),
      subtitle: Text('${chat.message}'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text('${chat.time}'),
          SizedBox(height: 10),
          Visibility(
            visible: chat.isNew,
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: currentPage,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      onTap: (page) {
        setState(() {
          currentPage = page;
        });
      },
      items: [
        BottomNavigationBarItem(
          title: Text('Home'),
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          title: Text('Chat'),
          icon: Icon(Icons.chat),
        ),
        BottomNavigationBarItem(
          title: Text('Files'),
          icon: Icon(Icons.insert_drive_file),
        ),
        BottomNavigationBarItem(
          title: Text('Profile'),
          icon: Icon(Icons.person),
        ),
      ],
    );
  }
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  PickedFile _image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = PickedFile(pickedFile.path);
    });
  }

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
        InkWell(
          onTap: () => getImage(),
          child: _image == null
              ? Icon(
                  Icons.broken_image,
                  color: Colors.white,
                )
              : Image.file(
                  File(_image.path),
                  height: 200,
                  width: 200,
                ),
        ),
      ],
    );
  }
}

class TestUser {
  final String name;
  final String imageUrl;

  TestUser({this.name, this.imageUrl});
}

class Chat {
  final TestUser user;
  final String message;
  final String time;
  final bool isNew;

  Chat({this.user, this.message, this.time, this.isNew});
}
