import 'package:flutter/material.dart';
import 'package:hostelops_owner/core/theme/app_colours.dart';
import 'package:hostelops_owner/features/pg/model/pg_model.dart';
import 'package:hostelops_owner/widgets/shimmer_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PgDetailScreen extends StatefulWidget {
  final PgModel pg;

  const PgDetailScreen({super.key, required this.pg});

  @override
  State<PgDetailScreen> createState() => _PgDetailScreenState();
}

class _PgDetailScreenState extends State<PgDetailScreen> {
  int currentIndex = 0;
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();

    Future.delayed(const Duration(seconds: 3), _autoSlide);
  }

  void _autoSlide() {
    final pg = widget.pg;

    final images = (pg.photosUrls.isNotEmpty &&
            pg.photosUrls.first != "string")
        ? pg.photosUrls
        : [
            "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2",
          ];

    if (_controller.hasClients) {
      int next = currentIndex + 1;

      if (next >= images.length) next = 0;

      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );

      Future.delayed(const Duration(seconds: 3), _autoSlide);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pg = widget.pg;

    final images = (pg.photosUrls.isNotEmpty &&
            pg.photosUrls.first != "string")
        ? pg.photosUrls
        : [
            "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2",
          ];

    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Column(
          children: [

            // 🔥 IMAGE SLIDER
            Stack(
              children: [
                SizedBox(
                  height: 260,
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: images.length,
                    onPageChanged: (i) => setState(() => currentIndex = i),
                    itemBuilder: (_, i) {
                      return CachedNetworkImage(
                        imageUrl: images[i],
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            const ShimmerBox(height: 260),
                        errorWidget: (_, __, ___) => Container(
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 40),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // 🌑 GRADIENT
                Container(
                  height: 260,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.4),
                        Colors.transparent
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                // 🔙 BACK
                Positioned(
                  top: 40,
                  left: 10,
                  child: CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                // 🔘 DOTS
                Positioned(
                  bottom: 10,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      images.length,
                      (i) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: currentIndex == i ? 10 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: currentIndex == i
                              ? Colors.white
                              : Colors.white54,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // 🔥 MAIN CARD
            Container(
              transform: Matrix4.translationValues(0, -30, 0),
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black.withOpacity(0.08),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(pg.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),

                  const SizedBox(height: 6),

                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "${pg.address}, ${pg.city}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _tag(pg.category ?? ""),
                      const SizedBox(width: 8),
                      _tag("PG"),
                    ],
                  ),
                ],
              ),
            ),

            // 🔥 STATS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                      child: _statCard(
                          "Rooms", "${pg.rooms.length}", Icons.meeting_room)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _statCard(
                          "Tenants", "${pg.tenants.length}", Icons.people)),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔥 CONTENT
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _sectionTitle("About"),
                  Text(pg.description,
                      style: const TextStyle(color: Colors.grey)),

                  const SizedBox(height: 20),

                  _sectionTitle("Amenities"),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: (pg.facilities ?? []).map<Widget>((f) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: _getFacilityColor(f).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_getFacilityIcon(f),
                                size: 20,
                                color: _getFacilityColor(f)),
                            const SizedBox(width: 8),
                            Text(
                              f,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: _getFacilityColor(f),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  _sectionTitle("Payment"),
                  _infoRow(Icons.qr_code, "UPI", pg.upi),
                  _infoRow(Icons.money,
                      "Cash", pg.isCash ? "Available" : "No"),

                  const SizedBox(height: 20),

                  _sectionTitle("Bank Details"),
                  _infoRow(Icons.account_balance, "Bank", pg.bankName),
                  _infoRow(Icons.credit_card, "A/C", pg.accountNumber),
                  _infoRow(Icons.code, "IFSC", pg.ifsc),
                  _infoRow(Icons.person, "Holder", pg.holderName),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),

      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(12),
      //   child: ElevatedButton(
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: AppColors.primary,
      //       padding: const EdgeInsets.symmetric(vertical: 14),
      //       shape: RoundedRectangleBorder(
      //         borderRadius: BorderRadius.circular(12),
      //       ),
      //     ),
      //     onPressed: () {},
      //     child: const Text("Edit PG"),
      //   ),
      // ),
    );
  }

  // 🔥 HELPERS

  Widget _statCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withOpacity(0.05),
          )
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.primary),
          const SizedBox(height: 6),
          Text(value,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(text, style: TextStyle(color: AppColors.primary)),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title,
          style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    );
  }

  Widget _infoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 10),
          Text("$title: ",
              style: const TextStyle(fontWeight: FontWeight.w500)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  IconData _getFacilityIcon(String name) {
    switch (name.toLowerCase()) {
      case 'wifi':
        return Icons.wifi;
      case 'ac':
        return Icons.ac_unit;
      case 'food':
        return Icons.restaurant;
      case 'parking':
        return Icons.local_parking;
      default:
        return Icons.check_circle;
    }
  }

  Color _getFacilityColor(String name) {
    switch (name.toLowerCase()) {
      case 'wifi':
        return Colors.blue;
      case 'ac':
        return Colors.cyan;
      case 'food':
        return Colors.orange;
      case 'parking':
        return Colors.green;
      default:
        return AppColors.primary;
    }
  }
}