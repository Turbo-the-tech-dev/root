/// =============================================================================
/// Imperial Dart Models — Electrician Interview System
/// Type-safe, performance-optimized data structures
/// =============================================================================
/// 
/// These models are designed for:
/// - Zero unnecessary allocations (Hiroshi standard)
/// - Immutable state (Riverpod compatible)
/// - NEC 2026 compliance tracking
/// - Efficient JSON serialization
/// =============================================================================

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// =============================================================================
/// NECQuestion Model (Curtis Hayes Standard)
/// =============================================================================

/// Core NEC question model — optimized for zero allocations
@immutable
class NECQuestion extends Equatable {
  final String id;
  final String codeSection; // e.g., "Article 250.64"
  final String questionText;
  final List<String> options;
  final int correctIndex;
  final String rationale;

  const NECQuestion({
    required this.id,
    required this.codeSection,
    required this.questionText,
    required this.options,
    required this.correctIndex,
    required this.rationale,
  });

  /// Zero-unnecessary-allocation factory
  factory NECQuestion.fromMap(Map<String, dynamic> map) {
    return NECQuestion(
      id: map['id'] as String,
      codeSection: map['section'] as String,
      questionText: map['text'] as String,
      options: List<String>.from(map['options'] as List<dynamic>),
      correctIndex: map['correctIndex'] as int,
      rationale: map['rationale'] as String,
    );
  }

  /// Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'section': codeSection,
      'text': questionText,
      'options': options,
      'correctIndex': correctIndex,
      'rationale': rationale,
    };
  }

  /// Convert to Question (legacy compatibility)
  Question toQuestion({
    String category = 'NEC',
    int necYear = 2023,
    DifficultyLevel difficulty = DifficultyLevel.intermediate,
    List<String> tags = const [],
  }) {
    return Question(
      id: id,
      text: questionText,
      category: category,
      necReference: codeSection,
      necYear: necYear,
      options: options,
      correctIndex: correctIndex,
      explanation: rationale,
      difficulty: difficulty,
      tags: tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        codeSection,
        questionText,
        options,
        correctIndex,
        rationale,
      ];
}

/// =============================================================================
/// Question Model (Extended with metadata)
/// =============================================================================

/// Represents a single NEC 2026 interview question with full metadata
class Question extends Equatable {
  final String id;
  final String text;
  final String category;
  final String necReference;
  final int necYear;
  final List<String> options;
  final int correctIndex;
  final String explanation;
  final DifficultyLevel difficulty;
  final bool isRequired;
  final List<String> tags;

  const Question({
    required this.id,
    required this.text,
    required this.category,
    required this.necReference,
    required this.necYear,
    required this.options,
    required this.correctIndex,
    required this.explanation,
    required this.difficulty,
    this.isRequired = true,
    this.tags = const [],
  });

  /// Factory from NECQuestion (upgrade path)
  factory Question.fromNECQuestion(NECQuestion nec, {
    String category = 'NEC',
    int necYear = 2023,
    DifficultyLevel difficulty = DifficultyLevel.intermediate,
    List<String> tags = const [],
  }) {
    return Question(
      id: nec.id,
      text: nec.questionText,
      category: category,
      necReference: nec.codeSection,
      necYear: necYear,
      options: nec.options,
      correctIndex: nec.correctIndex,
      explanation: nec.rationale,
      difficulty: difficulty,
      tags: tags,
    );
  }

  /// Factory constructor from JSON (efficient parsing)
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] as String,
      text: json['text'] as String,
      category: json['category'] as String,
      necReference: json['nec_reference'] as String,
      necYear: json['nec_year'] as int,
      options: List<String>.from(json['options'] as List),
      correctIndex: json['correct_index'] as int,
      explanation: json['explanation'] as String,
      difficulty: DifficultyLevel.values.byName(json['difficulty'] as String),
      isRequired: json['is_required'] as bool? ?? true,
      tags: json['tags'] != null ? List<String>.from(json['tags'] as List) : [],
    );
  }

  /// Convert to JSON (for persistence/API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'category': category,
      'nec_reference': necReference,
      'nec_year': necYear,
      'options': options,
      'correct_index': correctIndex,
      'explanation': explanation,
      'difficulty': difficulty.name,
      'is_required': isRequired,
      'tags': tags,
    };
  }

  /// Copy with immutable state updates
  Question copyWith({
    String? id,
    String? text,
    String? category,
    String? necReference,
    int? necYear,
    List<String>? options,
    int? correctIndex,
    String? explanation,
    DifficultyLevel? difficulty,
    bool? isRequired,
    List<String>? tags,
  }) {
    return Question(
      id: id ?? this.id,
      text: text ?? this.text,
      category: category ?? this.category,
      necReference: necReference ?? this.necReference,
      necYear: necYear ?? this.necYear,
      options: options ?? this.options,
      correctIndex: correctIndex ?? this.correctIndex,
      explanation: explanation ?? this.explanation,
      difficulty: difficulty ?? this.difficulty,
      isRequired: isRequired ?? this.isRequired,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        text,
        category,
        necReference,
        necYear,
        options,
        correctIndex,
        explanation,
        difficulty,
        isRequired,
        tags,
      ];
}

