part of 'part_three_cubit.dart';

@immutable
abstract class PartThreeState {}

class PartThreeInitial extends PartThreeState {}

// load content
class PartThreeLoading extends PartThreeState {}

class PartThreeContentLoaded extends PartThreeState {
  final PartThreeModel partThreeModel;
  final List<UserAnswer> userAnswer;
  final List<bool> userChecked;
  PartThreeContentLoaded({
    required this.userChecked,
    required this.partThreeModel,
    required this.userAnswer,
  });
}

class PartThreeCheckedAnswer extends PartThreeState {}
