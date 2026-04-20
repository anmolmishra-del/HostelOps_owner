import 'package:flutter/material.dart';
import 'package:hostelops_owner/core/theme/app_colours.dart';


class OnboardingCard extends StatelessWidget {
  final String title;
  final String desc;
  final List<dynamic>? features;
  final String image;
  final int currentIndex;
  final int length;
  final VoidCallback onNext;

  const OnboardingCard({
    super.key,
    required this.title,
    required this.desc,
    required this.features,
    required this.image,
    required this.currentIndex,
    required this.length,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      // color: AppColors.background,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// 🔝 TEXT TOP
          Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 25,
                  color: Color.fromARGB(255, 103, 58, 183),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: Container(
                  width: 180, // 👈 decrease size
                  height: 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 215, 210, 236),
                        Color.fromARGB(255, 183, 176, 211),
                      ],
                    ),

                    /// 🔥 3D SHADOW
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromARGB(
                          255,
                          208,
                          201,
                          233,
                        ).withOpacity(0.5),
                        blurRadius: 6,
                        offset: Offset(0, 3), // bottom shadow
                      ),
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(0, -1), // top highlight
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 17),
              Text(
                desc,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),

          // const SizedBox(height: 10),
          if (features != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center, // ✅ LEFT ALIGN

              children: List.generate(features!.length, (index) {
                final item = features![index];

                return Padding(
                  padding: const EdgeInsets.only(top: 1, bottom: 14),
                  child: Container(
                    width: double.infinity, // ✅ FULL WIDTH
                    // padding: const EdgeInsets.symmetric(
                    //   // horizontal: 70,
                    //   // vertical: 2,
                    // ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center, // ✅ CENTER HORIZONTALLY
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// ICON
                        Icon(
                          item['icon'],
                          color: item['color'] ?? Colors.purple,
                          size: 28,
                        ),

                        const SizedBox(width: 10),

                        /// TEXT
                        Text(
                          item['text'],
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
          ],

          /// 🖼 IMAGE BELOW TEXT
          Expanded(
            child: Transform.scale(
              scale: 1.3,
              child: Opacity(
                opacity: 0.8, // 👈 0.0 to 1.0
                child: Image.asset(image, fit: BoxFit.contain),
              ),
            ),
          ),
          const SizedBox(height: 10),

          /// 🔵 DOTS
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: currentIndex == index ? 18 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: currentIndex == index
                      ? AppColors.primary
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }),
          ),

          const SizedBox(height: 20),

          /// 🔘 BUTTON
          // if (currentIndex == length - 1) ...[
          // if (currentIndex == 0 || currentIndex == length - 1) ...[
          SizedBox(
            width: double.infinity,
            height: 55,
            child: GestureDetector(
              onTap: onNext,
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF7B5CF1), // light purple
                      Color(0xFF5A3EC8), // dark purple
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),

                  /// 🔥 3D SHADOW
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFF5A3EC8).withOpacity(0.5),
                      blurRadius: 15,
                      offset: const Offset(0, 8), // depth
                    ),
                  ],
                ),

                /// ✨ INNER LIGHT EFFECT (fake 3D highlight)
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    /// top shine
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(30),
                          ),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white.withOpacity(0.25),
                              const Color.fromARGB(0, 231, 226, 226),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ),

                    /// TEXT
                    Text(
                      currentIndex == length - 1 ? "Get Started" : "Next →",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // SizedBox(height: 5),
        ],
        // ],
      ),
    );
  }
}
