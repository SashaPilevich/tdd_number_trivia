import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tdd_number_trivia/core/error/failures.dart';
import 'package:tdd_number_trivia/core/usecase/usecase.dart';
import 'package:tdd_number_trivia/core/util/input_converter.dart';
import 'package:tdd_number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:tdd_number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:tdd_number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:tdd_number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetConcreteNumberTrivia>(),
  MockSpec<GetRandomNumberTrivia>(),
  MockSpec<InputConverter>(),
])
void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
      getConcreteNumberTrivia: mockGetConcreteNumberTrivia,
      getRandomNumberTrivia: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    final String tNumberString = '1';
    final int tNumberParsed = int.parse(tNumberString);
    final NumberTrivia tNumberTrivia = NumberTrivia(
      number: 1,
      text: 'test trivia',
    );

    void setUpMockInputConverterSuccess() => when(
      mockInputConverter.stringToUnsignedInteger(any),
    ).thenReturn(Right(tNumberParsed));

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should call the InputConverter to validate and convert the string to an unsigned integer',
      build: () => bloc,
      setUp: () {
        setUpMockInputConverterSuccess();
        when(
          mockGetConcreteNumberTrivia(any),
        ).thenAnswer((_) async => Right(tNumberTrivia));
      },
      act: (bloc) {
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => <NumberTriviaState>[
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
      verify: (_) =>
          verify(mockInputConverter.stringToUnsignedInteger(tNumberString)),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Error] when the input is invalid',
      build: () => bloc,
      setUp: () {
        setUpMockInputConverterSuccess();
        when(
          mockInputConverter.stringToUnsignedInteger(any),
        ).thenReturn(Left(InvalidInputFailure()));
      },
      act: (bloc) {
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => <NumberTriviaState>[
        Error(message: INVALID_INPUT_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should get data from the concrete use case',
      build: () => bloc,
      setUp: () {
        setUpMockInputConverterSuccess();
        when(
          mockGetConcreteNumberTrivia(any),
        ).thenAnswer((_) async => Right(tNumberTrivia));
      },
      act: (bloc) {
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => <NumberTriviaState>[
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
      verify: (_) =>
          verify(mockGetConcreteNumberTrivia(Params(number: tNumberParsed))),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () => bloc,
      setUp: () {
        setUpMockInputConverterSuccess();
        when(
          mockGetConcreteNumberTrivia(any),
        ).thenAnswer((_) async => Right(tNumberTrivia));
      },
      act: (bloc) {
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => <NumberTriviaState>[
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data fails',
      build: () => bloc,
      setUp: () {
        setUpMockInputConverterSuccess();
        when(
          mockGetConcreteNumberTrivia(any),
        ).thenAnswer((_) async => Left(ServerFailure()));
      },
      act: (bloc) {
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => <NumberTriviaState>[
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () => bloc,
      setUp: () {
        setUpMockInputConverterSuccess();
        when(
          mockGetConcreteNumberTrivia(any),
        ).thenAnswer((_) async => Left(CacheFailure()));
      },
      act: (bloc) {
        bloc.add(GetTriviaForConcreteNumber(tNumberString));
      },
      expect: () => <NumberTriviaState>[
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });

  group('GetTriviaForRandomNumber', () {
    final tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should get data from the random use case',
      build: () => bloc,
      setUp: () {
        when(
          mockGetRandomNumberTrivia(any),
        ).thenAnswer((_) async => Right(tNumberTrivia));
      },
      act: (bloc) {
        bloc.add(GetTriviaForRandomNumber());
      },
      expect: () => <NumberTriviaState>[
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
      verify: (_) => verify(mockGetRandomNumberTrivia(NoParams())),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Loaded] when data is gotten successfully',
      build: () => bloc,
      setUp: () {
        when(
          mockGetRandomNumberTrivia(any),
        ).thenAnswer((_) async => Right(tNumberTrivia));
      },
      act: (bloc) {
        bloc.add(GetTriviaForRandomNumber());
      },
      expect: () => <NumberTriviaState>[
        Loading(),
        Loaded(trivia: tNumberTrivia),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] when getting data fails',
      build: () => bloc,
      setUp: () {
        when(
          mockGetRandomNumberTrivia(any),
        ).thenAnswer((_) async => Left(ServerFailure()));
      },
      act: (bloc) {
        bloc.add(GetTriviaForRandomNumber());
      },
      expect: () => <NumberTriviaState>[
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE),
      ],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      build: () => bloc,
      setUp: () {
        when(
          mockGetRandomNumberTrivia(any),
        ).thenAnswer((_) async => Left(CacheFailure()));
      },
      act: (bloc) {
        bloc.add(GetTriviaForRandomNumber());
      },
      expect: () => <NumberTriviaState>[
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE),
      ],
    );
  });
}
