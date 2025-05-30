import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_number_trivia/core/error/failures.dart';
import 'package:tdd_number_trivia/core/usecase/usecase.dart';
import 'package:tdd_number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository _repository;

  GetConcreteNumberTrivia({required NumberTriviaRepository repository})
    : _repository = repository;

  @override
  Future<Either<Failure, NumberTrivia>> call(Params params) async {
    return _repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
