/// =============================================================================
/// Riverpod Providers — Electrician Interview System
/// State management with zero unnecessary rebuilds
/// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';
import '../services/question_service.dart';
import '../services/session_service.dart';

/// =============================================================================
/// Question Providers
/// =============================================================================

/// All available questions (cached)
final questionsProvider = FutureProvider<List<Question>>((ref) async {
  final service = ref.watch(questionServiceProvider);
  return service.getAllQuestions();
});

/// Questions filtered by category
final questionsByCategoryProvider =
    FutureProvider.family<List<Question>, String>((ref, category) async {
  final service = ref.watch(questionServiceProvider);
  return service.getQuestionsByCategory(category);
});

/// Questions filtered by difficulty
final questionsByDifficultyProvider =
    FutureProvider.family<List<Question>, DifficultyLevel>((ref, difficulty) async {
  final service = ref.watch(questionServiceProvider);
  return service.getQuestionsByDifficulty(difficulty);
});

/// Random question for quick practice
final randomQuestionProvider = Provider<Question?>((ref) {
  final questions = ref.watch(questionsProvider);
  return questions.value?.isNotEmpty == true
      ? questions.value![DateTime.now().millisecondsSinceEpoch % questions.value!.length]
      : null;
});

/// =============================================================================
/// Session Providers
/// =============================================================================

/// Current active interview session
final currentSessionProvider = StateNotifierProvider<SessionNotifier, InterviewSession?>((ref) {
  return SessionNotifier(ref.watch(sessionServiceProvider));
});

/// Session statistics (computed)
final sessionStatsProvider = Provider<SessionStats?>((ref) {
  final session = ref.watch(currentSessionProvider);
  if (session == null) return null;

  return SessionStats(
    totalQuestions: session.questions.length,
    answeredQuestions: session.answeredQuestions.length,
    correctAnswers: session.answers.values.where((a) => a.isCorrect).length,
    score: session.score,
    passingScore: session.passingScore,
    isPassing: session.score >= session.passingScore,
    timeElapsed: DateTime.now().difference(session.startedAt),
  );
});

/// =============================================================================
/// Performance Providers
/// =============================================================================

/// User performance metrics
final performanceMetricsProvider =
    StateNotifierProvider<PerformanceNotifier, PerformanceMetrics>((ref) {
  return PerformanceNotifier();
});

/// Category-specific performance
final categoryPerformanceProvider =
    Provider.family<double, String>((ref, categoryId) {
  final metrics = ref.watch(performanceMetricsProvider);
  final categoryMetrics = metrics.categoryMetrics[categoryId];
  return categoryMetrics?.accuracy ?? 0.0;
});

/// Overall mastery status
final masteryStatusProvider = Provider<MasteryStatus>((ref) {
  final metrics = ref.watch(performanceMetricsProvider);
  final masteredCategories = metrics.categoryMetrics.values.where((m) => m.isMastered).length;
  final totalCategories = metrics.categoryMetrics.length;

  return MasteryStatus(
    masteredCategories: masteredCategories,
    totalCategories: totalCategories,
    overallAccuracy: metrics.accuracy,
    isExamReady: metrics.accuracy >= 80 && masteredCategories >= totalCategories * 0.8,
  );
});

/// =============================================================================
/// UI State Providers
/// =============================================================================

/// Current selected category filter
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

/// Current selected difficulty filter
final selectedDifficultyProvider = StateProvider<DifficultyLevel?>((ref) => null);

/// Show explanation toggle
final showExplanationProvider = StateProvider<bool>((ref) => false);

/// Current question index in session
final currentQuestionIndexProvider = StateProvider<int>((ref) => 0);

/// =============================================================================
/// Service Providers
/// =============================================================================

/// Question service singleton
final questionServiceProvider = Provider<QuestionService>((ref) {
  return QuestionService();
});

/// Session service singleton
final sessionServiceProvider = Provider<SessionService>((ref) {
  return SessionService();
});

/// =============================================================================
/// Notifiers
/// =============================================================================

/// Manages interview session state
class SessionNotifier extends StateNotifier<InterviewSession?> {
  final SessionService _sessionService;

  SessionNotifier(this._sessionService) : super(null);

