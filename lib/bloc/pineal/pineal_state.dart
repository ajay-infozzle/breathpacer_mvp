part of 'pineal_cubit.dart';

@immutable
sealed class PinealState extends Equatable{
  @override
  List<Object?> get props => [];
}

final class PinealInitial extends PinealState {
  @override
  List<Object?> get props => [];
}

final class NavigateToWaitingScreen extends PinealState {}
final class CloseWaitingScreen extends PinealState {}

final class PinealBreathingUpdate extends PinealState {
  final int breathingTime;
  PinealBreathingUpdate(this.breathingTime);

  @override
  List<Object?> get props => [breathingTime];
}

final class PinealHoldUpdate extends PinealState {
  final int holdTime;
  PinealHoldUpdate(this.holdTime);

  @override
  List<Object?> get props => [holdTime];
}

final class PinealRecoveryUpdate extends PinealState {
  final int recoveryTime;
  PinealRecoveryUpdate(this.recoveryTime);

  @override
  List<Object?> get props => [recoveryTime];
}

final class PinealToggleJerryVoice extends PinealState {
  final bool jerryVoice;
  PinealToggleJerryVoice(this.jerryVoice);

  @override
  List<Object?> get props => [jerryVoice];
}

final class PinealToggleMusic extends PinealState {
  final bool music;
  PinealToggleMusic(this.music);

  @override
  List<Object?> get props => [music];
}

final class PinealToggleSkipIntro extends PinealState {
  final bool skipIntro;
  PinealToggleSkipIntro(this.skipIntro);

  @override
  List<Object?> get props => [skipIntro];
}

final class PinealToggleChimes extends PinealState {
  final bool chimes;
  PinealToggleChimes(this.chimes); 
  
  @override
  List<Object?> get props => [chimes];
}

final class PinealPaused extends PinealState {
  @override
  List<Object?> get props => [];
}

final class PinealResumed extends PinealState {
  @override
  List<Object?> get props => [];
}

final class PinealToggleSave extends PinealState {
  final bool saveSession;
  PinealToggleSave(this.saveSession); 
  
  @override
  List<Object?> get props => [saveSession];
}

final class PinealBreathworkFetched extends PinealState {
  
}

// final class ResumeHoldCounter extends PinealState {
  
// }
