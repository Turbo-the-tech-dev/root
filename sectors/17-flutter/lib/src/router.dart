/// =============================================================================
/// GoRouter Configuration — Navigation Matrix
/// =============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/screens.dart';

/// Application routes
abstract class AppRoutes {
  static const String home = '/';
  static const String interview = '/interview';
  static const String category = '/category';
  static const String performance = '/performance';
  static const String settings = '/settings';
}

/// GoRouter provider
final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLoggging: false, // Disable in production
  routes: [
    // Home Screen
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
      routes: [
        // Interview Screen
        GoRoute(
          path: 'interview',
          name: 'interview',
          builder: (context, state) {
            final category = state.uri.queryParameters['category'];
            final questionCount = int.tryParse(
              state.uri.queryParameters['count'] ?? '10',
            ) ?? 10;
            return InterviewScreen(
              category: category,
              questionCount: questionCount,
            );
          },
        ),

        // Category Detail Screen
        GoRoute(
          path: 'category/:id',
          name: 'category-detail',
          builder: (context, state) {
            final categoryId = state.pathParameters['id']!;
            return CategoryDetailScreen(categoryId: categoryId);
          },
        ),
      ],
    ),

    // Performance Screen
    GoRoute(
      path: AppRoutes.performance,
      name: 'performance',
      builder: (context, state) => const PerformanceScreen(),
    ),

    // Settings Screen
    GoRoute(
      path: AppRoutes.settings,
      name: 'settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],

  // Error handling
  errorBuilder: (context, state) => ErrorScreen(
    message: 'Page not found: ${state.uri.path}',
  ),

  // Redirect logic (optional authentication)
  // redirect: (context, state) {
  //   final isLoggedIn = checkAuth();
  //   if (!isLoggedIn && state.uri.path != '/login') {
  //     return '/login';
  //   }
  //   return null;
  // },
);
