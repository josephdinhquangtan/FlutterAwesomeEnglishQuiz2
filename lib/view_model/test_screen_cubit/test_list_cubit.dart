import 'package:bloc/bloc.dart';
import '../../data/business_models/test_model.dart';
import '../../data/repositories/test_repository/test_repository_impl.dart';
import '../../domain/get_from_db_use_case/get_list_test_use_case.dart';

part 'test_list_state.dart';

class TestListCubit extends Cubit<TestListState> {
  final useCase = GetListTestUseCase(repository: TestRepositoryImpl());

  TestListCubit() : super(TestListInitial());

  Future<void> getInitContent(List<String> hiveIds) async {
    emit(TestListLoading());
    try {
      final List<TestModel> testList = await useCase.getListInfo(hiveIds);
      emit(TestListLoaded(
        testListModel: testList,
      ));
    } catch (error) {
      emit(Failure());
    }
  }
}
