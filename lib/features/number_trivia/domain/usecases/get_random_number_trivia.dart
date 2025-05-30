import 'package:dartz/dartz.dart';
import 'package:tdd_number_trivia/core/usecase/usecase.dart';
import 'package:tdd_number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository _repository;

  GetRandomNumberTrivia({required NumberTriviaRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, NumberTrivia>> call(NoParams params) async {
    return await _repository.getRandomNumberTrivia();
  }
}