/// =============================================================================
/// Difficulty Level Enum
/// =============================================================================

enum DifficultyLevel {
  beginner,    // Apprentice level
  intermediate, // Journeyman level
  advanced,    // Master Electrician level
  expert,      // NEC 2026 expert
}

/// =============================================================================
/// Interview Session Model
/// =============================================================================

/// Represents an active interview session
class InterviewSession extends Equatable {
  final String id;
  final List<Question> questions;
  final Map<String, UserAnswer> answers;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int passingScore;
  final SessionStatus status;

  const InterviewSession({
    required this.id,
    required this.questions,
    this.answers = const {},
    required this.startedAt,
    this.completedAt,
    this.passingScore = 80,
    this.status = SessionStatus.inProgress,
  });

  /// Calculate current score
  int get score {
    if (answers.isEmpty) return 0;
    int correct = answers.values.where((a) => a.isCorrect).length;
    return ((correct / questions.length) * 100).round();
  }

  /// Check if session is complete
  bool get isComplete => status == SessionStatus.completed;

  /// Get unanswered questions
  List<Question> get unansweredQuestions =>
      questions.where((q) => !answers.containsKey(q.id)).toList();

  /// Get answered questions
  List<Question> get answeredQuestions =>
      questions.where((q) => answers.containsKey(q.id)).toList();

  factory InterviewSession.fromJson(Map<String, dynamic> json) {
    return InterviewSession(
      id: json['id'] as String,
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q as Map<String, dynamic>))
          .toList(),
      answers: (json['answers'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, UserAnswer.fromJson(v as Map<String, dynamic>))) ??
          {},
      startedAt: DateTime.parse(json['started_at'] as String),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'] as String)
          : null,
      passingScore: json['passing_score'] as int? ?? 80,
      status: SessionStatus.values.byName(json['status'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'questions': questions.map((q) => q.toJson()).toList(),
      'answers': answers.map((k, v) => MapEntry(k, v.toJson())),
      'started_at': startedAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'passing_score': passingScore,
      'status': status.name,
    };
  }

