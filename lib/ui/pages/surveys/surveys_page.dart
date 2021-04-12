import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../components/components.dart';
import '../../helpers/helpers.dart';

import '../../mixins/mixins.dart';

import 'components/components.dart';
import 'surveys_presenter.dart';
import 'survey_view_model.dart';

class SurveysPage extends StatefulWidget {
  final SurveysPresenter presenter;

  const SurveysPage({
    @required this.presenter,
  });

  @override
  _SurveysPageState createState() => _SurveysPageState();
}

class _SurveysPageState extends State<SurveysPage>
    with NavigationManager, SessionManager, RouteAware {
  @override
  Widget build(BuildContext context) {
    final routeObserver = Get.find<RouteObserver>();
    routeObserver.subscribe(this, ModalRoute.of(context));

    widget.presenter.loadData();

    return Scaffold(
      appBar: AppBar(
        title: Text(R.strings.surveys),
      ),
      body: Builder(
        builder: (context) {
          handleNavigation(widget.presenter.navigateToStream);

          handleSessionExpired(widget.presenter.isSessionExpiredStream);

          return StreamBuilder<List<SurveyViewModel>>(
            stream: widget.presenter.surveysStream,
            builder: (context, snapshot) {
              debugPrint('snapshot $snapshot');
              debugPrint('snapshot.hasError ${snapshot.hasError}');

              if (snapshot.hasError) {
                return ReloadScreen(
                  error: snapshot.error,
                  reload: widget.presenter.loadData,
                );
              }

              if (snapshot.hasData) {
                return Provider(
                  create: (_) => widget.presenter,
                  child: SurveyItems(
                    viewModels: snapshot.data,
                  ),
                );
              }

              // return Container(width: 0.0, height: 0.0);
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void didPopNext() {
    widget.presenter.loadData();
    // super.didPopNext();
  }

  @override
  void dispose() {
    final routeObserver = Get.find<RouteObserver>();
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
