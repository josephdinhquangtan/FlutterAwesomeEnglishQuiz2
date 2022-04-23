import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_toeic_quiz2/core/constants/app_dimensions.dart';
import 'package:flutter_toeic_quiz2/core/constants/app_text_styles.dart';
import 'package:flutter_toeic_quiz2/data/models/part_models/answer_enum.dart';
import 'package:flutter_toeic_quiz2/data/models/part_models/part_four_model.dart';
import 'package:flutter_toeic_quiz2/presentation/screens/execute_screen/widgets/audio_controller_neumorphic_widget.dart';
import 'package:flutter_toeic_quiz2/utils/misc.dart';
import '../../../../view_model/execute_screen_cubit/part_four_cubit/part_four_cubit.dart';
import '../components/media_player.dart';
import '../widgets/answer_board_neumorphic_widget.dart';
import '../widgets/bottom_controller_neumorphic_widget.dart';

class PartFourScreen extends StatelessWidget {
  final int partId;
  final String partTitle;

  const PartFourScreen(
      {Key? key, required this.partId, required this.partTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PartFourCubit()..getInitContent(),
      child: const PartFourPage(),
    );
  }
}

class PartFourPage extends StatelessWidget {
  const PartFourPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                //_showMyDialog();
                //BlocProvider.of<PartFourCubit>(context).getContent();
              },
              icon: const Icon(Icons.format_list_numbered_outlined))
        ],
        title: BlocBuilder<PartFourCubit, PartFourState>(
          builder: (context, state) {
            if (state is PartFourContentLoaded) {
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
              const LinearProgressIndicator(
                value:
                    0.5, //quizBrain.currentQuestionNumber / quizBrain.totalQuestionNumber,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BlocBuilder<PartFourCubit, PartFourState>(
                      builder: (context, state) {
                        if (state is PartFourContentLoaded) {
                          final PartFourModel partFourModel =
                              state.partFourModel;
                          final userChecked = state.userChecked;
                          final userAnswer = state.userAnswer;
                          List<Widget> listWidget = [];
                          for (int i = 0;
                              i < partFourModel.questionNumber.length;
                              i++) {
                            if (i != 0) {
                              listWidget.add(const SizedBox(
                                  height: AppDimensions.kPaddingDefaultDouble));
                            }
                            listWidget.add(Text(
                              '  ${partFourModel.questionNumber[i]}: ${partFourModel.questions[i]}',
                              style: AppTextStyles.kTextQuestion,
                            ));
                            listWidget.add(const SizedBox(
                                height: AppDimensions.kPaddingDefault));
                            listWidget.add(AnswerBoardNeumorphic(
                              textA: partFourModel.answers[i][0],
                              textB: partFourModel.answers[i][1],
                              textC: partFourModel.answers[i][2],
                              textD: partFourModel.answers[i].length > 3
                                  ? partFourModel.answers[i][3]
                                  : null,
                              // need modify to check whether user is clicked the answer or not.
                              correctAns: userChecked[i]
                                  ? partFourModel.correctAnswer[i].index
                                  : -1,
                              selectedAns: userAnswer[i].index,
                              selectChanged: (value) {
                                BlocProvider.of<PartFourCubit>(context)
                                    .userSelectAnswerChange(
                                        partFourModel.questionNumber[i],
                                        UserAnswer.values[value]);
                              },
                            ));
                          }
                          return Column(
                            children: listWidget,
                            crossAxisAlignment: CrossAxisAlignment.start,
                          );
                        }
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const SizedBox(
                                height: AppDimensions.kPaddingDefault),
                            const Text('question ...'),
                            AnswerBoardNeumorphic(
                              textA: '...',
                              textB: '...',
                              textC: '...',
                              textD: '...',
                              correctAns: -1,
                              selectedAns: -1,
                              selectChanged: (value) {
                                //quizBrain.setSelectedAnswer(value);
                              },
                            ),
                            const SizedBox(
                                height: AppDimensions.kPaddingDefault),
                            const Text('question ...'),
                            AnswerBoardNeumorphic(
                              textA: '...',
                              textB: '...',
                              textC: '...',
                              textD: '...',
                              correctAns: -1,
                              selectedAns: -1,
                              selectChanged: (value) {
                                //quizBrain.setSelectedAnswer(value);
                              },
                            ),
                            const SizedBox(
                                height: AppDimensions.kPaddingDefault),
                            const Text('question ...'),
                            AnswerBoardNeumorphic(
                              textA: '...',
                              textB: '...',
                              textC: '...',
                              textD: '...',
                              correctAns: -1,
                              selectedAns: -1,
                              selectChanged: (value) {
                                //quizBrain.setSelectedAnswer(value);
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              AudioControllerNeumorphic(
                //durationTime: MediaPlayer.instance.getDurationTime(),
                changeToDurationCallBack: (timestamp) {
                  MediaPlayer.instance.seekTo(seconds: timestamp.toInt());
                },
                playCallBack: () {
                  MediaPlayer.instance.resume();
                },
                pauseCallBack: () {
                  MediaPlayer.instance.pause();
                },
                audioPlayer: MediaPlayer.instance.audioPlayer,
              ),
              BottomControllerNeumorphic(
                prevPressed: () {
                  BlocProvider.of<PartFourCubit>(context).getPrevContent();
                },
                nextPressed: () {
                  BlocProvider.of<PartFourCubit>(context).getNextContent();
                },
                checkAnsPressed: () {
                  BlocProvider.of<PartFourCubit>(context).userCheckAnswer();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}