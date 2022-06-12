import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter_toeic_quiz2/utils/misc.dart';

import '../../data/business_models/part_info_model.dart';
import '../../data/data_providers/apis/part_api.dart';
import '../../data/repositories/part_repository/part_repository_impl.dart';
import '../../domain/get_from_db_use_case/get_list_part_use_case.dart';

part 'part_list_state.dart';

const _logTag = "PartListCubit";

class PartListCubit extends Cubit<PartListState> {
  final useCase = GetListPartUseCase();

  PartListCubit() : super(PartListInitial());

  Future<void> getInitContent(List<String> ids) async {
    emit(PartListLoading());
    try {
      if (DebugLogEnable) log('$_logTag getInitContent(ids) started');
      final List<PartInfoModel> partList = await useCase.perform(ids);
      if (DebugLogEnable) {
        log('$PartListCubit getInitContent() done items.length: ${partList.length}');
      }
      emit(PartListLoaded(partListModel: partList));
    } catch (error) {
      emit(Failure());
    }
  }
}
