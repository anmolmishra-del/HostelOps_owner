import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> data = [
    {
      "image": "assets/images/on1.png",
      "title": "Manage Your PG Easily",
      "desc": "Track tenants, rooms and payments in one place",
    },
    {
      "image": "assets/images/on2.png",
      "title": "Track Rent & Payments",
      "desc": "Monitor rent collection and pending dues",
    },
    {
      "image": "assets/images/on3.png",
      "title": "Room & Occupancy",
      "desc": "Manage rooms and bed availability easily",
    },
    {
      "image": "assets/images/on4.png",
      "title": "Reports & Insights",
      "desc": "Get detailed analytics of your PG",
    },
  ];

  void nextPage() {
    if (currentIndex < data.length - 1) {
      controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),

      body: Column(
        children: [

          // 🔝 SKIP BUTTON
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 40, right: 16),
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text("Skip"),
              ),
            ),
          ),

          // 📱 PAGES
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: data.length,
              onPageChanged: (index) {
                setState(() => currentIndex = index);
              },
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // 🖼️ IMAGE
                    Image.asset(
                      data[index]["image"]!,
                      height: 220,
                    ),

                    const SizedBox(height: 30),

                    // 📝 TITLE
                    Text(
                      data[index]["title"]!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 📄 DESCRIPTION
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Text(
                        data[index]["desc"]!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // 🔵 INDICATOR
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              data.length,
              (index) => Container(
                margin: const EdgeInsets.all(4),
                width: currentIndex == index ? 20 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? const Color(0xFFFF8A3D)
                      : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // 🚀 BUTTON
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: nextPage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8A3D),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  currentIndex == data.length - 1
                      ? "Get Started"
                      : "Next",
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}