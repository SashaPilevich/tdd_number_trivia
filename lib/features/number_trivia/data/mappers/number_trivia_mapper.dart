import '../../domain/entities/number_trivia.dart';
import '../models/number_trivia_model.dart';

abstract class NumberTriviaMapper {
  static NumberTrivia toEntity(NumberTriviaModel model) {
    return NumberTrivia(text: model.text, number: model.number);
  }

  static NumberTriviaModel toModel(NumberTrivia entity) {
    return NumberTriviaModel(text: entity.text, number: entity.number);
  }
}
