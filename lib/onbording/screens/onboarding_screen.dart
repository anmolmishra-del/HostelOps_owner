import 'package:flutter/material.dart';
import 'package:hostelops_owner/core/constants/app_images_string.dart';
import 'package:hostelops_owner/widgets/onboarding_card.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, dynamic>> pages = [
    {
      "title": "Find Your\nPerfect PG Stay",
      "desc": "Comfortable verified and\naffordable PGs near you",
      "image": AppImages.image1,
    },
    {
      "title": "Explore PGs\nNear By You",
      "features": [
        {
          "icon": Icons.location_on,
          "text": "Find Nearby PGs",
          'color': Colors.red,
        },
        {
          "icon": Icons.attach_money,
          "text": "Filter by Budget",
          'color': const Color.fromARGB(255, 247, 166, 45),
        },
        {
          "icon": Icons.bed,
          "text": "Compare Rooms",
          'color': Colors.deepPurple,
        },
      ],
      "image": AppImages.image2,
    },
    {
      "title": "Verified & Trusted\nListings",
      "features": [
        {
          "icon": Icons.verified,
          "text": "Verified PG Owners",
          'color': Colors.green,
        },
        {"icon": Icons.photo, "text": "Real Room Photos"},
        {
          "icon": Icons.star,
          "text": "Reviews & Ratings",
          'color': const Color.fromARGB(255, 247, 166, 45),
        },
        {
          "icon": Icons.currency_rupee,
          "text": "Transparent Pricing",
          'color': Colors.green,
        },
      ],
      "image": AppImages.image4,
    },
    {
      "title": "Connect Instantly\nwith PG Owners",
      "features": [
        {"icon": Icons.call, "text": "Call or Chat Easily"},
        {
          "icon": Icons.home,
          "text": "Book Visit Instantly",
          'color': Colors.blue,
        },
        {
          "icon": Icons.flash_on,
          "text": "No Broker Charges",
          'color': const Color.fromARGB(255, 247, 166, 45),
        },
      ],
      "image": AppImages.image5,
    },
  ];

  void nextPage() {
    if (currentIndex < pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      debugPrint("Go to Home Screen");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// 🖼 BACKGROUND IMAGE
          Positioned.fill(
            child: Image.asset(AppImages.image3, fit: BoxFit.cover),
          ),

          /// 📱 PAGE VIEW CONTENT
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() => currentIndex = index);
            },
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return OnboardingCard(
                title: pages[index]["title"]!,
                desc: pages[index]["desc"] ?? "",
                features: pages[index]["features"],
                image: pages[index]["image"]!,
                currentIndex: currentIndex,
                length: pages.length,
                onNext: nextPage,
              );
            },
          ),
        ],
      ),
    );
  }
}
