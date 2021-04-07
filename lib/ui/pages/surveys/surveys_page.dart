import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';

import 'components/components.dart';
import 'surveys_presenter.dart';
import 'survey_view_model.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  const SurveysPage({
    @required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    presenter.loadData();

    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: StreamBuilder<List<SurveyViewModel>>(
        stream: presenter.surveysStream,
        builder: (context, snapshot) {
          debugPrint('snapshot $snapshot');
          debugPrint('snapshot.hasError ${snapshot.hasError}');

          if (snapshot.hasError) {
            return ReloadScreen(
              error: snapshot.error,
              reload: presenter.loadData,
            );
          }

          if (snapshot.hasData) {
            return SurveyItems(
              viewModels: snapshot.data,
            );
          }

          // return Container(width: 0.0, height: 0.0);
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
