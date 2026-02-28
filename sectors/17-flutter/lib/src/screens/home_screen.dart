/// =============================================================================
/// Home Screen — Main Dashboard
/// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Electrician Interview Prep'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => context.go('/performance'),
            tooltip: 'Performance',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: questions.when(
        data: (questionList) => _buildBody(context, ref, questionList.length),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 16),
              Text('Error loading questions: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(questionsProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startInterview(context, ref),
        icon: const Icon(Icons.play_arrow),
        label: const Text('Start Interview'),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, int questionCount) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Welcome Card
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Electrician Interview Prep',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Practice NEC 2026 questions and ace your next interview',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatChip('Questions', '$questionCount'),
                    const SizedBox(width: 8),
                    _buildStatChip('Categories', '5'),
                    const SizedBox(width: 8),
                    _buildStatChip('NEC', '2023'),
                  ],
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Categories Section
        Text(
          'Categories',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        _buildCategoriesGrid(context),

        const SizedBox(height: 16),

        // Recent Performance
        Text(
          'Your Performance',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        _buildPerformanceCard(context, ref),
      ],
    );
  }

  Widget _buildStatChip(String label, String value) {
    return Chip(
      avatar: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      label: Text(label),
    );
  }

  Widget _buildCategoriesGrid(BuildContext context) {
    final categories = [
      {'name': 'Article 210', 'icon': Icons.bolt, 'count': 45},
      {'name': 'Article 220', 'icon': Icons.calculate, 'count': 32},
      {'name': 'Article 358', 'icon': Icons.tube, 'count': 28},
      {'name': 'Article 110', 'icon': Icons.security, 'count': 40},
      {'name': 'Article 240', 'icon': Icons.shield, 'count': 35},
      {'name': 'Article 250', 'icon': Icons.grounding, 'count': 50},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return Card(
          child: InkWell(
            onTap: () => context.go('/category/${category['name']}'),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(category['icon'] as IconData),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category['name'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '${category['count']} questions',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPerformanceCard(BuildContext context, WidgetRef ref) {
    final metrics = ref.watch(performanceMetricsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMetricColumn('Accuracy', '${metrics.accuracy.toStringAsFixed(1)}%'),
                _buildMetricColumn('Answered', '${metrics.totalQuestionsAnswered}'),
                _buildMetricColumn('Streak', '${metrics.categoryMetrics.values.fold<int>(0, (sum, m) => sum + m.currentStreak)}'),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: metrics.accuracy / 100,
              backgroundColor: Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  void _startInterview(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _InterviewOptionsSheet(),
    );
  }
}

class _InterviewOptionsSheet extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Start Interview',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.go('/interview?count=10');
            },
            child: const Text('Quick Start (10 Questions)'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              context.go('/interview?count=20');
            },
            child: const Text('Standard (20 Questions)'),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              context.go('/interview?count=50');
            },
            child: const Text('Full Exam (50 Questions)'),
          ),
        ],
      ),
    );
  }
}
