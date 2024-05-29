import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quizo/models/question.dart';
import 'package:quizo/models/quiz.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({
    super.key,
    required this.uuid,
    required this.title,
  });

  final String uuid;
  final String title;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final player = AudioPlayer();

  var currentIndex = 0;
  var currentAnswer = '';

  final quiz = const Quiz(
    targetUuid: '',
    questions: [
      Question(
        index: 0,
        question: 'Organ utama tempat pencernaan makanan berlangsung adalah...',
        answers: ['Mulut', 'Kerongkongan', 'Lambung', 'Usus halus'],
        correctAnswer: 'Lambung',
        explanation: 'Yang benar lambung',
      ),
      Question(
        index: 1,
        question:
            'Enzim yang berperan dalam pencernaan protein di lambung adalah...',
        answers: ['Amilase', 'Peptin', 'Lipase', 'Maltase'],
        correctAnswer: 'Pepsin',
        explanation: 'Yang benar pepsin',
      ),
      Question(
        index: 2,
        question: 'Fungsi utama usus halus dalam sistem pencernaan adalah...',
        answers: [
          'Mengunyah makanan',
          'Menyerap nutrisi',
          'Menghancurkan lemak',
          'Menyimpan makanan'
        ],
        correctAnswer: 'Menyerap nutrisi',
        explanation: 'Yang benar menyerap nutrisi',
      ),
    ],
  );

  final userAnswer = <int, String>{};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
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
              'Pertanyaan ${currentIndex + 1}/3',
              style: GoogleFonts.robotoFlex(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
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
            ...quiz.questions[currentIndex].answers.map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Builder(builder: (context) {
                  var color =
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.05);

                  if (userAnswer.containsKey(currentIndex) &&
                      e == quiz.questions[currentIndex].correctAnswer) {
                    color = Colors.greenAccent[100]!;
                  }

                  if (userAnswer.containsKey(currentIndex) &&
                      e == currentAnswer &&
                      e != quiz.questions[currentIndex].correctAnswer) {
                    color = Colors.redAccent[100]!;
                  }

                  var borderColor = Colors.transparent;

                  if (!userAnswer.containsKey(currentIndex) &&
                      e == currentAnswer) {
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
                            currentAnswer = e;
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
                              e,
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
                    userAnswer.containsKey(currentIndex) ? 'Lanjut' : 'Jawab',
                    style: GoogleFonts.robotoFlex(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
