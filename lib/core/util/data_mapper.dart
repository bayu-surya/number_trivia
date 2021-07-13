import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class DataMapper {

  NumberTriviaModel modelToEntitie(NumberTrivia data) {
    return NumberTriviaModel(
      number: data.number,
      text: data.text,
    );
  }
}