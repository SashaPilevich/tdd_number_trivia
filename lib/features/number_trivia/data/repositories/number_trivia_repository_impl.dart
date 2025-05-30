import 'package:dartz/dartz.dart';
import 'package:tdd_number_trivia/core/error/exception.dart';
import 'package:tdd_number_trivia/features/number_trivia/data/data_sources/remote/number_trivia_api_provider.dart';
import 'package:tdd_number_trivia/features/number_trivia/data/mappers/number_trivia_mapper.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/platform/network_info.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';
import '../data_sources/local/number_trivia_local_data_source.dart';
import '../models/number_trivia_model.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaApiProvider _remoteDataSource;
  final NumberTriviaLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  NumberTriviaRepositoryImpl({
    required NumberTriviaApiProvider remoteDataSource,
    required NumberTriviaLocalDataSource localDataSource,
    required NetworkInfo networkInfo,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(
    int number,
  ) async {
    final bool isConnected = await _networkInfo.isConnected;
    if (isConnected) {
      try {
        final NumberTriviaModel numberTriviaModel = await _remoteDataSource
            .getConcreteNumberTrivia(number);
        _localDataSource.cacheNumberTrivia(numberTriviaModel);
        return Right(NumberTriviaMapper.toEntity(numberTriviaModel));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final NumberTriviaModel localTrivia = await _localDataSource
            .getLastNumberTrivia();
        return Right(NumberTriviaMapper.toEntity(localTrivia));
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {}
}
