import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tdd_number_trivia/core/platform/network_info.dart';
import 'package:tdd_number_trivia/features/number_trivia/data/data_sources/local/number_trivia_local_data_source.dart';
import 'package:tdd_number_trivia/features/number_trivia/data/data_sources/remote/number_trivia_api_provider.dart';
import 'package:tdd_number_trivia/features/number_trivia/data/mappers/number_trivia_mapper.dart';
import 'package:tdd_number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:tdd_number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:tdd_number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

@GenerateNiceMocks([
  MockSpec<NumberTriviaApiProvider>(),
  MockSpec<NumberTriviaLocalDataSource>(),
  MockSpec<NetworkInfo>(),
])
import 'number_trivia_repository_impl_test.mocks.dart';

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaApiProvider mockRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockNumberTriviaApiProvider();
    mockLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getConcreteNumberTrivia', () {
    final int tNumber = 1;
    final NumberTriviaModel tNumberTriviaModel = NumberTriviaModel(
      number: tNumber,
      text: 'test trivia',
    );
    final NumberTrivia tNumberTrivia = NumberTriviaMapper.toEntity(
      tNumberTriviaModel,
    );

    test('should check if the device is online', () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      repository.getConcreteNumberTrivia(tNumber);
      verify(mockNetworkInfo.isConnected);
    });
  });

  group('device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        when(
          mockRemoteDataSource.getConcreteNumberTrivia(tNumber),
        ).thenAnswer((_) async => tNumberTriviaModel);
        final result = await repository.getConcreteNumberTrivia(tNumber);
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      },
    );
  });
}
