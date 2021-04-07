import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../survey_view_model.dart';
import 'survey_item.dart';

class SurveyItems extends StatelessWidget {
  final List<SurveyViewModel> viewModels;

  const SurveyItems({
    @required this.viewModels,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: CarouselSlider(
        options: CarouselOptions(
          enlargeCenterPage: true,
          aspectRatio: 1,
          // enableInfiniteScroll: false,
        ),
        items: viewModels.map((viewModel) => SurveyItem(viewModel)).toList(),
      ),
    );
  }
}
