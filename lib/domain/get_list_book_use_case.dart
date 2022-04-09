import 'package:flutter_toeic_quiz2/data/models/book_infor.dart';
import 'package:flutter_toeic_quiz2/data/repositories/base_repository.dart';

import 'base_use_case.dart';

class GetListBookUseCase extends BaseUseCase<List<BookInfor>> {
  BaseRepository repository;

  GetListBookUseCase({
    required this.repository,
  });

  @override
  Future<List<BookInfor>> perform() async {
    return await repository.get();
  }
}
