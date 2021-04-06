import 'package:meta/meta.dart';

import 'survey_answer_entity.dart';

class SurveyResultEntity {
  final String surveyId;
  final String question;
  final List<SurveyAnswerEntity> answers;

  SurveyResultEntity({
    @required this.surveyId,
    @required this.question,
    @required this.answers,
  });
}



/**
 * 
{
  "surveyId": "string",
  "question": "string",
  "answers": [
    {
      "image": "string",
      "answer": "string",
      "count": 0,
      "percent": 0,
      "isCurrentAccountAnswer": true
    }
  ],
  "date": "string"
}
 */
