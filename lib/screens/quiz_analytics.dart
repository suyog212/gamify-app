import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gamify_test/models/question_analytics.dart';

class QuizAnalytics extends StatelessWidget {
  final List<QuestionAnalytics> analyticsData;
  const QuizAnalytics({super.key, required this.analyticsData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          AutoSizeText("LeaderBoard",style: Theme.of(context).textTheme.titleLarge,),
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) {
            return AutoSizeText("${index + 1}",style: Theme.of(context).textTheme.titleMedium!.copyWith(
              fontSize: Theme.of(context).textTheme.titleMedium!.fontSize! * (index * 0.15)
            ),);
          },),
          ListView.builder(
            shrinkWrap: true,
            itemCount: analyticsData.length,
            itemBuilder: (context, index) {
              final data = analyticsData.elementAt(index);
              List<String?> answers = [data.option1Text,data.option2Text,data.option3Text,data.option4Text];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.fromBorderSide(BorderSide(color: analyticsData.elementAt(index).submittedAns == analyticsData.elementAt(index).correctAns ? Colors.green : Colors.red,))
                ),
                child: ListTile(
                  // contentPadding: EdgeInsets.zero,
                  leading: AutoSizeText("Q${index +1}",style: Theme.of(context).textTheme.titleLarge,),
                  title: AutoSizeText("Ans : ${data.submittedAns} (${answers[data.submittedAns! - 1]?.trim()})"),
                  subtitle: AutoSizeText("Points : ${data.points}"),
                  trailing: AutoSizeText(stringToSeconds(data.timeTaken!).toString()),
                ),
              );
            },),
        ],
      )
    );
  }

  int stringToSeconds(String time){
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    // Calculate the total seconds.
    int totalSeconds = (hours * 3600) + (minutes * 60) + seconds;

    return totalSeconds;
  }
}