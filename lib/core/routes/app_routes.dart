import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hostelops_owner/features/auth/presentation/login_screen.dart';
import 'package:hostelops_owner/features/create_pg/cubit/add_pg_cubit.dart';
import 'package:hostelops_owner/features/create_pg/presentation/add_pg_screen.dart';
import 'package:hostelops_owner/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:hostelops_owner/features/dashboard/presentation/dashboard_screen.dart';
import 'package:hostelops_owner/features/payment/presentation/payment_card_list.dart';
import 'package:hostelops_owner/features/pg/presentation/pg_list_screen.dart';

import 'package:hostelops_owner/features/tenant/cubit/tenant_cubit.dart';
import 'package:hostelops_owner/features/tenant/presentation/TenantListScreen.dart';
import 'package:hostelops_owner/features/tenant/presentation/add_tenant_screen.dart';
import 'package:hostelops_owner/features/tenant/presentation/TenantDetailScreen.dart';
import 'package:hostelops_owner/features/tenant/presentation/edit_tenant_screen.dart';

import 'package:hostelops_owner/features/payment/cubit/payment_cubit.dart';
import 'package:hostelops_owner/onbording/screens/onboarding_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const add_pg = '/add_pg';
  static const pg_list = '/pg-list';
  static const onBording = '/on_bording';

  static const tenants_list = '/tenants_list';
  static const tenant_detail = '/tenant_detail';
  static const edit_tenant = '/edit_tenant';
  static const add_tenant = '/add_tenant';
  static const payments = '/payments';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      /// 🔐 LOGIN
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      /// 🎯 ONBOARDING
      case onBording:
        return MaterialPageRoute(builder: (_) => OnboardingScreen());

      /// 👥 TENANT LIST
      case tenants_list:
        final hostelId = settings.arguments as int;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => TenantCubit()..fetchTenants(hostelId),
            child: TenantListScreen(hostelId: hostelId),
          ),
        );

      /// 👤 TENANT DETAIL (SAFE)
 case tenant_detail:
  final args = settings.arguments as Map<String, dynamic>;
  final cubit = args["cubit"] as TenantCubit?;

  return MaterialPageRoute(
    builder: (_) => cubit != null
        ? BlocProvider.value(
            value: cubit, // ✅ reuse existing cubit
            child: TenantDetailScreen(
              tenant: args["tenant"],
            ),
          )
        : BlocProvider(
            create: (_) => TenantCubit(), // ✅ create new if not passed
            child: TenantDetailScreen(
              tenant: args["tenant"],
            ),
          ),
  );
      /// ✏️ EDIT TENANT (SAFE)
     case edit_tenant:
  final args = settings.arguments as Map<String, dynamic>;
  final cubit = args["cubit"] as TenantCubit?;

  return MaterialPageRoute(
    builder: (_) => cubit != null
        ? BlocProvider.value(
            value: cubit,
            child: EditTenantScreen(
              tenant: args["tenant"],
            ),
          )
        : BlocProvider(
            create: (_) => TenantCubit(),
            child: EditTenantScreen(
              tenant: args["tenant"],
            ),
          ),
  );
      /// ➕ ADD TENANT
      case add_tenant:
        final hostelId = settings.arguments as int;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => TenantCubit(),
            child: AddTenantScreen(hostelId: hostelId),
          ),
        );

      /// 💰 PAYMENTS
      case payments:
        final hostelId = settings.arguments as int;

        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => PaymentCubit()..fetchPayments(hostelId),
            child: PaymentListScreen(hostelId: hostelId),
          ),
        );

      /// 🏠 DASHBOARD
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => DashboardCubit(),
            child: const DashboardScreen(),
          ),
        );

      /// 📄 PG LIST
      case pg_list:
        return MaterialPageRoute(
          builder: (_) => const PgListScreen(),
        );

      /// ➕ ADD PG
      case add_pg:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => AddPgCubit(),
            child: const AddPgScreen(),
          ),
        );

      /// ❌ DEFAULT
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("No route found")),
          ),
        );
    }
  }
}