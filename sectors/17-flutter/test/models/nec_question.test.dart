/// =============================================================================
/// NEC Question Model Tests
/// Test-driven development for NEC 2026 compliance
/// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:imperial_app/src/models/models.dart';

void main() {
  group('NECQuestion', () {
    // =======================================================================
    // Constructor Tests
    // =======================================================================

    test('should create valid NECQuestion with required fields', () {
      // Arrange
      const question = NECQuestion(
        id: 'q001',
        codeSection: 'Article 250.64',
        questionText: 'What is the minimum size for a grounding electrode conductor?',
        options: ['8 AWG', '6 AWG', '4 AWG', '2 AWG'],
        correctIndex: 1,
        rationale: 'NEC 250.64(A) requires minimum 6 AWG for grounding electrode conductors.',
      );

      // Assert
      expect(question.id, 'q001');
      expect(question.codeSection, 'Article 250.64');
      expect(question.questionText, contains('grounding electrode conductor'));
      expect(question.options.length, 4);
      expect(question.correctIndex, 1);
      expect(question.rationale, contains('NEC 250.64'));
    });

    test('should throw AssertionError with empty id', () {
      // Act & Assert
      expect(
        () => const NECQuestion(
          id: '',
          codeSection: 'Article 250.64',
          questionText: 'Test question',
          options: ['A', 'B'],
          correctIndex: 0,
          rationale: 'Test rationale',
        ),
        throwsAssertionError,
      );
    });

    test('should throw AssertionError with empty options', () {
      // Act & Assert
      expect(
        () => const NECQuestion(
          id: 'q001',
          codeSection: 'Article 250.64',
          questionText: 'Test question',
          options: [],
          correctIndex: 0,
          rationale: 'Test rationale',
        ),
        throwsAssertionError,
      );
    });

    test('should throw AssertionError with correctIndex out of bounds', () {
      // Act & Assert
      expect(
        () => const NECQuestion(
          id: 'q001',
          codeSection: 'Article 250.64',
          questionText: 'Test question',
          options: ['A', 'B', 'C'],
          correctIndex: 5, // Out of bounds
          rationale: 'Test rationale',
        ),
        throwsAssertionError,
      );
    });

    // =======================================================================
    // fromMap Factory Tests
    // =======================================================================

    test('should create NECQuestion from valid Map', () {
      // Arrange
      final map = {
        'id': 'q002',
        'section': 'Article 210.19',
        'text': 'What is the minimum conductor size for a 20A circuit?',
        'options': ['14 AWG', '12 AWG', '10 AWG'],
        'correctIndex': 1,
        'rationale': 'NEC 210.19 requires 12 AWG for 20A circuits.',
      };

      // Act
      final question = NECQuestion.fromMap(map);

      // Assert
      expect(question.id, 'q002');
      expect(question.codeSection, 'Article 210.19');
      expect(question.questionText, map['text']);
      expect(question.options.length, 3);
      expect(question.correctIndex, 1);
    });

    test('should handle Map with missing optional fields', () {
      // Arrange
      final map = {
        'id': 'q003',
        'section': 'Article 110.26',
        'text': 'Working space requirements?',
        'options': ['3 ft', '4 ft'],
        'correctIndex': 0,
        'rationale': 'NEC 110.26 specifies working space.',
      };

      // Act
      final question = NECQuestion.fromMap(map);

      // Assert
      expect(question.id, 'q003');
      expect(question.codeSection, 'Article 110.26');
    });

    // =======================================================================
    // toMap Method Tests
    // =======================================================================

    test('should convert NECQuestion to Map with correct keys', () {
      // Arrange
      const question = NECQuestion(
        id: 'q004',
        codeSection: 'Article 240.4',
        questionText: 'Overcurrent protection rules?',
        options: ['Option A', 'Option B'],
        correctIndex: 0,
        rationale: 'NEC 240.4 covers overcurrent protection.',
      );

      // Act
      final map = question.toMap();

      // Assert
      expect(map['id'], 'q004');
      expect(map['section'], 'Article 240.4');
      expect(map['text'], question.questionText);
      expect(map['options'], question.options);
      expect(map['correctIndex'], 0);
      expect(map['rationale'], question.rationale);
    });

    // =======================================================================
    // Equatable Tests (Value Equality)
    // =======================================================================

    test('should be equal when all fields match', () {
      // Arrange
      const q1 = NECQuestion(
        id: 'q005',
        codeSection: 'Article 250.64',
        questionText: 'Test question',
        options: ['A', 'B'],
        correctIndex: 0,
        rationale: 'Test rationale',
      );

      const q2 = NECQuestion(
        id: 'q005',
        codeSection: 'Article 250.64',
        questionText: 'Test question',
        options: ['A', 'B'],
        correctIndex: 0,
        rationale: 'Test rationale',
      );

      // Assert
      expect(q1, equals(q2));
      expect(q1.hashCode, equals(q2.hashCode));
    });

    test('should not be equal when any field differs', () {
      // Arrange
      const q1 = NECQuestion(
        id: 'q005',
        codeSection: 'Article 250.64',
        questionText: 'Test question',
        options: ['A', 'B'],
        correctIndex: 0,
        rationale: 'Test rationale',
      );

      const q2 = NECQuestion(
        id: 'q006', // Different ID
        codeSection: 'Article 250.64',
        questionText: 'Test question',
        options: ['A', 'B'],
        correctIndex: 0,
        rationale: 'Test rationale',
      );

      // Assert
      expect(q1, isNot(equals(q2)));
    });

    // =======================================================================
    // Edge Case Tests (Brittany Hayes Special)
    // =======================================================================

    test('should handle very long question text', () {
      // Arrange
      final longText = 'A' * 10000; // 10,000 character question
      const question = NECQuestion(
        id: 'q006',
        codeSection: 'Article 250.64',
        questionText: longText,
        options: ['A', 'B'],
        correctIndex: 0,
        rationale: 'Test rationale',
      );

      // Assert
      expect(question.questionText.length, 10000);
      expect(question.toMap()['text'].length, 10000);
    });

    test('should handle Unicode characters in question text', () {
      // Arrange
      const question = NECQuestion(
        id: 'q007',
        codeSection: 'Article 250.64',
        questionText: 'What is Ω (omega) in electrical terms?',
        options: ['Resistance', 'Current', 'Voltage', 'Power'],
        correctIndex: 0,
        rationale: 'Ω represents resistance in ohms.',
      );

      // Assert
      expect(question.questionText, contains('Ω'));
      expect(question.toMap()['text'], contains('Ω'));
    });

    test('should handle special characters in rationale', () {
      // Arrange
      const question = NECQuestion(
        id: 'q008',
        codeSection: 'Article 250.64',
        questionText: 'Test question',
        options: ['A', 'B'],
        correctIndex: 0,
        rationale: 'NEC 250.64(A) states: "Grounding conductors shall be..." <>&"',
      );

      // Assert
      expect(question.rationale, contains('<>&"'));
      expect(question.toMap()['rationale'], contains('<>&"'));
    });

    test('should handle null-safe conversion from Question', () {
      // Arrange
      const baseQuestion = Question(
        id: 'q009',
        text: 'Test question',
        category: 'NEC',
        necReference: 'Article 250.64',
        necYear: 2023,
        options: ['A', 'B'],
        correctIndex: 0,
        explanation: 'Test explanation',
        difficulty: DifficultyLevel.intermediate,
      );

      // Act
      final necQuestion = NECQuestion(
        id: baseQuestion.id,
        codeSection: baseQuestion.necReference,
        questionText: baseQuestion.text,
        options: baseQuestion.options,
        correctIndex: baseQuestion.correctIndex,
        rationale: baseQuestion.explanation,
      );

      // Assert
      expect(necQuestion.id, baseQuestion.id);
      expect(necQuestion.codeSection, baseQuestion.necReference);
      expect(necQuestion.questionText, baseQuestion.text);
    });
  });

  // =======================================================================
  // Question Model Tests (Extended Metadata)
  // =======================================================================

  group('Question', () {
    test('should create valid Question with all fields', () {
      // Arrange
      const question = Question(
        id: 'q010',
        text: 'NEC 2026 compliance question?',
        category: 'Article 250',
        necReference: '250.64(A)',
        necYear: 2023,
        options: ['Option A', 'Option B', 'Option C'],
        correctIndex: 2,
        explanation: 'Detailed explanation of NEC 250.64(A)',
        difficulty: DifficultyLevel.advanced,
        isRequired: true,
        tags: ['grounding', 'bonding', 'safety'],
      );

      // Assert
      expect(question.id, 'q010');
      expect(question.category, 'Article 250');
      expect(question.necYear, 2023);
      expect(question.difficulty, DifficultyLevel.advanced);
      expect(question.tags.length, 3);
      expect(question.isRequired, true);
    });

    test('should default isRequired to true', () {
      // Arrange
      const question = Question(
        id: 'q011',
        text: 'Test question',
        category: 'NEC',
        necReference: 'Article 250',
        necYear: 2023,
        options: ['A', 'B'],
        correctIndex: 0,
        explanation: 'Test explanation',
        difficulty: DifficultyLevel.beginner,
      );

      // Assert
      expect(question.isRequired, true);
    });

    test('should default tags to empty list', () {
      // Arrange
      const question = Question(
        id: 'q012',
        text: 'Test question',
        category: 'NEC',
        necReference: 'Article 250',
        necYear: 2023,
        options: ['A', 'B'],
        correctIndex: 0,
        explanation: 'Test explanation',
        difficulty: DifficultyLevel.beginner,
      );

      // Assert
      expect(question.tags, isEmpty);
    });

    test('fromJson should handle missing optional fields', () {
      // Arrange
      final json = {
        'id': 'q013',
        'text': 'Test question',
        'category': 'NEC',
        'nec_reference': 'Article 250',
        'nec_year': 2023,
        'options': ['A', 'B'],
        'correct_index': 0,
        'explanation': 'Test explanation',
        'difficulty': 'beginner',
        // Missing: is_required, tags
      };

      // Act
      final question = Question.fromJson(json);

      // Assert
      expect(question.isRequired, true); // Default
      expect(question.tags, isEmpty); // Default
    });

    test('copyWith should create new instance with updated fields', () {
      // Arrange
      const original = Question(
        id: 'q014',
        text: 'Original question',
        category: 'NEC',
        necReference: 'Article 250',
        necYear: 2023,
        options: ['A', 'B'],
        correctIndex: 0,
        explanation: 'Original explanation',
        difficulty: DifficultyLevel.beginner,
      );

      // Act
      final updated = original.copyWith(
        text: 'Updated question',
        difficulty: DifficultyLevel.advanced,
      );

      // Assert
      expect(updated.id, original.id); // Unchanged
      expect(updated.text, 'Updated question'); // Changed
      expect(updated.difficulty, DifficultyLevel.advanced); // Changed
      expect(updated.category, original.category); // Unchanged
    });
  });

  // =======================================================================
  // DifficultyLevel Enum Tests
  // =======================================================================

  group('DifficultyLevel', () {
    test('should have correct number of levels', () {
      expect(DifficultyLevel.values.length, 4);
    });

    test('should parse from string correctly', () {
      // Assert
      expect(DifficultyLevel.values.byName('beginner'), DifficultyLevel.beginner);
      expect(DifficultyLevel.values.byName('intermediate'), DifficultyLevel.intermediate);
      expect(DifficultyLevel.values.byName('advanced'), DifficultyLevel.advanced);
      expect(DifficultyLevel.values.byName('expert'), DifficultyLevel.expert);
    });
  });
}
