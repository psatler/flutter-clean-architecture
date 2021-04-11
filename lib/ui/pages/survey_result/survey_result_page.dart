import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';

import './components/components.dart';

import '../../mixins/mixins.dart';

import './survey_result.dart';

class SurveyResultPage extends StatelessWidget with SessionManager {
  final SurveyResultPresenter presenter;

  const SurveyResultPage({
    @required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    presenter.loadData();

    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(
        builder: (context) {
          handleSessionExpired(presenter.isSessionExpiredStream);

          return StreamBuilder<SurveyResultViewModel>(
            stream: presenter.surveyResultStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error,
                  reload: presenter.loadData,
                );
              }

              if (snapshot.hasData) {
                return SurveyResult(
                  viewModel: snapshot.data,
                  onSave: presenter.save,
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      ),
    );
  }
}
