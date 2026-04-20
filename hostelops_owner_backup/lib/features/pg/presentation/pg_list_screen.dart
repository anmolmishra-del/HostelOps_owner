import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:hostelops_owner/core/theme/app_colours.dart';
import 'package:hostelops_owner/features/create_pg/cubit/add_pg_cubit.dart';
import 'package:hostelops_owner/features/create_pg/presentation/add_pg_screen.dart';
import 'package:hostelops_owner/features/dashboard/presentation/main_layout.dart';
import 'package:hostelops_owner/features/pg/cubit/pg_list_cubit.dart';
import 'package:hostelops_owner/features/pg/presentation/pg_detail_screen.dart';
import 'package:hostelops_owner/features/pg/state/pg_list_state.dart';
import 'package:hostelops_owner/widgets/house_loader.dart';

class PgListScreen extends StatelessWidget {
  const PgListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PgListCubit()..fetchPgs(),

      child: MainLayout(
        showDrawer: false,
        title: "My PGs",
        currentIndex: 1,

        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => AddPgCubit(),
                  child: const AddPgScreen(),
                ),
              ),
            ).then((_) {
              context.read<PgListCubit>().fetchPgs();
            });
          },
          child: const Icon(Icons.add),
        ),

        child: BlocBuilder<PgListCubit, PgListState>(
          builder: (context, state) {
            // 🔄 LOADING
            if (state.isLoading) {
              return const Center(child: HouseLoader(size: 50));
            }

            // ❌ ERROR
            if (state.error != null) {
              return Center(child: Text(state.error!));
            }

            // 📭 EMPTY
            if (state.pgs.isEmpty) {
              return const Center(child: Text("No PGs found"));
            }

            // ✅ LIST
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.pgs.length,
              itemBuilder: (context, index) {
                final pg = state.pgs[index];

                final image =
                    (pg.photosUrls.isNotEmpty &&
                        pg.photosUrls.first != "string")
                    ? pg.photosUrls.first
                    : null;

                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PgDetailScreen(pg: pg)),
                    );
                  },

                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6,
                          color: Colors.black.withOpacity(0.05),
                        ),
                      ],
                    ),

                    child: Row(
                      children: [
                        // 🖼 IMAGE
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: SizedBox(
                            height: 80,
                            width: 80,
                            child: image != null
                                ? Image.network(
                                    image,
                                    fit: BoxFit.cover,
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;

                                      return Container(
                                        color: Colors.grey.shade200,
                                        child: const Center(
                                          child: HouseLoader(size: 25),
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.image, size: 30),
                                  ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // 📊 CONTENT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🏠 NAME + STATUS
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      pg.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),

                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      "Active",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 4),

                              // 📍 LOCATION
                              Text(
                                "${pg.city}",
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),

                              const SizedBox(height: 6),

                              // 📊 STATS
                              Row(
                                children: [
                                  _smallInfo(
                                    Icons.meeting_room,
                                    "${pg.rooms.length}",
                                  ),
                                  const SizedBox(width: 10),
                                  _smallInfo(
                                    Icons.people,
                                    "${pg.tenants.length}",
                                  ),
                                  const SizedBox(width: 10),
                                  _smallInfo(Icons.currency_rupee, "12K"),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const Icon(Icons.chevron_right, size: 18),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // 🔥 SMALL INFO
  Widget _smallInfo(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey),
        const SizedBox(width: 3),
        Text(
          value,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
