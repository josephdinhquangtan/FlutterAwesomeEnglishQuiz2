// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import '../../business_models/part_model.dart';
import 'base_dto/base_dto.dart';

class PartDto implements BaseDto<PartModel> {
  String title;
  String id;
  int num_of_question;
  int? num_of_correct;
  String questions_url;
  int ver;
  List<String> question_ids;

  PartDto({
    required this.title,
    required this.id,
    required this.num_of_question,
    required this.num_of_correct,
    required this.questions_url,
    required this.question_ids,
    required this.ver,
  });

  @override
  PartModel toBusinessModel() {
    return PartModel(
      title: title,
      id: id,
      partType: _getPartType(),
      numOfCorrect: num_of_correct,
      numOfQuestion: num_of_question,
      questionIds: question_ids,
      ver: ver,
    );
  }

  PartType _getPartType() {
    String partStr = title.split(" ")[1];
    int partInt = int.parse(partStr);
    return PartType.values[(partInt - 1)];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'id': id,
      'num_of_question': num_of_question,
      'num_of_correct': num_of_correct,
      'questions_url': questions_url,
      'question_ids': question_ids,
      'ver': ver,
    };
  }

  factory PartDto.fromMap(Map<String, dynamic> map) {
    return PartDto(
      title: map['title'] as String,
      id: map['id'] as String,
      num_of_question: map['num_of_question'] as int,
      num_of_correct:
          map['num_of_correct'] != null ? map['num_of_correct'] as int : null,
      questions_url: map['questions_url'] as String,
      ver: map['ver'] as int,
      question_ids: List<String>.from((map['question_ids'] as List<dynamic>)),
    );
  }

  String toJson() => json.encode(toMap());

  factory PartDto.fromJson(String source) =>
      PartDto.fromMap(json.decode(source) as Map<String, dynamic>);
}