/// =============================================================================
/// Question Service — Data Access Layer
/// =============================================================================

import 'dart:convert';
import '../models/models.dart';

/// Service for managing question data
/// 
/// In production, this would connect to:
/// - Firestore (Sector 06)
/// - REST API
/// - Local cache
class QuestionService {
  /// Get all questions
  Future<List<Question>> getAllQuestions() async {
    // TODO: Replace with actual data source
    await Future.delayed(const Duration(milliseconds: 100)); // Simulate network
    return _mockQuestions;
  }

  /// Get questions by category
  Future<List<Question>> getQuestionsByCategory(String category) async {
    final all = await getAllQuestions();
    return all.where((q) => q.category.toLowerCase() == category.toLowerCase()).toList();
  }

  /// Get questions by difficulty
  Future<List<Question>> getQuestionsByDifficulty(DifficultyLevel difficulty) async {
    final all = await getAllQuestions();
    return all.where((q) => q.difficulty == difficulty).toList();
  }

  /// Get a single question by ID
  Future<Question?> getQuestionById(String id) async {
    final all = await getAllQuestions();
    return all.firstWhere((q) => q.id == id, orElse: () => throw Exception('Question not found'));
  }

  /// Get random questions
  Future<List<Question>> getRandomQuestions({int count = 10}) async {
    final all = await getAllQuestions();
    if (all.length <= count) return all;

    final shuffled = List<Question>.from(all)..shuffle();
    return shuffled.take(count).toList();
  }

  /// Get questions by NEC reference
  Future<List<Question>> getQuestionsByNecReference(String necRef) async {
    final all = await getAllQuestions();
    return all
        .where((q) => q.necReference.toLowerCase().contains(necRef.toLowerCase()))
        .toList();
  }
}

/// =============================================================================
/// Session Service — Interview Management
/// =============================================================================

/// Service for managing interview sessions
class SessionService {
  /// Create a new session with questions
  Future<List<Question>> createSession({
    required String category,
    int questionCount = 10,
  }) async {
    // TODO: Replace with actual data source
    await Future.delayed(const Duration(milliseconds: 100));

    if (category.isEmpty) {
      return _getRandomQuestions(questionCount);
    }

    return _getQuestionsByCategory(category, questionCount);
  }

  /// Save session results
  Future<void> saveSessionResults({
    required String sessionId,
    required int score,
    required Map<String, dynamic> answers,
  }) async {
    // TODO: Save to Firestore
    await Future.delayed(const Duration(milliseconds: 50));
  }

  List<Question> _getRandomQuestions(int count) {
    return _mockQuestions.take(count).toList();
  }

  List<Question> _getQuestionsByCategory(String category, int count) {
    return _mockQuestions
        .where((q) => q.category.toLowerCase() == category.toLowerCase())
        .take(count)
        .toList();
  }
}

/// =============================================================================
/// Mock Data — For Development
/// =============================================================================

final List<Question> _mockQuestions = [
  const Question(
    id: 'q001',
    text: 'What is the minimum conductor size for a 20-ampere branch circuit?',
    category: 'Article 210',
    necReference: '210.19(A)(1)',
    necYear: 2023,
    options: [
      '14 AWG',
      '12 AWG',
      '10 AWG',
      '8 AWG',
    ],
    correctIndex: 1,
    explanation: 'According to NEC 210.19(A)(1), 12 AWG conductors are required for 20-ampere circuits.',
    difficulty: DifficultyLevel.beginner,
    tags: ['conductors', 'branch-circuits'],
  ),
  const Question(
    id: 'q002',
    text: 'What is the demand factor for a single electric range rated at 12 kW?',
    category: 'Article 220',
    necReference: '220.55',
    necYear: 2023,
    options: [
      '100%',
      '80%',
      '70%',
      '60%',
    ],
    correctIndex: 1,
    explanation: 'NEC Table 220.55 Column C specifies an 80% demand factor for a single 12 kW range.',
    difficulty: DifficultyLevel.intermediate,
    tags: ['load-calculations', 'appliances'],
  ),
  const Question(
    id: 'q003',
    text: 'What is the maximum spacing for supports of 1-inch EMT conduit?',
    category: 'Article 358',
    necReference: '358.30(A)',
    necYear: 2023,
    options: [
      '3 feet',
      '5 feet',
      '10 feet',
      '15 feet',
    ],
    correctIndex: 2,
    explanation: 'NEC 358.30(A) requires EMT to be supported at least every 10 feet.',
    difficulty: DifficultyLevel.beginner,
    tags: ['conduit', 'supports'],
  ),
  const Question(
    id: 'q004',
    text: 'What is the minimum working space depth for equipment operating at 480V?',
    category: 'Article 110',
    necReference: '110.26(A)(1)',
    necYear: 2023,
    options: [
      '3 feet',
      '3.5 feet',
      '4 feet',
      '6 feet',
    ],
    correctIndex: 1,
    explanation: 'For 480V equipment (Condition 1), NEC Table 110.26(A)(1) requires 3.5 feet of working space.',
    difficulty: DifficultyLevel.intermediate,
    tags: ['safety', 'working-space'],
  ),
  const Question(
    id: 'q005',
    text: 'What is the maximum overcurrent protection for 12 AWG copper conductors?',
    category: 'Article 240',
    necReference: '240.4(D)(5)',
    necYear: 2023,
    options: [
      '15 amperes',
      '20 amperes',
      '25 amperes',
      '30 amperes',
    ],
    correctIndex: 1,
    explanation: 'NEC 240.4(D)(5) limits 12 AWG copper to 20 amperes overcurrent protection.',
    difficulty: DifficultyLevel.beginner,
    tags: ['overcurrent', 'conductors'],
  ),
];
