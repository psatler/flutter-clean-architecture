import 'package:flutter/material.dart';

import '../survey_result.dart';
import 'components.dart';

class SurveyResult extends StatelessWidget {
  final SurveyResultViewModel viewModel;

  const SurveyResult({
    @required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: viewModel.answers.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return SurveyHeader(
            headerTitle: viewModel.question,
          );
        }

        return SurveyAnswer(
          answerViewModel: viewModel.answers[index - 1],
        );
      },
    );
  }
}
