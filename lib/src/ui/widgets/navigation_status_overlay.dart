import 'package:flutter/material.dart';

import '../../models/enums.dart';
import '../../models/navigation_state.dart';


class NavigationStatusOverlay extends StatelessWidget {

  const NavigationStatusOverlay({
    super.key,
    required this.state,
    required this.fadeAnimation,
  });
  final NavigationState state;
  final Animation<double> fadeAnimation;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Loading indicator
        if (state.status == NavigationStatus.recalculating)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ),

        // Off-route warning
        if (state.status == NavigationStatus.offRoute ||
            state.status == NavigationStatus.recalculating)
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.yellow[700],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.black),
                        const SizedBox(width: 8),
                        Text(
                          state.status == NavigationStatus.recalculating
                              ? 'Rerouting...'
                              : 'Off Route Detected',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    if (state.status == NavigationStatus.recalculating)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

        // Error message
        if (state.status == NavigationStatus.error)
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: FadeTransition(
              opacity: fadeAnimation,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red[600],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  state.errorMessage ?? 'Navigation Error',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
