import 'package:flutter/material.dart';
import 'package:hostelops_owner/core/theme/app_colours.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isEnabled;

  const ActionCard(
    this.title,
    this.icon, {
    super.key,
    this.onTap,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: isEnabled ? 1 : 0.95, // 🔥 slight shrink when disabled
      duration: const Duration(milliseconds: 250),

      child: AnimatedOpacity(
        opacity: isEnabled ? 1 : 0.5,
        duration: const Duration(milliseconds: 250),

        child: Material(
          color: Colors.transparent,

          child: InkWell(
            borderRadius: BorderRadius.circular(14),

            onTap: onTap, 

            child: Ink(
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: isEnabled
                        ? Colors.black12
                        : Colors.transparent,
                    blurRadius: 5,
                  ),
                ],
              ),

              child: Stack(
                alignment: Alignment.center,

                children: [

                  // 🔥 MAIN CONTENT
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        color: isEnabled
                            ? AppColors.primary
                            : Colors.grey,
                        size: 26,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 12,
                          color: isEnabled
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  // 🔒 LOCK ICON
                  if (!isEnabled)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.lock,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}