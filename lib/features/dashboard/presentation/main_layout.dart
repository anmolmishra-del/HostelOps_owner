import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostelops_owner/core/routes/app_routes.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:hostelops_owner/core/constants/auth_storage.dart';
import 'package:hostelops_owner/core/theme/app_colours.dart';
import 'package:hostelops_owner/features/auth/cubit/login_cubit.dart';
import 'package:hostelops_owner/features/auth/state/login_state.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final Widget ?appBarWidget;
  final String title;
  final bool isWidget;
  final Widget? floatingActionButton;
  final bool showDrawer;
  final int currentIndex; // 🔥 IMPORTANT

  const MainLayout({
    super.key,
    required this.child,
    required this.title,
    this.floatingActionButton,
    this.showDrawer = false,
    this.isWidget=false,
    required this.currentIndex,
     this.appBarWidget,
  });

  void _onTabChange(BuildContext context, int index) {
    if (currentIndex == index) return;

    if (index == 0) {
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    } else if (index == 1) {
      Navigator.pushReplacementNamed(context, AppRoutes.pg_list);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      

    
      floatingActionButton: GestureDetector(
        onTap: () => _showQr(context),
        child: Container(
          height: 65,
          width: 65,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.7)
              ],
            ),
            boxShadow: [
              BoxShadow(
                blurRadius: 15,
                color: AppColors.primary.withOpacity(0.4),
              )
            ],
          ),
          child: const Icon(Icons.qr_code_scanner, color: Colors.white),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 🔥 GLASS NAV BAR
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  _buildNavItem(
                    context,
                    icon: Icons.dashboard_rounded,
                    label: "Dashboard",
                    index: 0,
                  ),

                  const SizedBox(width: 40),

                  _buildNavItem(
                    context,
                    icon: Icons.home_work_rounded,
                    label: "PGs",
                    index: 1,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

      

      drawer: showDrawer
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      final user = state.owner;

                      return UserAccountsDrawerHeader(
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                        ),
                        accountName: Text(
                          user != null
                              ? "${user.firstName} ${user.lastName}"
                              : "Loading...",
                        ),
                        accountEmail: Text(user?.email ?? ""),
                      );
                    },
                  ),

                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text("Language"),
                    onTap: () => Navigator.pop(context),
                  ),

                  const Divider(),

                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text("Logout"),
                    onTap: () async {
                      await AuthStorage.logout();
                      context.read<LoginCubit>().emit(LoginState());
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            )
          : null,

  
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: isWidget?appBarWidget:Text(title),
        leading: showDrawer
            ? Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () =>
                      Scaffold.of(context).openDrawer(),
                ),
              )
           :null
      ),

      body: child,
    );
  }

Widget _buildNavItem(
  BuildContext context, {
  required IconData icon,
  required String label,
  required int index,
}) {
  final isSelected = currentIndex == index;

  return GestureDetector(
    onTap: () => _onTabChange(context, index),

    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),

        // 🍎 iOS subtle highlight
        color: isSelected
            ? AppColors.primary.withOpacity(0.12)
            : Colors.transparent,
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [

          // 🍎 ICON
          AnimatedScale(
            scale: isSelected ? 1.1 : 1,
            duration: const Duration(milliseconds: 250),
            child: Icon(
              icon,
              size: 22,
              color: isSelected
                  ? AppColors.primary
                  : Colors.grey.shade500,
            ),
          ),

          // 🍎 LABEL (smooth appear)
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            child: isSelected
                ? Row(
                    children: [
                      const SizedBox(width: 6),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
          ),
        ],
      ),
    ),
  );
}

  // 🔥 QR POPUP
  void _showQr(BuildContext context) {
    showModalBottomSheet(
      
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children:  [
              Text(
                "Scan / Share QR",
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              QrImageView(
                data: "HostelOps-PG-Owner",
                size: 200,
              ),
            ],
          ),
        );
      },
    );
  }
}