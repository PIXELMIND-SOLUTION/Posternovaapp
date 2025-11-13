
import 'package:flutter/material.dart';
import 'package:posternova/models/get_all_plan_model.dart';

class AnimatedPlanList extends StatefulWidget {
  final List<GetAllPlanModel> plans;
  final Function(GetAllPlanModel) onPlanSelected;

  const AnimatedPlanList({
    Key? key,
    required this.plans,
    required this.onPlanSelected,
  }) : super(key: key);

  @override
  State<AnimatedPlanList> createState() => _AnimatedPlanListState();
}

class _AnimatedPlanListState extends State<AnimatedPlanList> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    
    _controllers = List.generate(
      widget.plans.length,
      (index) => AnimationController(
        duration: Duration(milliseconds: 300 + (index * 80)),
        vsync: this,
      ),
    );
    
    _animations = _controllers.map((controller) {
      return CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      );
    }).toList();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (var controller in _controllers) {
        controller.forward();
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Choose Your Plan',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onBackground,
              ),
            ),
          ),
          ...List.generate(widget.plans.length, (index) {
            final plan = widget.plans[index];
            final planStyle = _getPlanStyle(plan.name, theme, isDark);
            final isPopular = plan.name.toUpperCase().contains('GOLD');
            
            return FadeTransition(
              opacity: _animations[index],
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.1),
                  end: Offset.zero,
                ).animate(_animations[index]),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Stack(
                    children: [
                      Card(
                        elevation: isDark ? 2 : 1,
                        shadowColor: planStyle['accentColor'].withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(
                            color: isPopular 
                                ? planStyle['accentColor'].withOpacity(0.3)
                                : theme.colorScheme.outline.withOpacity(0.1),
                            width: isPopular ? 1.5 : 1,
                          ),
                        ),
                        child: InkWell(
                          onTap: () => widget.onPlanSelected(plan),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header Section
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: planStyle['accentColor'].withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        planStyle['icon'],
                                        color: planStyle['accentColor'],
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            plan.name,
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: theme.colorScheme.onSurface,
                                            ),
                                          ),
                                          if (plan.duration!.isNotEmpty)
                                            Text(
                                              plan.duration.toString(),
                                              style: theme.textTheme.bodySmall?.copyWith(
                                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 16),
                                
                                // Pricing Section
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      plan.offerPrice == 0 
                                          ? 'Free' 
                                          : '₹${plan.offerPrice}',
                                      style: theme.textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: planStyle['accentColor'],
                                      ),
                                    ),
                                    if (plan.originalPrice > plan.offerPrice && plan.offerPrice > 0) ...[
                                      const SizedBox(width: 8),
                                      Text(
                                        '₹${plan.originalPrice}',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          decoration: TextDecoration.lineThrough,
                                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                                        ),
                                      ),
                                    ],
                                    const Spacer(),
                                    // if (plan.discountPercentage > 0)
                                    //   Container(
                                    //     padding: const EdgeInsets.symmetric(
                                    //       horizontal: 8,
                                    //       vertical: 4,
                                    //     ),
                                    //     decoration: BoxDecoration(
                                    //       color: Colors.green.withOpacity(0.1),
                                    //       borderRadius: BorderRadius.circular(4),
                                    //     ),
                                    //     child: Text(
                                    //       '${plan.discountPercentage}% OFF',
                                    //       style: theme.textTheme.labelSmall?.copyWith(
                                    //         color: Colors.green,
                                    //         fontWeight: FontWeight.w600,
                                    //       ),
                                    //     ),
                                    //   ),
                                  ],
                                ),
                                
                                if (plan.features.isNotEmpty) ...[
                                  const SizedBox(height: 20),
                                  
                                  // Features Section
                                  Text(
                                    'What\'s included:',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  
                                  // Show features
                                  ...plan.features.take(3).map((feature) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.check,
                                            color: planStyle['accentColor'],
                                            size: 16,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              feature,
                                              style: theme.textTheme.bodyMedium?.copyWith(
                                                color: theme.colorScheme.onSurface.withOpacity(0.8),
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  
                                  if (plan.features.length > 3)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 28),
                                      child: Text(
                                        '+ ${plan.features.length - 3} more features',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: planStyle['accentColor'],
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                ],
                                
                                const SizedBox(height: 20),
                                
                                // Action Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => widget.onPlanSelected(plan),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isPopular 
                                          ? planStyle['accentColor']
                                          : theme.colorScheme.surfaceVariant,
                                      foregroundColor: isPopular
                                          ? Colors.white
                                          : theme.colorScheme.onSurfaceVariant,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(vertical: 14),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      plan.offerPrice == 0 ? 'Start Free' : 'Select Plan',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // Popular Badge
                      if (isPopular)
                        Positioned(
                          top: -1,
                          right: 20,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: planStyle['accentColor'],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Most Popular',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          
          // Footer note
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'All plans include customer support and regular updates. Cancel anytime.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Map<String, dynamic> _getPlanStyle(String planName, ThemeData theme, bool isDark) {
    final name = planName.toUpperCase();
    
    if (name.contains('COPPER')) {
      return {
        'accentColor': const Color(0xFF8B4513),
        'icon': Icons.layers,
      };
    } else if (name.contains('SILVER')) {
      return {
        'accentColor': const Color(0xFF607D8B),
        'icon': Icons.star_border,
      };
    } else if (name.contains('GOLD')) {
      return {
        'accentColor': const Color(0xFFFF8F00),
        'icon': Icons.workspace_premium,
      };
    } else {
      return {
        'accentColor': theme.colorScheme.primary,
        'icon': Icons.verified,
      };
    }
  }
}