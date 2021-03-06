import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socketexample/features/login/login_provider.dart';
import 'package:socketexample/services/socket_service.dart';

import 'data/api_repository.dart';
import 'data/local_repository.dart';
import 'features/chat/private_chat_provider.dart';
import 'features/home/home_provider.dart';
import 'features/sign_up/sign_up_provider.dart';
import 'services/navigation_service.dart';

/// sl: service locator
final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<LocalRepo>(
    () => LocalRepo(
      sharedPreferences: sl(),
    ),
  );

  sl.registerLazySingleton<ApiRepo>(
    () => ApiRepo(
      client: sl(),
    ),
  );

  sl.registerLazySingleton<SocketService>(
    () => SocketService(
      socketIO: sl(),
    ),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  Dio client = Dio(
    BaseOptions(
      baseUrl: 'https://nour-chat.herokuapp.com/',
      contentType: 'application/json',
    ),
  );
  sl.registerLazySingleton<Dio>(() => client);

  SocketIO socketIO = SocketIOManager().createSocketIO(
    'https://nour-chat.herokuapp.com',
    '/admin',
    socketStatusCallback: (dynamic data) {
      print("Socket status: " + data);
      String token = sl<LocalRepo>().getFirebaseToken();
      print('token from di: $token');
      if (data == 'connect') {
        sl<HomeProvider>().setConnectionStatus(isConnected: true);
        sl<SocketService>().socketIO.sendMessage(
              'data',
              json.encode({
                'name': sl<LocalRepo>().getUser().data.name,
                'username': sl<LocalRepo>().getUser().data.username,
                'token': token,
              }),
            );
      } else if (data == 'reconnecting') {
        sl<HomeProvider>().setConnectionStatus(isConnected: false);
      } else if (data == 'connect_error') {
        sl<HomeProvider>().setConnectionStatus(isConnected: false);
      } else if (data == 'reconnect_error') {
        sl<HomeProvider>().setConnectionStatus(isConnected: false);
      }
    },
  );

  socketIO.init();
  socketIO.connect();
  sl.registerLazySingleton<SocketIO>(() => socketIO);

  sl.registerLazySingleton(() => LoginProvider());
//  sl.registerLazySingleton(() => GroupChatProvider());
  sl.registerLazySingleton(() => PrivateChatProvider());
  sl.registerLazySingleton(() => SignUpProvider());
//  sl.registerLazySingleton(() => ActiveUsersProvider());
  sl.registerLazySingleton(() => HomeProvider());

  sl.registerLazySingleton(() => NavigationService());

  refreshToken();
}

void refreshToken() {
  final String token = sl<LocalRepo>().getUser()?.token;
  sl<ApiRepo>().client.options.headers = {'x-auth-token': token};
  print('token: $token');
}
