import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_number_trivia/core/error/failures.dart';
import 'package:tdd_number_trivia/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('stringToUnsignedInt', () {
    test(
      'should return an integer when the string represents an unsigned integer',
      () async {
        final String str = '123';
        final Either<Failure, int> result = inputConverter
            .stringToUnsignedInteger(str);
        expect(result, Right(123));
      },
    );

    test('should return a failure when the string is not an integer', () async {
      final String str = 'abc';
      final Either<Failure, int> result = inputConverter
          .stringToUnsignedInteger(str);
      expect(result, Left(InvalidInputFailure()));
    });

    test(
      'should return a failure when the string is a negative integer',
      () async {
        final String str = '-123';
        final Either<Failure, int> result = inputConverter
            .stringToUnsignedInteger(str);
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
