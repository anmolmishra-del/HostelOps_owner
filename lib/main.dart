import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hostelops_owner/core/constants/auth_storage.dart';

import 'package:hostelops_owner/core/localization/app_localizations.dart';
import 'package:hostelops_owner/core/routes/app_routes.dart';
import 'package:hostelops_owner/core/theme/app_colours.dart';
import 'package:hostelops_owner/features/auth/cubit/login_cubit.dart';
import 'package:hostelops_owner/features/auth/presentation/otp_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await loadSavedLocale();

  final isLoggedIn = await AuthStorage.isLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (_) => LoginCubit()..loadUser())],

      child: ValueListenableBuilder<Locale>(
        valueListenable: localeNotifier,
        builder: (context, locale, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'HostelOps',

            locale: locale,
            supportedLocales: const [Locale('en'), Locale('te')],

            localizationsDelegates: [
              AppLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            theme: ThemeData(
              useMaterial3: true,
              scaffoldBackgroundColor: AppColors.background,
              colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                elevation: 0,
                foregroundColor: AppColors.textPrimary,
              ),
            ),

            // 🔥 DYNAMIC ROUTE
            initialRoute: isLoggedIn ? AppRoutes.dashboard : AppRoutes.login,

            // home: OtpScreen(phone: ""),
            onGenerateRoute: AppRoutes.generateRoute,
          );
        },
      ),
    );
  }
}
