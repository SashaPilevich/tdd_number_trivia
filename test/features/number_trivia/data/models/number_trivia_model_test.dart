import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final NumberTriviaModel tNumberTriviaModel = NumberTriviaModel(
    number: 1,
    text: 'Test Text',
  );

  group('fromJson', () {
    test(
      'should return a valid model when the JSON number is an integer',
      () async {
        final Map<String, dynamic> jsonMap = json.decode(
          fixture('trivia.json'),
        );
        final NumberTriviaModel result = NumberTriviaModel.fromJson(jsonMap);
        expect(result, tNumberTriviaModel);
      },
    );

    test(
      'should return a valid model when the JSON number is regarded as a double',
      () async {
        final Map<String, dynamic> jsonMap = json.decode(
          fixture('trivia_double.json'),
        );
        final NumberTriviaModel result = NumberTriviaModel.fromJson(jsonMap);
        expect(result, tNumberTriviaModel);
      },
    );
  });

  group('toJson', () {
    test('should return a JSON map containing the proper data', () async {
      final Map<String, dynamic> result = tNumberTriviaModel.toJson();

      final Map<String, dynamic> expectedJsonMap = {
        "text": "Test Text",
        "number": 1,
      };

      expect(result, expectedJsonMap);
    });
  });
}
