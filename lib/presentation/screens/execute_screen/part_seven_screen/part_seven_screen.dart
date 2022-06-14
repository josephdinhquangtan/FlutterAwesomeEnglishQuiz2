import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core_ui/constants/app_dimensions.dart';
import '../../../../core_ui/constants/app_light_colors.dart';
import '../../../../core_ui/constants/app_text_styles.dart';
import '../../../../core_utils/core_utils.dart';
import '../../../../data/business_models/execute_models/answer_enum.dart';
import '../../../../data/business_models/execute_models/part_seven_model.dart';
import '../../../../view_model/execute_screen_cubit/part_seven_cubit/part_seven_cubit.dart';
import '../widgets/answer_board_neumorphic_widget.dart';
import '../widgets/answer_sheet_panel.dart';
import '../widgets/bottom_controller_neumorphic_widget.dart';
import '../widgets/horizontal_split_view.dart';

class PartSevenScreen extends StatelessWidget {
  final String partTitle;

  const PartSevenScreen({Key? key, required this.partTitle}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                //_showMyDialog();
                //BlocProvider.of<PartSevenCubit>(context).getContent();
                showDialog(
                    context: context,
                    builder: (BuildContext buildContext) {
                      return AlertDialog(
                        scrollable: true,
                        title: const Center(child: Text('Answer sheet')),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 16.0),
                        content: AnswerSheetPanel(
                          selectedColor:
                              AppLightColors.kAnswerButtonColorSelected,
                          answerColor:
                              AppLightColors.kAnswerButtonColorCorrectAns,
                          answerSheetData:
                              BlocProvider.of<PartSevenCubit>(context)
                                  .getAnswerSheetData(),
                          maxWidthForMobile:
                              AppDimensions.maxWidthForMobileMode,
                          onPressedSubmit: () {},
                          onPressedCancel: () {
                            Navigator.pop(buildContext);
                          },
                          onPressedGoToQuestion: (questionNumber) {
                            BlocProvider.of<PartSevenCubit>(context)
                                .goToQuestion(questionNumber);
                            Navigator.pop(buildContext);
                          },
                          currentWidth: width,
                          currentHeight: height,
                        ),
                      );
                    });
              },
              icon: const Icon(Icons.format_list_numbered_outlined))
        ],
        title: BlocBuilder<PartSevenCubit, PartSevenState>(
          builder: (context, state) {
            if (state is PartSevenContentLoaded) {
              return Text(
                  'Question: ${numToStr(state.currentQuestionNumber)}/${numToStr(state.questionListSize)}');
            }
            return const Text('Question: ../..');
          },
        ),
      ),
      body: Center(
        child: SizedBox(
          width: width > AppDimensions.maxWidthForMobileMode
              ? AppDimensions.maxWidthForMobileMode
              : null,
          child: Column(
            children: [
              BlocBuilder<PartSevenCubit, PartSevenState>(
                builder: (context, state) {
                  if (state is PartSevenContentLoaded) {
                    return LinearProgressIndicator(
                      value:
                          state.currentQuestionNumber / state.questionListSize,
                    );
                  }
                  return const LinearProgressIndicator(
                    value:
                        0.5, //quizBrain.currentQuestionNumber / quizBrain.totalQuestionNumber,
                  );
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: BlocBuilder<PartSevenCubit, PartSevenState>(
                    builder: (context, state) {
                      if (state is PartSevenContentLoaded) {
                        return _buildPartSevenContentView(context,
                            state: state);
                      }
                      return const Center(child: Text('Loading ...'));
                    },
                  ),
                ),
              ),
              BottomControllerNeumorphic(
                isStandAlone: true,
                prevPressed: () {
                  BlocProvider.of<PartSevenCubit>(context).getPrevContent();
                },
                nextPressed: () {
                  BlocProvider.of<PartSevenCubit>(context).getNextContent();
                },
                checkAnsPressed: () {
                  BlocProvider.of<PartSevenCubit>(context).userCheckAnswer();
                },
                favoritePressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPartSevenContentView(context,
      {required PartSevenContentLoaded state}) {
    List<Widget> listWidget = [];
    final PartSevenModel partSevenModel =
        state.partSevenModel as PartSevenModel;
    final correctAnswer = state.correctAnswer;
    final userAnswer = state.userAnswer;
    for (int i = 0; i < partSevenModel.questionNumber.length; i++) {
      listWidget
          .add(const SizedBox(height: AppDimensions.kPaddingDefaultDouble));
      listWidget.add(Text(
        '  ${partSevenModel.questionNumber[i]}: ${partSevenModel.questions[i]}',
        style: AppTextStyles.kTextQuestion,
      ));
      listWidget.add(const SizedBox(height: AppDimensions.kPaddingDefault));
      listWidget.add(AnswerBoardNeumorphic(
        textA: partSevenModel.answers[i][0],
        textB: partSevenModel.answers[i][1],
        textC: partSevenModel.answers[i][2],
        textD: partSevenModel.answers[i].length > 3
            ? partSevenModel.answers[i][3]
            : null,
        // need modify to check whether user is clicked the answer or not.
        correctAns: correctAnswer[i].index,
        selectedAns: userAnswer[i].index,
        selectChanged: (value) {
          BlocProvider.of<PartSevenCubit>(context).userSelectAnswerChange(
              partSevenModel.questionNumber[i], UserAnswer.values[value]);
        },
      ));
    }
    listWidget.add(const SizedBox(height: AppDimensions.kPaddingDefaultDouble));
    return HorizontalSplitView(
      color: AppLightColors.kSplitBar,
      up: SingleChildScrollView(
        child: Text(
          partSevenModel.statement[0].stringData,
          style: AppTextStyles.kTextQuestion,
        ),
      ),
      bottom: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.kPaddingDefaultDouble),
          child: Column(
            children: listWidget,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
      ),
      ratio: 0.5,
    );
  }
}
