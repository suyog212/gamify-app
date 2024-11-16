import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gamify_test/utils/constants.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

class QuizResult extends StatefulWidget {
  final double score;
  final int totalQuestions;
  final int solvedQuestions;
  final int wrongQuestions;
  const QuizResult({super.key, required this.score, required this.totalQuestions, required this.solvedQuestions, required this.wrongQuestions});

  @override
  State<QuizResult> createState() => _QuizResultState();
}

class _QuizResultState extends State<QuizResult> {
  bool isAdLoaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0,left: 16,bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FittedBox(
                child: SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: 400,
                  child: Image.asset("assets/images/celebration-removebg-preview.png"),
                ),
              ),
              AutoSizeText("Your Score",style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.titleLarge!.fontSize
              ),textAlign: TextAlign.center,),
              AutoSizeText("${widget.solvedQuestions}/${widget.totalQuestions}",textAlign: TextAlign.center,style: TextStyle(
                  fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold
              ),),
              Visibility(
                  visible: widget.wrongQuestions != 0,
                  child: AutoSizeText("${widget.wrongQuestions} questions marked as wrong",textAlign: TextAlign.center,)),
              AutoSizeText("Congratulations",textAlign: TextAlign.center,style: TextStyle(
                  fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary
              ),),
              AutoSizeText("Great job ${Hive.box(userDataDB).get('personalInfo')["name"]}. You have done well.",textAlign: TextAlign.center,style: Theme.of(context).textTheme.titleMedium,),
              const Divider(color: Colors.transparent,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.4)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.monetization_on_outlined),
                          const VerticalDivider(width: 4,),
                          Text("${widget.score.toStringAsFixed(3)} Coins",style: const TextStyle(fontWeight: FontWeight.bold),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              OutlinedButton(onPressed: () {
                context.go("/landingPage/analytics");
              }, child: const Text("View analytics")),
              const Divider(color: Colors.transparent,),
              FilledButton(onPressed: () {
                context.go("/landingPage");
              }, child: const Text("Explore championships"))
            ],
          ),
        ),
      ),
    );
  }
}
