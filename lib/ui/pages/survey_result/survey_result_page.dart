import 'package:flutter/material.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';
import './survey_result.dart';

class SurveyResultPage extends StatelessWidget {
  final SurveyResultPresenter presenter;

  const SurveyResultPage({
    @required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(builder: (context) {
        presenter.isLoadingStream.listen((isLoading) {
          if (isLoading == true) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });
        presenter.loadData();

        return StreamBuilder<dynamic>(
          stream: presenter.surveyResultStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ReloadScreen(
                error: snapshot.error,
                reload: presenter.loadData,
              );
            }

            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Container(
                      padding: const EdgeInsets.only(
                        top: 40,
                        bottom: 20,
                        left: 20,
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).disabledColor.withAlpha(90),
                      ),
                      child: Text('Qual é seu framework web favorito?'),
                    );
                  }

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
                            Image.network(
                              'https://fordevs.herokuapp.com/static/img/logo-angular.png',
                              width: 40,
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'Angular',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            Text(
                              '100%',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColorDark,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Icon(
                                Icons.check_circle,
                                color: Theme.of(context).highlightColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1),
                    ],
                  );
                },
              );
            }

            return Container(
              width: 0,
              height: 0,
            );
          },
        );
      }),
    );
  }
}
