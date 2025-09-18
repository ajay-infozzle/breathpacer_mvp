part of 'firebreathing_cubit.dart';

@immutable
sealed class FirebreathingState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class FirebreathingInitial extends FirebreathingState {
  @override
  List<Object?> get props => [];
}

final class NavigateToWaitingScreen extends FirebreathingState {}
final class CloseWaitingScreen extends FirebreathingState {}

final class FirebreathingUpdateSetDuration extends FirebreathingState {
  final int duration;
  FirebreathingUpdateSetDuration(this.duration);

  @override
  List<Object?> get props => [duration];
}

final class FirebreathingUpdateSetNumber extends FirebreathingState {
  final int number;
  FirebreathingUpdateSetNumber(this.number);

  @override
  List<Object?> get props => [number];
}

final class FirebreathingToggleRecoveryBreath extends FirebreathingState {
  final bool recoveryBreath;
  FirebreathingToggleRecoveryBreath(this.recoveryBreath);

  @override
  List<Object?> get props => [recoveryBreath];
}

final class FirebreathingToggleHolding extends FirebreathingState {
  final bool holding;
  FirebreathingToggleHolding(this.holding);

  @override
  List<Object?> get props => [holding];
}

final class FirebreathingToggleJerryVoice extends FirebreathingState {
  final bool jerryVoice;
  FirebreathingToggleJerryVoice(this.jerryVoice);

  @override
  List<Object?> get props => [jerryVoice];
}

final class FirebreathingTogglePineal extends FirebreathingState {
  final bool pineal;
  FirebreathingTogglePineal(this.pineal);

  @override
  List<Object?> get props => [pineal];
}

final class FirebreathingToggleBreathHoldChoice extends FirebreathingState {
  final int hold;
  FirebreathingToggleBreathHoldChoice(this.hold);

  @override
  List<Object?> get props => [hold];
}

final class FirebreathingToggleMusic extends FirebreathingState {
  final bool music;
  FirebreathingToggleMusic(this.music);

  @override
  List<Object?> get props => [music];
}

final class FirebreathingToggleSkipIntro extends FirebreathingState {
  final bool intro;
  FirebreathingToggleSkipIntro(this.intro);

  @override
  List<Object?> get props => [intro];
}

final class FirebreathingToggleChimes extends FirebreathingState {
  final bool chimes;
  FirebreathingToggleChimes(this.chimes);

  @override
  List<Object?> get props => [chimes];
}

final class FirebreathingPaused extends FirebreathingState {
  @override
  List<Object?> get props => [];
}

final class FirebreathingResumed extends FirebreathingState {
  @override
  List<Object?> get props => [];
}

final class FirebreathingToggleSave extends FirebreathingState {
  final bool save;
  FirebreathingToggleSave(this.save);

  @override
  List<Object?> get props => [save];
}

final class FireBreathworkFetched extends FirebreathingState {
  final bool isSaved;
  FireBreathworkFetched(this.isSaved);

  @override
  List<Object?> get props => [isSaved];
}
