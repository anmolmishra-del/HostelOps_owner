import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hostelops_owner/core/localization/app_localizations.dart';
import 'package:hostelops_owner/features/auth/cubit/login_cubit.dart';
import 'package:hostelops_owner/features/auth/state/login_state.dart';
import 'package:hostelops_owner/features/dashboard/cubit/dashboard_cubit.dart';
import 'package:hostelops_owner/features/dashboard/presentation/main_layout.dart';
import 'package:hostelops_owner/features/pg/cubit/pg_list_cubit.dart';
import 'package:hostelops_owner/features/pg/state/pg_list_state.dart';
import 'package:hostelops_owner/features/rooms/presentation/rooms_screen.dart';


import 'package:hostelops_owner/widgets/action_card.dart';
import 'package:hostelops_owner/widgets/money_card.dart';
import 'package:hostelops_owner/widgets/payment_tile.dart';
import 'package:hostelops_owner/widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SelectedPgCubit()),
        BlocProvider(create: (_) => PgListCubit()..fetchPgs()),
      ],

      child: BlocBuilder<SelectedPgCubit, SelectedPgState>(
        builder: (context, selectedPg) {

          return MainLayout(
            showDrawer: false,
            currentIndex: 0,
            isWidget: true,
            appBarWidget: Row(
              children: [
                GestureDetector(
                      onTap: () => _showPgSheet(context),
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
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
                    Spacer(),
                    Icon(Icons.account_circle_outlined)
              ],
            ) ,

            // 🔥 TITLE = BUTTON
            title: "",

            child: Column(
              children: [

             
               

                // 🔥 DASHBOARD CONTENT
                Expanded(
                  child: BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      final user = state.owner;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [

                            Text(
                              "${t.translate("goodMorning")},\n${user?.firstName ?? ""} 🏠",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 20),

                            Row(
                              children: [
                                Expanded(child: StatCard("50", t.translate("totalBeds"), Icons.bed)),
                                const SizedBox(width: 10),
                                Expanded(child: StatCard("42", t.translate("occupied"), Icons.people)),
                                const SizedBox(width: 10),
                                Expanded(child: StatCard("8", t.translate("vacant"), Icons.event_seat)),
                              ],
                            ),

                            const SizedBox(height: 25),

                            Text(
                              t.translate("todaySummary"),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Expanded(child: MoneyCard("₹32,000", t.translate("collected"), true)),
                                const SizedBox(width: 10),
                                Expanded(child: MoneyCard("₹16,000", t.translate("pending"), false)),
                              ],
                            ),

                            const SizedBox(height: 25),

                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              children: [
                                ActionCard(t.translate("tenants"), Icons.people),
                                ActionCard(t.translate("payments"), Icons.payment),
                                ActionCard(t.translate("rooms"), Icons.meeting_room,onTap: (){
                                  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RoomsScreen(hostelId: selectedPg.id??0),
      ),
    );
                                },),
                                ActionCard(t.translate("expenses"), Icons.money),
                                ActionCard(t.translate("notices"), Icons.notifications),
                                ActionCard(t.translate("reports"), Icons.bar_chart),
                              ],
                            ),

                            const SizedBox(height: 25),

                            Text(
                              t.translate("recentCollections"),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 12),

                            const PaymentTile("Ravi Kumar", "Room 101", "₹8,000"),
                            const SizedBox(height: 10),
                            const PaymentTile("Priya Sharma", "Room 202", "₹8,000"),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
void _showPgSheet(BuildContext context) {
  final pgCubit = context.read<PgListCubit>();
  final selectedCubit = context.read<SelectedPgCubit>();

showModalBottomSheet(
  context: context,
  isScrollControlled: true, // 🔥 IMPORTANT
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  ),

  builder: (_) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7, // 🔥 FIX

      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: pgCubit),
          BlocProvider.value(value: selectedCubit),
        ],

        child: BlocBuilder<PgListCubit, PgListState>(
          builder: (context, state) {

            final selected = context.watch<SelectedPgCubit>().state;

            // 🔄 LOADING
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            // ❗ EMPTY CHECK (VERY IMPORTANT)
            if (state.pgs.isEmpty) {
              return const Center(child: Text("No PGs found"));
            }

            return ListView.builder(
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
                    color: isSelected
                        ? Colors.blue
                        : Colors.grey,
                  ),

                  onTap: () {
                    context
                        .read<SelectedPgCubit>()
                        .selectPg(pg.id, pg.name);

                    Navigator.pop(context);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  },

  );
}
}