  InterviewSession copyWith({
    String? id,
    List<Question>? questions,
    Map<String, UserAnswer>? answers,
    DateTime? startedAt,
    DateTime? completedAt,
    int? passingScore,
    SessionStatus? status,
  }) {
    return InterviewSession(
      id: id ?? this.id,
      questions: questions ?? this.questions,
      answers: answers ?? this.answers,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      passingScore: passingScore ?? this.passingScore,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [
        id,
        questions,
        answers,
        startedAt,
        completedAt,
        passingScore,
        status,
      ];
}

/// =============================================================================
/// User Answer Model
/// =============================================================================

/// Represents a user's answer to a question
class UserAnswer extends Equatable {
  final String questionId;
  final int selectedIndex;
  final bool isCorrect;
  final Duration timeSpent;
  final DateTime answeredAt;

  const UserAnswer({
    required this.questionId,
    required this.selectedIndex,
    required this.isCorrect,
    required this.timeSpent,
    required this.answeredAt,
  });

  factory UserAnswer.fromJson(Map<String, dynamic> json) {
    return UserAnswer(
      questionId: json['question_id'] as String,
      selectedIndex: json['selected_index'] as int,
      isCorrect: json['is_correct'] as bool,
      timeSpent: Duration(seconds: json['time_spent_seconds'] as int),
      answeredAt: DateTime.parse(json['answered_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'selected_index': selectedIndex,
      'is_correct': isCorrect,
      'time_spent_seconds': timeSpent.inSeconds,
      'answered_at': answeredAt.toIso8601String(),
    };
  }

  UserAnswer copyWith({
    String? questionId,
    int? selectedIndex,
    bool? isCorrect,
    Duration? timeSpent,
    DateTime? answeredAt,
  }) {
    return UserAnswer(
      questionId: questionId ?? this.questionId,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isCorrect: isCorrect ?? this.isCorrect,
      timeSpent: timeSpent ?? this.timeSpent,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  @override
  List<Object?> get props => [
        questionId,
        selectedIndex,
        isCorrect,
        timeSpent,
        answeredAt,
      ];
}

/// =============================================================================
/// Session Status Enum
/// =============================================================================

enum SessionStatus {
  inProgress,
  completed,
  abandoned,
}

/// =============================================================================
/// Category Model
/// =============================================================================

/// Represents a question category (e.g., "Article 220", "Conduit Bending")
class Category extends Equatable {
  final String id;
  final String name;
  final String description;
  final String? necArticle;
  final int questionCount;
  final int masteryThreshold;

  const Category({
    required this.id,
    required this.name,
    required this.description,
    this.necArticle,
    this.questionCount = 0,
    this.masteryThreshold = 80,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      necArticle: json['nec_article'] as String?,
      questionCount: json['question_count'] as int? ?? 0,
      masteryThreshold: json['mastery_threshold'] as int? ?? 80,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'nec_article': necArticle,
      'question_count': questionCount,
      'mastery_threshold': masteryThreshold,
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        necArticle,
        questionCount,
        masteryThreshold,
      ];
}

/// =============================================================================
/// Performance Metrics Model
/// =============================================================================

/// Tracks user performance across categories
class PerformanceMetrics extends Equatable {
  final String userId;
  final Map<String, CategoryMetrics> categoryMetrics;
  final int totalQuestionsAnswered;
  final int totalCorrectAnswers;
  final Duration totalTimeSpent;
  final DateTime lastActiveAt;

  const PerformanceMetrics({
    required this.userId,
    this.categoryMetrics = const {},
    this.totalQuestionsAnswered = 0,
    this.totalCorrectAnswers = 0,
    this.totalTimeSpent = Duration.zero,
    required this.lastActiveAt,
  });

  /// Overall accuracy percentage
  double get accuracy {
    if (totalQuestionsAnswered == 0) return 0.0;
    return (totalCorrectAnswers / totalQuestionsAnswered) * 100;
  }

  /// Average time per question
  Duration get averageTimePerQuestion {
    if (totalQuestionsAnswered == 0) return Duration.zero;
    return Duration(milliseconds: totalTimeSpent.inMilliseconds ~/ totalQuestionsAnswered);
  }

  factory PerformanceMetrics.fromJson(Map<String, dynamic> json) {
    return PerformanceMetrics(
      userId: json['user_id'] as String,
      categoryMetrics: (json['category_metrics'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, CategoryMetrics.fromJson(v as Map<String, dynamic>))) ??
          {},
      totalQuestionsAnswered: json['total_questions_answered'] as int? ?? 0,
      totalCorrectAnswers: json['total_correct_answers'] as int? ?? 0,
      totalTimeSpent: Duration(seconds: json['total_time_spent_seconds'] as int? ?? 0),
      lastActiveAt: DateTime.parse(json['last_active_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'category_metrics': categoryMetrics.map((k, v) => MapEntry(k, v.toJson())),
      'total_questions_answered': totalQuestionsAnswered,
      'total_correct_answers': totalCorrectAnswers,
      'total_time_spent_seconds': totalTimeSpent.inSeconds,
      'last_active_at': lastActiveAt.toIso8601String(),
    };
  }

  PerformanceMetrics copyWith({
    String? userId,
    Map<String, CategoryMetrics>? categoryMetrics,
    int? totalQuestionsAnswered,
    int? totalCorrectAnswers,
    Duration? totalTimeSpent,
    DateTime? lastActiveAt,
  }) {
    return PerformanceMetrics(
      userId: userId ?? this.userId,
      categoryMetrics: categoryMetrics ?? this.categoryMetrics,
      totalQuestionsAnswered: totalQuestionsAnswered ?? this.totalQuestionsAnswered,
      totalCorrectAnswers: totalCorrectAnswers ?? this.totalCorrectAnswers,
      totalTimeSpent: totalTimeSpent ?? this.totalTimeSpent,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        categoryMetrics,
        totalQuestionsAnswered,
        totalCorrectAnswers,
        totalTimeSpent,
        lastActiveAt,
      ];
}

/// =============================================================================
/// Category Metrics Model
/// =============================================================================

/// Performance metrics for a specific category
class CategoryMetrics extends Equatable {
  final String categoryId;
  final int questionsAnswered;
  final int correctAnswers;
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastPracticedAt;

  const CategoryMetrics({
    required this.categoryId,
    this.questionsAnswered = 0,
    this.correctAnswers = 0,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastPracticedAt,
  });

  /// Accuracy percentage for this category
  double get accuracy {
    if (questionsAnswered == 0) return 0.0;
    return (correctAnswers / questionsAnswered) * 100;
  }

  /// Mastery status
  bool get isMastered => accuracy >= 80 && questionsAnswered >= 10;

  factory CategoryMetrics.fromJson(Map<String, dynamic> json) {
    return CategoryMetrics(
      categoryId: json['category_id'] as String,
      questionsAnswered: json['questions_answered'] as int? ?? 0,
      correctAnswers: json['correct_answers'] as int? ?? 0,
      currentStreak: json['current_streak'] as int? ?? 0,
      bestStreak: json['best_streak'] as int? ?? 0,
      lastPracticedAt: json['last_practiced_at'] != null
          ? DateTime.parse(json['last_practiced_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'questions_answered': questionsAnswered,
      'correct_answers': correctAnswers,
      'current_streak': currentStreak,
      'best_streak': bestStreak,
      'last_practiced_at': lastPracticedAt?.toIso8601String(),
    };
  }

  CategoryMetrics copyWith({
    String? categoryId,
    int? questionsAnswered,
    int? correctAnswers,
    int? currentStreak,
    int? bestStreak,
    DateTime? lastPracticedAt,
  }) {
    return CategoryMetrics(
      categoryId: categoryId ?? this.categoryId,
      questionsAnswered: questionsAnswered ?? this.questionsAnswered,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastPracticedAt: lastPracticedAt ?? this.lastPracticedAt,
    );
  }

  @override
  List<Object?> get props => [
        categoryId,
        questionsAnswered,
        correctAnswers,
        currentStreak,
        bestStreak,
        lastPracticedAt,
      ];
}
