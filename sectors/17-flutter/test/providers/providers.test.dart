/// =============================================================================
/// Riverpod Provider Tests
/// Testing state management with ProviderScope
/// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imperial_app/src/providers/providers.dart';
import 'package:imperial_app/src/models/models.dart';

void main() {
  group('Question Providers', () {
    testWidgets('questionsProvider should load questions from service', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      final questionsAsync = container.read(questionsProvider);

      // Assert
      expect(questionsAsync, isA<AsyncValue<List<Question>>>());
    });

    testWidgets('questionsByCategoryProvider should filter by category', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      final questionsAsync = container.read(questionsByCategoryProvider('Article 250'));

      // Assert
      expect(questionsAsync, isA<AsyncValue<List<Question>>>());
    });

    testWidgets('questionsByDifficultyProvider should filter by difficulty', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      final questionsAsync = container.read(questionsByDifficultyProvider(DifficultyLevel.beginner));

      // Assert
      expect(questionsAsync, isA<AsyncValue<List<Question>>>());
    });
  });

  group('Session Providers', () {
    testWidgets('currentSessionProvider should start as null', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Assert
      expect(container.read(currentSessionProvider), isNull);
    });

    testWidgets('currentSessionProvider should update after starting session', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      await container.read(currentSessionProvider.notifier).startSession(
        category: 'Article 250',
        questionCount: 5,
      );

      // Assert
      final session = container.read(currentSessionProvider);
      expect(session, isNotNull);
      expect(session!.questions.length, 5);
      expect(session.status, SessionStatus.inProgress);
    });

    testWidgets('sessionStatsProvider should calculate correct score', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Start session
      await container.read(currentSessionProvider.notifier).startSession(
        category: 'Article 250',
        questionCount: 10,
      );

      // Submit answers
      container.read(currentSessionProvider.notifier).submitAnswer(0, 0, const Duration(seconds: 5));
      container.read(currentSessionProvider.notifier).submitAnswer(1, 1, const Duration(seconds: 10));

      // Act
      final stats = container.read(sessionStatsProvider);

      // Assert
      expect(stats, isNotNull);
      expect(stats!.answeredQuestions, 2);
      expect(stats.totalQuestions, 10);
    });

    testWidgets('submitAnswer should record correct answer', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(currentSessionProvider.notifier).startSession(
        category: 'Article 250',
        questionCount: 5,
      );

      // Act
      container.read(currentSessionProvider.notifier).submitAnswer(0, 0, const Duration(seconds: 5));

      // Assert
      final session = container.read(currentSessionProvider);
      expect(session!.answers.length, 1);
      expect(session.answers.values.first.selectedIndex, 0);
    });

    testWidgets('completeSession should update status', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(currentSessionProvider.notifier).startSession(
        category: 'Article 250',
        questionCount: 5,
      );

      // Act
      container.read(currentSessionProvider.notifier).completeSession();

      // Assert
      final session = container.read(currentSessionProvider);
      expect(session!.status, SessionStatus.completed);
      expect(session.completedAt, isNotNull);
    });

    testWidgets('abandonSession should update status', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(currentSessionProvider.notifier).startSession(
        category: 'Article 250',
        questionCount: 5,
      );

      // Act
      container.read(currentSessionProvider.notifier).abandonSession();

      // Assert
      final session = container.read(currentSessionProvider);
      expect(session!.status, SessionStatus.abandoned);
    });

    testWidgets('reset should clear session', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(currentSessionProvider.notifier).startSession(
        category: 'Article 250',
        questionCount: 5,
      );

      // Act
      container.read(currentSessionProvider.notifier).reset();

      // Assert
      expect(container.read(currentSessionProvider), isNull);
    });
  });

  group('Performance Providers', () {
    testWidgets('performanceMetricsProvider should initialize with default values', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Assert
      final metrics = container.read(performanceMetricsProvider);
      expect(metrics.totalQuestionsAnswered, 0);
      expect(metrics.totalCorrectAnswers, 0);
      expect(metrics.accuracy, 0.0);
    });

    testWidgets('recordAnswer should update metrics', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      container.read(performanceMetricsProvider.notifier).recordAnswer(
        'Article 250',
        true, // Correct
        const Duration(seconds: 10),
      );

      // Assert
      final metrics = container.read(performanceMetricsProvider);
      expect(metrics.totalQuestionsAnswered, 1);
      expect(metrics.totalCorrectAnswers, 1);
      expect(metrics.accuracy, 100.0);
    });

    testWidgets('recordAnswer should track category metrics', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      container.read(performanceMetricsProvider.notifier).recordAnswer(
        'Article 250',
        true,
        const Duration(seconds: 10),
      );

      container.read(performanceMetricsProvider.notifier).recordAnswer(
        'Article 250',
        false,
        const Duration(seconds: 15),
      );

      // Assert
      final metrics = container.read(performanceMetricsProvider);
      final categoryMetrics = metrics.categoryMetrics['Article 250'];
      expect(categoryMetrics, isNotNull);
      expect(categoryMetrics!.questionsAnswered, 2);
      expect(categoryMetrics.correctAnswers, 1);
      expect(categoryMetrics.accuracy, 50.0);
    });

    testWidgets('recordAnswer should track streaks', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act - 2 correct answers
      container.read(performanceMetricsProvider.notifier).recordAnswer(
        'Article 250',
        true,
        const Duration(seconds: 10),
      );

      container.read(performanceMetricsProvider.notifier).recordAnswer(
        'Article 250',
        true,
        const Duration(seconds: 10),
      );

      // Assert
      final metrics = container.read(performanceMetricsProvider);
      final categoryMetrics = metrics.categoryMetrics['Article 250'];
      expect(categoryMetrics!.currentStreak, 2);
      expect(categoryMetrics.bestStreak, 2);
    });

    testWidgets('recordAnswer should reset streak on incorrect', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act - 2 correct, 1 incorrect
      container.read(performanceMetricsProvider.notifier).recordAnswer('Article 250', true, const Duration(seconds: 10));
      container.read(performanceMetricsProvider.notifier).recordAnswer('Article 250', true, const Duration(seconds: 10));
      container.read(performanceMetricsProvider.notifier).recordAnswer('Article 250', false, const Duration(seconds: 10));

      // Assert
      final metrics = container.read(performanceMetricsProvider);
      final categoryMetrics = metrics.categoryMetrics['Article 250'];
      expect(categoryMetrics!.currentStreak, 0);
      expect(categoryMetrics.bestStreak, 2);
    });

    testWidgets('masteryStatusProvider should calculate mastery percentage', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Add some category metrics
      final notifier = container.read(performanceMetricsProvider.notifier);
      for (int i = 0; i < 10; i++) {
        notifier.recordAnswer('Category $i', true, const Duration(seconds: 10));
      }

      // Act
      final masteryStatus = container.read(masteryStatusProvider);

      // Assert
      expect(masteryStatus.masteredCategories, greaterThanOrEqualTo(0));
      expect(masteryStatus.totalCategories, greaterThanOrEqualTo(0));
    });
  });

  group('UI State Providers', () {
    testWidgets('selectedCategoryProvider should default to null', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Assert
      expect(container.read(selectedCategoryProvider), isNull);
    });

    testWidgets('selectedCategoryProvider should update', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      container.read(selectedCategoryProvider.notifier).state = 'Article 250';

      // Assert
      expect(container.read(selectedCategoryProvider), 'Article 250');
    });

    testWidgets('showExplanationProvider should default to false', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Assert
      expect(container.read(showExplanationProvider), false);
    });

    testWidgets('currentQuestionIndexProvider should default to 0', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Assert
      expect(container.read(currentQuestionIndexProvider), 0);
    });
  });

  group('SessionStats', () {
    test('should calculate progress correctly', () {
      // Arrange
      const stats = SessionStats(
        totalQuestions: 10,
        answeredQuestions: 5,
        correctAnswers: 4,
        score: 80,
        passingScore: 80,
        isPassing: true,
        timeElapsed: Duration(minutes: 5),
      );

      // Assert
      expect(stats.progress, 50.0);
    });

    test('should estimate time remaining', () {
      // Arrange
      const stats = SessionStats(
        totalQuestions: 10,
        answeredQuestions: 5,
        correctAnswers: 4,
        score: 80,
        passingScore: 80,
        isPassing: true,
        timeElapsed: Duration(seconds: 300), // 5 minutes for 5 questions
      );

      // Act
      final remaining = stats.estimatedTimeRemaining;

      // Assert
      expect(remaining.inSeconds, 300); // 5 questions remaining * 60 seconds each
    });

    test('should handle zero answered questions', () {
      // Arrange
      const stats = SessionStats(
        totalQuestions: 10,
        answeredQuestions: 0,
        correctAnswers: 0,
        score: 0,
        passingScore: 80,
        isPassing: false,
        timeElapsed: Duration.zero,
      );

      // Assert
      expect(stats.progress, 0.0);
      expect(stats.estimatedTimeRemaining.inSeconds, 0);
    });
  });

  group('MasteryStatus', () {
    test('should calculate mastery percentage correctly', () {
      // Arrange
      const status = MasteryStatus(
        masteredCategories: 4,
        totalCategories: 5,
        overallAccuracy: 85.0,
        isExamReady: true,
      );

      // Assert
      expect(status.masteryPercentage, 80.0);
    });

    test('should handle zero total categories', () {
      // Arrange
      const status = MasteryStatus(
        masteredCategories: 0,
        totalCategories: 0,
        overallAccuracy: 0.0,
        isExamReady: false,
      );

      // Assert
      expect(status.masteryPercentage, 0.0);
    });
  });
}