  /// Start a new interview session
  Future<void> startSession({
    required String category,
    int questionCount = 10,
  }) async {
    final questions = await _sessionService.createSession(
      category: category,
      questionCount: questionCount,
    );

    state = InterviewSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      questions: questions,
      startedAt: DateTime.now(),
      status: SessionStatus.inProgress,
    );
  }

  /// Submit an answer
  void submitAnswer(int questionIndex, int selectedIndex, Duration timeSpent) {
    if (state == null) return;

    final question = state!.questions[questionIndex];
    final isCorrect = selectedIndex == question.correctIndex;

    final answer = UserAnswer(
      questionId: question.id,
      selectedIndex: selectedIndex,
      isCorrect: isCorrect,
      timeSpent: timeSpent,
      answeredAt: DateTime.now(),
    );

    state = state!.copyWith(
      answers: {
        ...state!.answers,
        question.id: answer,
      },
    );
  }

  /// Move to next question
  void nextQuestion() {
    // Handled by currentQuestionIndexProvider
  }

  /// Complete the session
  void completeSession() {
    if (state == null) return;

    state = state!.copyWith(
      completedAt: DateTime.now(),
      status: SessionStatus.completed,
    );
  }

  /// Abandon the session
  void abandonSession() {
    if (state == null) return;

    state = state!.copyWith(
      completedAt: DateTime.now(),
      status: SessionStatus.abandoned,
    );
  }

  /// Reset session
  void reset() {
    state = null;
  }
}

/// Manages performance metrics
class PerformanceNotifier extends StateNotifier<PerformanceMetrics> {
  PerformanceNotifier()
      : super(PerformanceMetrics(
          userId: 'current_user',
          lastActiveAt: DateTime.now(),
        ));

  /// Record an answer
  void recordAnswer(String categoryId, bool isCorrect, Duration timeSpent) {
    final categoryMetrics = state.categoryMetrics[categoryId] ??
        CategoryMetrics(categoryId: categoryId);

    state = state.copyWith(
      totalQuestionsAnswered: state.totalQuestionsAnswered + 1,
      totalCorrectAnswers: state.totalCorrectAnswers + (isCorrect ? 1 : 0),
      totalTimeSpent: state.totalTimeSpent + timeSpent,
      lastActiveAt: DateTime.now(),
      categoryMetrics: {
        ...state.categoryMetrics,
        categoryId: categoryMetrics.copyWith(
          questionsAnswered: categoryMetrics.questionsAnswered + 1,
          correctAnswers: categoryMetrics.correctAnswers + (isCorrect ? 1 : 0),
          currentStreak: isCorrect ? categoryMetrics.currentStreak + 1 : 0,
          bestStreak: isCorrect
              ? (categoryMetrics.currentStreak + 1).clamp(0, categoryMetrics.bestStreak)
              : categoryMetrics.bestStreak,
          lastPracticedAt: DateTime.now(),
        ),
      },
    );
  }

  /// Reset all metrics (for testing)
  void reset() {
    state = PerformanceMetrics(
      userId: state.userId,
      lastActiveAt: DateTime.now(),
    );
  }
}

/// =============================================================================
/// Computed Models
/// =============================================================================

/// Session statistics (immutable computed value)
class SessionStats {
  final int totalQuestions;
  final int answeredQuestions;
  final int correctAnswers;
  final int score;
  final int passingScore;
  final bool isPassing;
  final Duration timeElapsed;

  const SessionStats({
    required this.totalQuestions,
    required this.answeredQuestions,
    required this.correctAnswers,
    required this.score,
    required this.passingScore,
    required this.isPassing,
    required this.timeElapsed,
  });

  /// Progress percentage
  double get progress =>
      totalQuestions > 0 ? (answeredQuestions / totalQuestions) * 100 : 0.0;

  /// Time remaining estimate (if 10 questions, based on average time)
  Duration get estimatedTimeRemaining {
    if (answeredQuestions == 0) return Duration.zero;
    final avgTime = timeElapsed.inSeconds ~/ answeredQuestions;
    final remaining = totalQuestions - answeredQuestions;
    return Duration(seconds: avgTime * remaining);
  }
}

/// Mastery status summary
class MasteryStatus {
  final int masteredCategories;
  final int totalCategories;
  final double overallAccuracy;
  final bool isExamReady;

  const MasteryStatus({
    required this.masteredCategories,
    required this.totalCategories,
    required this.overallAccuracy,
    required this.isExamReady,
  });

  /// Mastery percentage
  double get masteryPercentage =>
      totalCategories > 0 ? (masteredCategories / totalCategories) * 100 : 0.0;
}
