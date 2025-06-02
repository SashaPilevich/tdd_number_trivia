import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:tdd_number_trivia/core/usecase/usecase.dart';
import 'package:tdd_number_trivia/core/util/input_converter.dart';
import 'package:tdd_number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/number_trivia.dart';

part 'number_trivia_event.dart';

part 'number_trivia_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE =
    'Invalid Input - The number must be a positive integer or zero.';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia _getConcreteNumberTrivia;
  final GetRandomNumberTrivia _getRandomNumberTrivia;
  final InputConverter _inputConverter;

  NumberTriviaBloc({
    required GetConcreteNumberTrivia getConcreteNumberTrivia,
    required GetRandomNumberTrivia getRandomNumberTrivia,
    required InputConverter inputConverter,
  }) : _getConcreteNumberTrivia = getConcreteNumberTrivia,
       _getRandomNumberTrivia = getRandomNumberTrivia,
       _inputConverter = inputConverter,
       super(Empty()) {
    on<GetTriviaForConcreteNumber>(_onGetTriviaForConcreteNumber);
    on<GetTriviaForRandomNumber>(_onGetTriviaForRandomNumber);
  }

  Future<void> _onGetTriviaForConcreteNumber(
    GetTriviaForConcreteNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    final Either<Failure, int> inputEither = _inputConverter
        .stringToUnsignedInteger(event.numberString);
    await inputEither.fold(
      (failure) {
        emit(Error(message: INVALID_INPUT_FAILURE_MESSAGE));
      },
      (integer) async {
        emit(Loading());
        final Either<Failure, NumberTrivia> failureOrTrivia =
            await _getConcreteNumberTrivia.call(Params(number: integer));
        await _eitherLoadedOrErrorState(failureOrTrivia, emit);
      },
    );
  }

  Future<void> _onGetTriviaForRandomNumber(
    GetTriviaForRandomNumber event,
    Emitter<NumberTriviaState> emit,
  ) async {
    emit(Loading());
    final Either<Failure, NumberTrivia> failureOrTrivia =
        await _getRandomNumberTrivia.call(NoParams());
    await _eitherLoadedOrErrorState(failureOrTrivia, emit);
  }

  Future<void> _eitherLoadedOrErrorState(
    Either<Failure, NumberTrivia> either,
    Emitter<NumberTriviaState> emit,
  ) async {
    return await either.fold(
      (failure) => emit(Error(message: _mapFailureToMessage(failure))),
      (trivia) => emit(Loaded(trivia: trivia)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error';
    }
  }
}
