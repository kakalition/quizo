import 'package:freezed_annotation/freezed_annotation.dart';

part 'question.freezed.dart';

@freezed
class Question with _$Question {
  const factory Question({
    required int index,
    required String question,
    required Map<String, String> answers,
    required String correctAnswer,
  }) = _Question;
}
