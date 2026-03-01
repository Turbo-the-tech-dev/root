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
    required int score,
    required Map<String, dynamic> answers,
    required DateTime completedAt,
  }) async {
    await FirebaseFirestore.instance.collection('sessions').doc(sessionId).set({
      'score': score,
      'answers': answers,
      'completed_at': completedAt.toIso8601String(),
    });
  }

  /// Resume an existing session
  Future<InterviewSession?> resumeSession(String sessionId) async {
    final doc = await FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionId)
        .get();
    if (!doc.exists || doc.data() == null) return null;
    try {
      return InterviewSession.fromJson({'id': sessionId, ...doc.data()!});
    } catch (_) {
      return null;
    }
  }

  /// Delete a session
  Future<void> deleteSession(String sessionId) async {
    await FirebaseFirestore.instance
        .collection('sessions')
        .doc(sessionId)
        .delete();
  }
}
