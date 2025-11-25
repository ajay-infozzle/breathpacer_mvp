part of 'dna_cubit.dart';

@immutable
sealed class DnaState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class DnaInitial extends DnaState {
  @override
  List<Object?> get props => [];
}

final class NavigateToWaitingScreen extends DnaState {}

final class CloseWaitingScreen extends DnaState {}

final class DnaUpdateSetNumber extends DnaState {
  final int number;
  DnaUpdateSetNumber(this.number);

  @override
  List<Object?> get props => [number];
}

final class DnaUpdateBreathNumber extends DnaState {
  final int number;
  DnaUpdateBreathNumber(this.number);

  @override
  List<Object?> get props => [number];
}

final class DnaUpdateBreathTime extends DnaState {
  final int time;
  DnaUpdateBreathTime(this.time); 

  @override
  List<Object?> get props => [];
}

final class DnaUpdateBreathingApproach extends DnaState {
  final String approach;
  DnaUpdateBreathingApproach(this.approach);

  @override
  List<Object?> get props => [approach];
}

final class DnaToggleRecoveryBreath extends DnaState {
  final bool recoveryBreath;
  DnaToggleRecoveryBreath(this.recoveryBreath);

  @override
  List<Object?> get props => [recoveryBreath];
}

final class DnaRecoveryDurationUpdate extends DnaState {
  final int duration;
  DnaRecoveryDurationUpdate(this.duration);

  @override
  List<Object?> get props => [duration];
}

final class DnaToggleHolding extends DnaState {
  final bool holding;
  DnaToggleHolding(this.holding);

  @override
  List<Object?> get props => [holding];
}

final class DnaHoldDurationUpdate extends DnaState {
  final int duration;
  DnaHoldDurationUpdate(this.duration);

  @override
  List<Object?> get props => [duration];
}

final class DnaToggleJerryVoice extends DnaState {
  final bool jerryVoice;
  DnaToggleJerryVoice(this.jerryVoice);

  @override
  List<Object?> get props => [jerryVoice];
}

final class DnaTogglePineal extends DnaState {
  final bool pineal;
  DnaTogglePineal(this.pineal);         

  @override
  List<Object?> get props => [pineal];
}

final class DnaToggleMusic extends DnaState {
  final bool music;
  DnaToggleMusic(this.music);

  @override
  List<Object?> get props => [music];
}

final class DnaToggleSkipIntro extends DnaState {
  final bool skipIntro;
  DnaToggleSkipIntro(this.skipIntro);

  @override
  List<Object?> get props => [skipIntro];
}

final class DnaToggleChimes extends DnaState {
  final bool chimes;
  DnaToggleChimes(this.chimes); 
  
  @override
  List<Object?> get props => [chimes];
}

final class DnaToggleBreathHoldChoice extends DnaState {
  final int index;
  DnaToggleBreathHoldChoice(this.index);
  @override
  List<Object?> get props => [index];
}

final class DnaToggleSave extends DnaState {
  final bool isSaveDialogOn;
  DnaToggleSave(this.isSaveDialogOn);

  @override
  List<Object?> get props => [isSaveDialogOn];
}

final class DnaBreathworkFetched extends DnaState {
  @override
  List<Object?> get props => [];
}

final class DnaBreathingPhase extends DnaState {
  final String phase; // "in" | "out"
  final int remainingBreaths;

  DnaBreathingPhase({
    required this.phase,
    required this.remainingBreaths,
  });

  @override
  List<Object?> get props => [phase, remainingBreaths];
}

final class DnaHold extends DnaState {
  @override
  List<Object?> get props => [];
}

final class DnaPaused extends DnaState {
  @override
  List<Object?> get props => [];
}

final class DnaResumed extends DnaState {
  @override
  List<Object?> get props => [];
}

final class DnaRecover extends DnaState {
  @override
  List<Object?> get props => [];
}

final class DnaNext extends DnaState {
  @override
  List<Object?> get props => [];
}

final class DnaEnd extends DnaState {
  @override
  List<Object?> get props => [];
}