import 'package:flutter/material.dart';
import 'package:hostelops_owner/core/theme/app_colours.dart';

class HouseLoader extends StatefulWidget {
  const HouseLoader({super.key, this.size = 40});

  final double size;

  @override
  State<HouseLoader> createState() => _HouseLoaderState();
}

class _HouseLoaderState extends State<HouseLoader>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _scale = Tween(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Icon(
        Icons.home_rounded,
        size: widget.size,
        color: AppColors.primary,
      ),
    );
  }
}