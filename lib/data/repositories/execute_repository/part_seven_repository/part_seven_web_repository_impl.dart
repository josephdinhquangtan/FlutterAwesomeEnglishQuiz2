import 'package:get_it/get_it.dart';

import '../../../business_models/execute_models/part_seven_model.dart';
import '../../../data_providers/apis/part_execute_apis/part_seven_api.dart';
import 'part_seven_repository.dart';

class PartSevenWebRepositoryImpl implements PartSevenRepository {
  final _api = GetIt.I.get<PartSevenApi>();

  @override
  Future<List<PartSevenModel>> getQuestionList(List<String> ids) {
    // TODO: implement getQuestionList
    throw UnimplementedError();
  }
}