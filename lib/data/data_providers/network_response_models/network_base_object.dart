import 'package:flutter_toeic_quiz2/data/business_models/base_model/base_model.dart';

abstract class NetworkBaseObject<T extends BaseBusinessModel>{
  T toBusinessModel();
}