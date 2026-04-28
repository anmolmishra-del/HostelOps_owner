import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hostelops_owner/core/localization/app_localizations.dart';
import 'package:hostelops_owner/core/routes/app_routes.dart';
import 'package:hostelops_owner/features/auth/cubit/login_cubit.dart';
import 'package:hostelops_owner/features/auth/state/login_state.dart';
import 'package:hostelops_owner/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:hostelops_owner/features/dashboard/presentation/main_layout.dart';
import 'package:hostelops_owner/features/notices/presentation/notices_page.dart';
import 'package:hostelops_owner/features/pg/cubit/pg_list_cubit.dart';
import 'package:hostelops_owner/features/pg/state/pg_list_state.dart';
import 'package:hostelops_owner/features/report/presentations/reports_screen.dart';
import 'package:hostelops_owner/features/rooms/presentation/RoomsListScreen.dart';
import 'package:hostelops_owner/widgets/ProfilePanel.dart';

import 'package:hostelops_owner/widgets/action_card.dart';
import 'package:hostelops_owner/widgets/app_end_drawer.dart';
import 'package:hostelops_owner/widgets/house_loader.dart';
import 'package:hostelops_owner/widgets/money_card.dart';
import 'package:hostelops_owner/widgets/payment_tile.dart';
import 'package:hostelops_owner/widgets/stat_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isProfileOpen = false;
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return BlocListener<SelectedPgCubit, SelectedPgState>(
      listener: (context, selectedPg) {
        context.read<DashboardCubit>().loadDashboard(hostelId: selectedPg.id);
      },

      child: BlocBuilder<SelectedPgCubit, SelectedPgState>(
        builder: (context, selectedPg) {
          return Stack(
            children: [
              MainLayout(
                //  showDrawer: false,
                currentIndex: 0,
                isWidget: true,

                /// 🔥 APP BAR
                appBarWidget: Row(
                  children: [
                    GestureDetector(
                      onTap: () => _showPgSheet(context),
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              selectedPg.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    /// 🔥 FIXED DRAWER ICON
                    IconButton(
                      icon: const Icon(Icons.account_circle_outlined, size: 28),
                      tooltip: "Profile",
                      onPressed: () {
                        setState(() {
                          isProfileOpen = true;
                        });
                      },
                    ),
                  ],
                ),

                title: "",

                /// 🔥 BODY
                child: Column(
                  children: [
                    Expanded(
                      child: BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          final user = state.owner;

                          return SingleChildScrollView(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// 🔥 GREETING
                                Text(
                                  "${t.translate("goodMorning")},\n${user?.firstName ?? "User"} 🏠",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 20),

                                /// 🔥 STATS
                                BlocBuilder<
                                  DashboardCubit,
                                  Map<String, dynamic>
                                >(
                                  builder: (context, data) {
                                    if (data.isEmpty) {
                                      return const Center(child: HouseLoader());
                                    }

                                    return Row(
                                      children: [
                                        Expanded(
                                          child: StatCard(
                                            "${data["bed_count"] ?? 0}",
                                            t.translate("totalBeds"),
                                            Icons.bed,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: StatCard(
                                            "${data["tenants_count"] ?? 0}",
                                            t.translate("occupied"),
                                            Icons.people,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: StatCard(
                                            "${data["vacant_beds"] ?? 0}",
                                            t.translate("vacant"),
                                            Icons.event_seat,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),

                                const SizedBox(height: 25),

                                /// 🔥 SUMMARY
                                Text(
                                  t.translate("todaySummary"),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                BlocBuilder<
                                  DashboardCubit,
                                  Map<String, dynamic>
                                >(
                                  builder: (context, data) {
                                    if (data.isEmpty) return const SizedBox();

                                    return Row(
                                      children: [
                                        Expanded(
                                          child: MoneyCard(
                                            "₹${data["total_payments"] ?? 0}",
                                            t.translate("collected"),
                                            true,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: MoneyCard(
                                            "₹${data["payment_due"] ?? 0}",
                                            t.translate("pending"),
                                            false,
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                ),

                                const SizedBox(height: 25),

                                /// 🔥 ACTION GRID
                                GridView.count(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  children: [
                                   
                                    ActionCard(
                                      t.translate("tenants"),
                                      Icons.people,
                                      isEnabled: selectedPg.id != null,
                                      onTap: () async {
                                        if (selectedPg.id == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Please select PG first",
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                       final result = await Navigator.pushNamed(
  context,
  AppRoutes.tenants_list,
  arguments: selectedPg.id,
);

if (!context.mounted) return;

if (result == true) {
  context.read<DashboardCubit>().loadDashboard(); // 🔥 REFRESH DASHBOARD
}
                                      },
                                    ),

                                    /// PAYMENTS
                                    ActionCard(
                                      t.translate("payments"),
                                      Icons.payment,
                                      isEnabled: selectedPg.id != null,
                                      onTap: () {
                                        if (selectedPg.id == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Please select PG first",
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        Navigator.pushNamed(
                                          context,
                                          AppRoutes.payments,
                                          arguments: selectedPg.id!,
                                        );
                                      },
                                    ),

                                    ActionCard(
                                      t.translate("rooms"),
                                      Icons.meeting_room,
                                      isEnabled: selectedPg.id != null,
                                      onTap: () async {
                                        if (selectedPg.id == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Please select PG first",
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        final result = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => RoomsListScreen(
                                              hostelId: selectedPg.id ?? 0,
                                            ),
                                          ),
                                        );

                                        if (!context.mounted) return;

                                        if (result == true) {
                                          context
                                              .read<DashboardCubit>()
                                              .loadDashboard(); // 🔥 REFRESH DASHBOARD
                                        }
                                      },
                                    ),

                                    ActionCard(
                                      t.translate("expenses"),
                                      Icons.money,
                                    ),
                                    ActionCard(
                                      t.translate("notices"),
                                      Icons.notifications,
                                      isEnabled: selectedPg.id != null,
                                      onTap: () {
                                        if (selectedPg.id == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Please select PG first",
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                NoticeScreen(), // you can pass pgId later
                                          ),
                                        );
                                      },
                                    ),
                                    ActionCard(
                                      t.translate("reports"),
                                      Icons.bar_chart,
                                      onTap: () {
                                        if (selectedPg.id == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Please select PG first",
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => ReportsScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 25),

                                /// 🔥 RECENT
                                Text(
                                  t.translate("recentCollections"),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                const PaymentTile(
                                  "Ravi Kumar",
                                  "Room 101",
                                  "₹8,000",
                                ),
                                const SizedBox(height: 10),
                                const PaymentTile(
                                  "Priya Sharma",
                                  "Room 202",
                                  "₹8,000",
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if (isProfileOpen)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isProfileOpen = false;
                    });
                  },
                  child: Container(color: Colors.black.withOpacity(0.3)),
                ),

              /// 🔥 SIDE PANEL (YOUR ProfilePanel)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                right: isProfileOpen ? 0 : -300,
                top: 0,
                bottom: 0,
                width: 300,
                child: ProfilePanel(
                  onClose: () {
                    setState(() {
                      isProfileOpen = false;
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 🔥 PG SELECT SHEET (UNCHANGED)
  void _showPgSheet(BuildContext context) {
    final pgCubit = context.read<PgListCubit>();
    final selectedCubit = context.read<SelectedPgCubit>();

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: pgCubit),
              BlocProvider.value(value: selectedCubit),
            ],
            child: BlocBuilder<PgListCubit, PgListState>(
              builder: (context, state) {
                final selected = context.watch<SelectedPgCubit>().state;

                if (state.isLoading) {
                  return const Center(child: HouseLoader());
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Select PG",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, AppRoutes.add_pg);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text("Add PG"),
                          ),
                        ],
                      ),
                    ),

                    const Divider(),

                    ListTile(
                      title: const Text("All PGs"),
                      trailing: selected.id == null
                          ? const Icon(Icons.check_circle, color: Colors.blue)
                          : null,
                      onTap: () {
                        context.read<SelectedPgCubit>().clearPg();
                        Navigator.pop(context);
                      },
                    ),

                    const Divider(),

                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: state.pgs.length,
                        itemBuilder: (context, index) {
                          final pg = state.pgs[index];
                          final isSelected = selected.id == pg.id;

                          return ListTile(
                            title: Text(pg.name),
                            subtitle: Text(pg.city),
                            trailing: Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: isSelected ? Colors.blue : Colors.grey,
                            ),
                            onTap: () {
                              context.read<SelectedPgCubit>().selectPg(
                                pg.id,
                                pg.name,
                              );
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
