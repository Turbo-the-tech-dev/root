/// =============================================================================
/// Session Service — Interview Management
/// =============================================================================

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/models.dart';
import 'question_service.dart';

/// Service for managing interview sessions
class SessionService {
  final QuestionService _questionService;

  SessionService({QuestionService? questionService})
      : _questionService = questionService ?? QuestionService();

  /// Create a new session with questions
  Future<List<Question>> createSession({
    required String category,
    int questionCount = 10,
  }) async {
    if (category.isEmpty || category == 'all') {
      return _questionService.getRandomQuestions(count: questionCount);
    }

    final questions = await _questionService.getQuestionsByCategory(category);
    if (questions.length <= questionCount) {
      return questions;
    }

    // Shuffle and take requested count
    final shuffled = List<Question>.from(questions)..shuffle();
    return shuffled.take(questionCount).toList();
  }

  /// Save session results to Firestore
  Future<void> saveSessionResults({
    required String sessionId,
    required String userId,
    required int score,
    required Map<String, dynamic> answers,
    required DateTime completedAt,
  }) async {
    await FirebaseFirestore.instance.collection('sessions').doc(sessionId).set({
      'user_id': userId,
      'score': score,
      'answers': answers,
      'completed_at': completedAt.toIso8601String(),
    });
  }

  /// Resume an existing session (verifies ownership)
  Future<InterviewSession?> resumeSession(String sessionId, {required String userId}) async {
    final doc = await FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionId)
        .get();
    if (!doc.exists || doc.data() == null) return null;
    if (doc.data()!['user_id'] != userId) return null;
    try {
      return InterviewSession.fromJson({'id': sessionId, ...doc.data()!});
    } catch (_) {
      return null;
    }
  }

  /// Delete a session (verifies ownership)
  Future<void> deleteSession(String sessionId, {required String userId}) async {
    final doc = await FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionId)
        .get();
    if (!doc.exists || doc.data()?['user_id'] != userId) return;
    await FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionId)
        .delete();
  }
}
