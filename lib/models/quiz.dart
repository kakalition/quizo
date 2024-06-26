import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:quizo/models/question.dart';

part 'quiz.freezed.dart';

@freezed
class Quiz with _$Quiz {
  const factory Quiz({
    required String uuid,
    required String appUuid,
    required String menuUuid,
    required List<Question> questions,
  }) = _Quiz;
}
