import 'package:flutter/material.dart';

import '../survey_answer_view_model.dart';
import 'components.dart';

class SurveyAnswer extends StatelessWidget {
  const SurveyAnswer({
    Key key,
    @required this.answerViewModel,
  }) : super(key: key);

  final SurveyAnswerViewModel answerViewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (answerViewModel.image != null)
                Image.network(
                  answerViewModel.image,
                  width: 40,
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    answerViewModel.answer,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              Text(
                answerViewModel.percent,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
              answerViewModel.isCurrentAnswer ? ActiveIcon() : DisabledIcon(),
            ],
          ),
        ),
        Divider(height: 1),
      ],
    );
  }
}
