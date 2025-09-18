part of 'pyramid_cubit.dart';

@immutable
sealed class PyramidState extends Equatable{
  @override
  List<Object?> get props => [];
}

final class PyramidInitial extends PyramidState {
  @override
  List<Object?> get props => [];
}

final class NavigateToWaitingScreen extends PyramidState {
  @override
  List<Object?> get props => [];
}

final class PyramidToggleJerryVoice extends PyramidState {
  final bool jerryVoice;
  PyramidToggleJerryVoice(this.jerryVoice);

  @override
  List<Object?> get props => [jerryVoice];
}

final class PyramidToggleMusic extends PyramidState {
  final bool music;
  PyramidToggleMusic(this.music);

  @override
  List<Object?> get props => [];
}

final class PyramidToggleChimes extends PyramidState {
  final bool chimes;
  PyramidToggleChimes(this.chimes);

  @override
  List<Object?> get props => [chimes];
}

final class PyramidToggleIntro extends PyramidState {
  final bool intro;
  PyramidToggleIntro(this.intro);

  @override
  List<Object?> get props => [intro];
}

final class PyramidToggleBreathHold extends PyramidState {
  final int hold;
  PyramidToggleBreathHold(this.hold);

  @override
  List<Object?> get props => [hold];
}


final class PyramidToggleSave extends PyramidState {
  final bool save;
  PyramidToggleSave(this.save);

  @override
  List<Object?> get props => [save];
}

final class PyramidBreathworkFetched extends PyramidState {
  final bool work;
  PyramidBreathworkFetched(this.work);

  @override
  List<Object?> get props => [work];
}

final class PyramidAudioState extends PyramidState {
  final AudioStatus status;
  final String? currentTrack;

  PyramidAudioState({
    required this.status,
    this.currentTrack,
  });

  @override
  List<Object?> get props => [status, currentTrack];
}

final class PyramidBreathingPhase extends PyramidState {
  final String phase; // "in" | "out"
  final int remainingBreaths;

  PyramidBreathingPhase({
    required this.phase,
    required this.remainingBreaths,
  });

  @override
  List<Object?> get props => [phase, remainingBreaths];
}

final class PyramidHold extends PyramidState {
  @override
  List<Object?> get props => [];
}

final class PyramidPaused extends PyramidState {
  @override
  List<Object?> get props => [];
}

final class PyramidResumed extends PyramidState {
  @override
  List<Object?> get props => [];
}
