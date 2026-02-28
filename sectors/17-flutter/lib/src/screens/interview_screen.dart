/// =============================================================================
/// Interview Screen — Question & Answer Interface
/// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/providers.dart';
import '../models/models.dart';

class InterviewScreen extends ConsumerStatefulWidget {
  final String? category;
  final int questionCount;

  const InterviewScreen({
    super.key,
    this.category,
    this.questionCount = 10,
  });

  @override
  ConsumerState<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends ConsumerState<InterviewScreen> {
  DateTime? _questionStartTime;
  int _currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    _questionStartTime = DateTime.now();
    
    // Start session on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(currentSessionProvider.notifier).startSession(
        category: widget.category ?? '',
        questionCount: widget.questionCount,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(currentSessionProvider);
    final stats = ref.watch(sessionStatsProvider);

    if (session == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Check if session is complete
    if (session.isComplete) {
      return _buildResultsScreen(session, stats);
    }

    if (_currentQuestionIndex >= session.questions.length) {
      ref.read(currentSessionProvider.notifier).completeSession();
      return _buildResultsScreen(session, stats);
    }

    final question = session.questions[_currentQuestionIndex];
    final hasAnswered = session.answers.containsKey(question.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentQuestionIndex + 1} of ${session.questions.length}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flag),
            onPressed: () => _flagQuestion(context),
            tooltip: 'Flag for review',
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / session.questions.length,
          ),

          // Stats Bar
          _buildStatsBar(stats),

          // Question Card
          Expanded(
            child: _buildQuestionCard(question, hasAnswered, session),
          ),

          // Navigation Buttons
          _buildNavigationButtons(hasAnswered, session),
        ],
      ),
    );
  }

  Widget _buildStatsBar(SessionStats? stats) {
    if (stats == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Score: ${stats.score}%'),
          Text('Time: ${_formatDuration(stats.timeElapsed)}'),
          Text('Correct: ${stats.correctAnswers}/${stats.answeredQuestions}'),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(Question question, bool hasAnswered, InterviewSession session) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // NEC Reference Chip
          Row(
            children: [
              Chip(
                label: Text(question.necReference),
                avatar: const Icon(Icons.book, size: 16),
              ),
              const SizedBox(width: 8),
              Chip(
                label: Text(question.difficulty.name),
                backgroundColor: _getDifficultyColor(question.difficulty).withOpacity(0.2),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Question Text
          Text(
            question.text,
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const SizedBox(height: 24),

          // Answer Options
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            return _buildOptionTile(
              question: question,
              option: option,
              index: index,
              hasAnswered: hasAnswered,
              session: session,
            );
          }),

          // Explanation (shown after answering)
          if (hasAnswered) ...[
            const SizedBox(height: 16),
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          session.answers[question.id]!.isCorrect
                              ? Icons.check_circle
                              : Icons.error,
                          color: session.answers[question.id]!.isCorrect
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          session.answers[question.id]!.isCorrect
                              ? 'Correct!'
                              : 'Incorrect',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(question.explanation),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required Question question,
    required String option,
    required int index,
    required bool hasAnswered,
    required InterviewSession session,
  }) {
    final userAnswer = session.answers[question.id];
    final isSelected = userAnswer?.selectedIndex == index;
    final isCorrect = index == question.correctIndex;

    Color? tileColor;
    IconData? icon;

    if (hasAnswered) {
      if (isCorrect) {
        tileColor = Colors.green[100];
        icon = Icons.check_circle;
      } else if (isSelected && !isCorrect) {
        tileColor = Colors.red[100];
        icon = Icons.error;
      }
    }

    return Card(
      color: tileColor,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(
          icon ?? Icons.radio_button_unchecked,
          color: icon == Icons.check_circle
              ? Colors.green
              : icon == Icons.error
                  ? Colors.red
                  : null,
        ),
        title: Text(option),
        onTap: hasAnswered ? null : () => _selectAnswer(question, index),
      ),
    );
  }

  Widget _buildNavigationButtons(bool hasAnswered, InterviewSession session) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentQuestionIndex > 0)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _previousQuestion(),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Previous'),
              ),
            ),
          if (_currentQuestionIndex > 0) const SizedBox(width: 8),
          Expanded(
            flex: _currentQuestionIndex > 0 ? 1 : 2,
            child: ElevatedButton.icon(
              onPressed: hasAnswered ? () => _nextQuestion(session) : null,
              icon: Icon(_currentQuestionIndex == session.questions.length - 1
                  ? Icons.check
                  : Icons.arrow_forward),
              label: Text(_currentQuestionIndex == session.questions.length - 1
                  ? 'Finish'
                  : 'Next'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsScreen(InterviewSession session, SessionStats? stats) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Score Circle
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (stats?.isPassing ?? false) ? Colors.green[100] : Colors.red[100],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${stats?.score ?? 0}%',
                    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stats?.isPassing ?? false ? 'PASSED' : 'NEEDS PRACTICE',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Stats Grid
            Row(
              children: [
                Expanded(child: _buildResultStat('Correct', '${stats?.correctAnswers}')),
                Expanded(child: _buildResultStat('Total', '${stats?.totalQuestions}')),
                Expanded(child: _buildResultStat('Time', _formatDuration(stats?.timeElapsed))),
              ],
            ),

            const SizedBox(height: 32),

            // Actions
            ElevatedButton.icon(
              onPressed: () {
                ref.read(currentSessionProvider.notifier).reset();
                context.go('/');
              },
              icon: const Icon(Icons.home),
              label: const Text('Back to Home'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),

            const SizedBox(height: 16),

            OutlinedButton.icon(
              onPressed: () {
                ref.read(currentSessionProvider.notifier).reset();
                context.go('/interview?count=${widget.questionCount}');
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultStat(String label, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(label, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  void _selectAnswer(Question question, int index) {
    if (_questionStartTime == null) return;

    final timeSpent = DateTime.now().difference(_questionStartTime!);
    
    ref.read(currentSessionProvider.notifier).submitAnswer(
      _currentQuestionIndex,
      index,
      timeSpent,
    );

    // Record performance
    final isCorrect = index == question.correctIndex;
    ref.read(performanceMetricsProvider.notifier).recordAnswer(
      question.category,
      isCorrect,
      timeSpent,
    );
  }

  void _nextQuestion(InterviewSession session) {
    if (_currentQuestionIndex < session.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _questionStartTime = DateTime.now();
      });
    } else {
      ref.read(currentSessionProvider.notifier).completeSession();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _questionStartTime = DateTime.now();
      });
    }
  }

  void _flagQuestion(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Question flagged for review')),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  Color _getDifficultyColor(DifficultyLevel difficulty) {
    switch (difficulty) {
      case DifficultyLevel.beginner:
        return Colors.green;
      case DifficultyLevel.intermediate:
        return Colors.blue;
      case DifficultyLevel.advanced:
        return Colors.orange;
      case DifficultyLevel.expert:
        return Colors.red;
    }
  }
}
