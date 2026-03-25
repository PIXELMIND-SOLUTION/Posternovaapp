import 'package:flutter/material.dart';

class PosterCardSkeleton extends StatelessWidget {
  const PosterCardSkeleton();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: const SkeletonBox(width: 110, height: 100, borderRadius: 0),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: SkeletonBox(width: 70, height: 10, borderRadius: 4),
          ),
        ],
      ),
    );
  }
}

class ReelCardSkeleton extends StatelessWidget {
  const ReelCardSkeleton();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 105,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: const SkeletonBox(width: 105, height: 180, borderRadius: 12),
    );
  }
}

class DateSelectorSkeleton extends StatelessWidget {
  const DateSelectorSkeleton();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 7,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: const SkeletonBox(width: 58, height: 68, borderRadius: 10),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SKELETON SHIMMER HELPERS
// ─────────────────────────────────────────────────────────────────────────────

class SkeletonBox extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  const SkeletonBox({
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  State<SkeletonBox> createState() => SkeletonBoxState();
}

class SkeletonBoxState extends State<SkeletonBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: LinearGradient(
            colors: [
              Colors.grey.withOpacity(_anim.value * 0.6),
              Colors.white.withOpacity(_anim.value),
              Colors.grey.withOpacity(_anim.value * 0.6),
            ],
          ),
        ),
        child: Opacity(
          opacity: 0.06,
          child: Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: widget.width * 0.4,
              height: widget.height * 0.4,
              fit: BoxFit.contain,
              color: Colors.black,
              errorBuilder: (_, __, ___) => Icon(
                Icons.edit,
                color: Colors.black,
                size: widget.width * 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BannerSkeleton extends StatelessWidget {
  const BannerSkeleton();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: const SkeletonBox(
          width: double.infinity,
          height: 104,
          borderRadius: 16,
        ),
      ),
    );
  }
}

class StorySkeleton extends StatelessWidget {
  const StorySkeleton();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: 6,
        itemBuilder: (_, __) => Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Column(
            children: [
              const SkeletonBox(width: 56, height: 56, borderRadius: 28),
              const SizedBox(height: 6),
              SkeletonBox(width: 48, height: 10, borderRadius: 4),
            ],
          ),
        ),
      ),
    );
  }
}
