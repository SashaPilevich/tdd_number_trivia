import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';

import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/number_trivia/data/data_sources/local/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/data_sources/remote/number_trivia_remote_data_source.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

final GetIt appLocator = GetIt.instance;

Future<void> init() async {
  //Bloc
  appLocator.registerFactory(
    () => NumberTriviaBloc(
      getConcreteNumberTrivia: appLocator<GetConcreteNumberTrivia>(),
      getRandomNumberTrivia: appLocator<GetRandomNumberTrivia>(),
      inputConverter: appLocator<InputConverter>(),
    ),
  );

  //Use cases
  appLocator.registerLazySingleton<GetConcreteNumberTrivia>(
    () => GetConcreteNumberTrivia(
      repository: appLocator<NumberTriviaRepository>(),
    ),
  );
  appLocator.registerLazySingleton<GetRandomNumberTrivia>(
    () =>
        GetRandomNumberTrivia(repository: appLocator<NumberTriviaRepository>()),
  );

  //Repository
  appLocator.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      remoteDataSource: appLocator<NumberTriviaRemoteDataSource>(),
      localDataSource: appLocator<NumberTriviaLocalDataSource>(),
      networkInfo: appLocator<NetworkInfo>(),
    ),
  );

  //Data sources
  appLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(
    () => NumberTriviaRemoteDataSourceImpl(client: appLocator<http.Client>()),
  );
  appLocator.registerLazySingleton<NumberTriviaLocalDataSource>(
    () => NumberTriviaLocalDataSourceImpl(
      sharedPreferences: appLocator<SharedPreferences>(),
    ),
  );

  //Core
  appLocator.registerLazySingleton<InputConverter>(() => InputConverter());

  appLocator.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(appLocator<InternetConnectionChecker>()),
  );

  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  appLocator.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  appLocator.registerLazySingleton<http.Client>(() => http.Client());
  appLocator.registerLazySingleton<InternetConnectionChecker>(
    () => InternetConnectionChecker.instance,
  );
}
