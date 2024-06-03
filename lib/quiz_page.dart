import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizo/constants.dart';
import 'package:quizo/models/menu_path.dart';
import 'package:quizo/models/question.dart';
import 'package:quizo/models/quiz.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({
    super.key,
    required this.menuPath,
  });

  final MenuPath menuPath;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final player = AudioPlayer();

  var currentIndex = 0;
  int currentAnswer = 0;

  Quiz quiz = const Quiz(uuid: '', appUuid: '', menuUuid: '', questions: []);

  final userAnswer = <int, int>{};

  Future<Quiz> fetchQuiz() async {
    final url =
        '$BASE_URL/applications/$APPLICATION_UUID/menus/${widget.menuPath.uuid}/quiz';
    final response = await Dio().get(url);

    final data = response.data;

    final quiz = Quiz(
      uuid: data['uuid'],
      appUuid: data['appUuid'],
      menuUuid: data['menuUuid'],
      questions: (data['quiz'] as List<dynamic>).map((e) {
        return Question(
          index: e['index'],
          uuid: e['uuid'],
          question: e['question'],
          answers:
              (e['answers'] as List<dynamic>).map((f) => f.toString()).toList(),
          correctAnswer: e['correctAnswer'],
          explanation: 'TODO',
        );
      }).toList(),
    );

    return quiz;
  }

  @override
  void initState() {
    super.initState();

    fetchQuiz().then(
      (value) {
        setState(() {
          quiz = value;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.menuPath.name,
          style: GoogleFonts.robotoFlex(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (quiz.questions.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('Soal tidak ditemukan.'),
                ),
              )
            else
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.filled(quiz.questions.length, 0)
                          .asMap()
                          .keys
                          .map((index) {
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                color: index <= currentIndex
                                    ? Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                        .withOpacity(0.9)
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                        .withOpacity(0.3),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Pertanyaan ${currentIndex + 1}/${quiz.questions.length}',
                      style: GoogleFonts.robotoFlex(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.8),
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      quiz.questions[currentIndex].question,
                      style: GoogleFonts.robotoFlex(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 32,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ...quiz.questions[currentIndex].answers
                        .asMap()
                        .keys
                        .map((answerIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Builder(builder: (context) {
                          var color = Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.05);

                          if (userAnswer.containsKey(currentIndex) &&
                              answerIndex ==
                                  quiz.questions[currentIndex].correctAnswer) {
                            color = Colors.greenAccent[100]!;
                          }

                          if (userAnswer.containsKey(currentIndex) &&
                              answerIndex == currentAnswer &&
                              answerIndex !=
                                  quiz.questions[currentIndex].correctAnswer) {
                            color = Colors.redAccent[100]!;
                          }

                          var borderColor = Colors.transparent;

                          if (!userAnswer.containsKey(currentIndex) &&
                              answerIndex == currentAnswer) {
                            borderColor = Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant
                                .withOpacity(0.3);
                          }

                          return Material(
                            color: color,
                            borderRadius: BorderRadius.circular(8),
                            child: InkWell(
                              onTap: () {
                                if (!userAnswer.containsKey(currentIndex)) {
                                  setState(() {
                                    currentAnswer = answerIndex;
                                  });
                                }
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2,
                                    color: borderColor,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: SizedBox(
                                    width: double.maxFinite,
                                    child: Text(
                                      quiz.questions[currentIndex]
                                          .answers[answerIndex],
                                      style: GoogleFonts.robotoFlex(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.8),
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    }),
                    Opacity(
                      opacity: (userAnswer[currentIndex] == null ||
                              userAnswer[currentIndex] ==
                                  quiz.questions[currentIndex].correctAnswer)
                          ? 0
                          : 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Divider(
                            thickness: 0.5,
                            height: 36,
                          ),
                          Text(
                            "Penjelasan: ${quiz.questions[currentIndex].explanation}",
                            style: GoogleFonts.robotoFlex(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    FilledButton(
                      onPressed: () async {
                        if (userAnswer.containsKey(currentIndex)) {
                          setState(() {
                            currentIndex += 1;
                            currentAnswer = 0;
                          });

                          return;
                        }

                        setState(() {
                          userAnswer[currentIndex] = currentAnswer;
                        });

                        if (currentAnswer ==
                            quiz.questions[currentIndex].correctAnswer) {
                          await player.play(AssetSource('correct.wav'));
                        } else {
                          await player.play(AssetSource('incorrect.wav'));
                        }
                      },
                      child: SizedBox(
                        width: double.maxFinite,
                        child: Center(
                          child: Text(
                            userAnswer.containsKey(currentIndex)
                                ? 'Lanjut'
                                : 'Jawab',
                            style: GoogleFonts.robotoFlex(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
