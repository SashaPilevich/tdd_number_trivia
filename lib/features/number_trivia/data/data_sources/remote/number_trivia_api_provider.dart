import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:tdd_number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

part 'number_trivia_api_provider.g.dart';

@RestApi()
abstract class NumberTriviaApiProvider {
  factory NumberTriviaApiProvider(Dio dio, {String? baseUrl}) =
      _NumberTriviaApiProvider;

  @GET('')
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  @GET('')
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
