import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:hostelops_owner/core/constants/auth_storage.dart';
import 'package:hostelops_owner/core/localization/app_localizations.dart';
import 'package:hostelops_owner/core/routes/app_routes.dart';
import 'package:hostelops_owner/core/theme/app_colours.dart';

import 'package:hostelops_owner/features/auth/cubit/login_cubit.dart';
import 'package:hostelops_owner/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:hostelops_owner/features/pg/cubit/pg_list_cubit.dart';

/// 🔔 Background handler (required)
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background message: ${message.notification?.title}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// 🔥 Initialize Firebase
  await Firebase.initializeApp();

  /// 🔔 Background messages
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  /// 🔔 Request permission + get token
  await _initFCM();

  await loadSavedLocale();
  final isLoggedIn = await AuthStorage.isLoggedIn();

  runApp(MyApp(isLoggedIn: isLoggedIn));
}

/// 🔥 FCM Setup
Future<void> _initFCM() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

 
  await messaging.requestPermission();


  String? token = await messaging.getToken();
  print("🔥 FCM TOKEN: $token");

  // 👉 TODO: send this token to your backend
  // await ApiClient.post(ApiUrls.saveFcmToken, body: {"token": token});
}

/// 🔔 Foreground listener (optional but useful)
void setupForegroundNotifications() {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📩 Foreground Notification: ${message.notification?.title}");
  });
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // 🔥 GLOBAL STATE
        BlocProvider(create: (_) => LoginCubit()..loadUser()),
        BlocProvider(create: (_) => SelectedPgCubit()..loadSavedPg()),
        BlocProvider(create: (_) => PgListCubit()..fetchPgs()),
      ],

      child: ValueListenableBuilder<Locale>(
        valueListenable: localeNotifier,
        builder: (context, locale, _) {

          /// 🔔 Setup foreground notifications
          setupForegroundNotifications();

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'HostelOps',

            locale: locale,
            supportedLocales: const [
              Locale('en'),
              Locale('te'),
            ],

            localizationsDelegates: [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: AppColors.background,
              colorScheme: ColorScheme.fromSeed(
                seedColor: AppColors.primary,
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
            ),

            initialRoute:
                isLoggedIn ? AppRoutes.dashboard : AppRoutes.login,

            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}