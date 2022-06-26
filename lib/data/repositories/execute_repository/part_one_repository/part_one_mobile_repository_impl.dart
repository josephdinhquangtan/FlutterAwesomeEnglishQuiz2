import 'package:get_it/get_it.dart';

import '../../../business_models/execute_models/part_one_model.dart';
import '../../../data_providers/daos/part_execute_daos/part_one_dao.dart';
import 'part_one_repository.dart';

class PartOneMobileRepositoryImpl implements PartOneRepository {
  final _dao = GetIt.I.get<PartOneDao>();

  @override
  Future<List<PartOneModel>> getQuestionList(List<String> ids) async {
    return await _dao.queryAll(ids);
  }
}
