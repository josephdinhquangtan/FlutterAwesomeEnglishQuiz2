import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../core_utils/core_utils.dart';
import '../../../data/business_models/execute_models/answer_enum.dart';
import '../../../data/business_models/execute_models/part_two_model.dart';
import '../../../domain/execute_use_cases/get_part_two_question_list_use_case.dart';
import '../../../presentation/screens/execute_screen/components/media_player.dart';
import '../../../presentation/screens/execute_screen/widgets/answer_sheet_panel.dart';

part 'part_two_state.dart';

class PartTwoCubit extends Cubit<PartTwoState> {
  PartTwoCubit() : super(PartTwoInitial());
  final useCase = GetIt.I.get<GetPartTwoQuestionListUseCase>();

  late List<PartTwoModel> _partTwoQuestionList;
  int _currentQuestionIndex = 0;
  int _questionListSize = 0;
  final Map _userAnswerMap = <int, UserAnswer>{};
  final Map _correctAnsCheckedMap = <int, UserAnswer>{};
  final Map _questionNumberIndexMap = <int, int>{};
  final List<AnswerSheetModel> _answerSheetModel = [];

  Future<void> getInitContent(List<String> ids) async {
    emit(PartTwoLoading());
    _partTwoQuestionList = await useCase.perform(ids);
    _currentQuestionIndex = 0;
    _questionListSize = _partTwoQuestionList.length;
    _userAnswerMap.clear();
    _correctAnsCheckedMap.clear();
    _questionNumberIndexMap.clear();
    for (int i = 0; i < _questionListSize; i++) {
      _questionNumberIndexMap[_partTwoQuestionList[i].number] = i;
    }
    _playAudio(_partTwoQuestionList[_currentQuestionIndex].audioPath);
    _notifyData();
  }

  void _playAudio(String audioRelativePath) {
    final String audioFullPath = getApplicationDirectory() + audioRelativePath;
    MediaPlayer().playLocal(audioFullPath);
  }

  Future<void> getNextContent() async {
    emit(PartTwoLoading());
    if (_currentQuestionIndex < _partTwoQuestionList.length - 1) {
      _currentQuestionIndex++;
    }
    _playAudio(_partTwoQuestionList[_currentQuestionIndex].audioPath);
    _notifyData();
  }

  void userSelectAnswerChange(UserAnswer userAnswer) {
    final int key = _partTwoQuestionList[_currentQuestionIndex].number;
    _userAnswerMap[key] = userAnswer;
  }

  void userCheckAnswer() {
    final int key = _partTwoQuestionList[_currentQuestionIndex].number;
    _correctAnsCheckedMap[key] = UserAnswer.values[
        _partTwoQuestionList[_currentQuestionIndex].correctAnswer.index];
    _notifyData();
  }

  Future<void> getPrevContent() async {
    emit(PartTwoLoading());
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
    }
    _playAudio(_partTwoQuestionList[_currentQuestionIndex].audioPath);
    _notifyData();
  }

  void _notifyData() {
    final int key = _partTwoQuestionList[_currentQuestionIndex].number;
    bool needHideAns = false;
    if (!_userAnswerMap.containsKey(key)) {
      _userAnswerMap[key] = UserAnswer.notAnswer;
    }
    if (!_correctAnsCheckedMap.containsKey(key)) {
      _correctAnsCheckedMap[key] = UserAnswer.notAnswer;
    }
    if (_correctAnsCheckedMap[key] == UserAnswer.notAnswer) {
      needHideAns = true;
    }
    emit(PartTwoContentLoaded(
        answers: needHideAns
            ? ["", "", ""]
            : _partTwoQuestionList[_currentQuestionIndex].answers,
        audioPath: _partTwoQuestionList[_currentQuestionIndex].audioPath,
        question: needHideAns
            ? ""
            : _partTwoQuestionList[_currentQuestionIndex].question,
        userAnswer: _userAnswerMap[key],
        correctAnswer: _correctAnsCheckedMap[key],
        questionListSize: _questionListSize,
        currentQuestionNumber:
            _partTwoQuestionList[_currentQuestionIndex].number,
        currentQuestionIndex: _currentQuestionIndex + 1));
  }

  List<AnswerSheetModel> getAnswerSheetData() {
    _answerSheetModel.clear();
    for (int i = 0; i < _partTwoQuestionList.length; i++) {
      UserAnswer? userAns = _userAnswerMap[_partTwoQuestionList[i].number];
      UserAnswer? correctAns =
          _correctAnsCheckedMap[_partTwoQuestionList[i].number];
      int userAnsIdx =
          userAns == null ? UserAnswer.notAnswer.index : userAns.index;
      int correctAnsIdx =
          correctAns == null ? UserAnswer.notAnswer.index : correctAns.index;
      _answerSheetModel.add(AnswerSheetModel(
          questionNumber: _partTwoQuestionList[i].number,
          correctAnswerIndex: correctAnsIdx,
          userSelectedIndex: userAnsIdx));
    }
    return _answerSheetModel;
  }

  void goToQuestion(int questionNumber) {
    if (questionNumber - 7 == _currentQuestionIndex) return;
    _currentQuestionIndex = _questionNumberIndexMap[questionNumber];
    _playAudio(_partTwoQuestionList[_currentQuestionIndex].audioPath);
    _notifyData();
  }
}
