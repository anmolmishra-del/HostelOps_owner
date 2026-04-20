import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostelops_owner/features/auth/cubit/login_cubit.dart';
import 'package:hostelops_owner/features/auth/presentation/login_screen.dart';
import 'package:hostelops_owner/features/auth/presentation/otp_screen.dart';
import 'package:hostelops_owner/features/create_pg/cubit/add_pg_cubit.dart';
import 'package:hostelops_owner/features/create_pg/presentation/add_pg_screen.dart';
import 'package:hostelops_owner/features/dashboard/presentation/dashboard_screen.dart';
import 'package:hostelops_owner/features/pg/presentation/pg_list_screen.dart';
import 'package:hostelops_owner/features/register/cubit/register_cubit.dart';
import 'package:hostelops_owner/features/register/presentaion/register_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String dashboard = '/dashboard';
  static const String add_pg = '/add_pg';
  static const pg_list = '/pg-list';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => LoginCubit(),
            child: const LoginScreen(),
          ),
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => RegisterCubit(),
            child: const RegisterScreen(),
          ),
        );

      case otp:
        return MaterialPageRoute(builder: (_) => OtpScreen(phone: 'phone'));
      case dashboard:
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case pg_list:
        return MaterialPageRoute(builder: (_) => const PgListScreen());

      case add_pg:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AddPgCubit(),
            child: const AddPgScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text("No route found"))),
        );
    }
  }
}
