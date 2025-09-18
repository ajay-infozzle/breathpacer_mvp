import 'dart:async';
import 'dart:developer';

import 'package:breathpacer_mvp/config/model/pyramid_breathwork_model.dart';
import 'package:breathpacer_mvp/config/services/audio_services.dart';
import 'package:breathpacer_mvp/utils/constant/interaction_breathing_constant.dart';
import 'package:breathpacer_mvp/utils/constant/toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'package:meta/meta.dart';

part 'pyramid_state.dart';


class PyramidCubit extends Cubit<PyramidState> {
  final AudioOrchestrator audio;

  PyramidCubit(this.audio) : super(PyramidInitial());

  String? step ;
  String? speed ;
  bool jerryVoice = true;
  bool music = true;
  bool chimes = true;
  bool skipIntro = false;
  String choiceOfBreathHold = BreathHoldChoice.breatheIn.name;
  int breathHoldIndex = 0;
  List<String> breathHoldList = [
    BreathHoldChoice.breatheIn.name,
    BreathHoldChoice.breatheOut.name,
    BreathHoldChoice.both.name
  ];
  int holdDuration = 20;
  List<int> holdDurationList = [10, 20, 30, 40, 50, 60, 70, 80, 90] ;

  int selectedMusic = 1; 
  String musicPath = MusicTrack.track1.path; 

  bool isReatartEnable = false;
  bool isSaveDialogOn = false;

  int currentRound = 0;
  List<int> breathingTimeList = []; //sec
  List<int> holdInbreathTimeList = []; //sec
  List<int> holdBreathoutTimeList = []; //sec

  late int waitingTime ;
  bool paused = false;
  int breathCount = 0;
  bool hasDecreased = false;
  bool hasIncreased = false;
  String currentBreathing = BreathHoldChoice.breatheIn.name ;

  void initialSettings(String stepp, String speedd){
    step = stepp;
    speed = speedd;
    jerryVoice = true;
    music = true;
    chimes = true;
    paused = false;
    holdDuration = 20;
    breathCount = 0;
    hasDecreased = false;
    hasIncreased = false;
    currentBreathing = BreathHoldChoice.breatheIn.name ;
  
    emit(PyramidInitial());
  }

  void resetSettings(String stepp, String speedd){
    jerryVoice = true;
    music = true;
    chimes = true;
    isReatartEnable = false;
    paused = false;
    breathCount = 0;
    hasDecreased = false;
    hasIncreased = false;
    currentBreathing = BreathHoldChoice.breatheIn.name ;

    currentRound = 0;
    holdDuration = 20;
    breathingTimeList.clear();
    holdBreathoutTimeList.clear();
    holdInbreathTimeList.clear();

    audio.reset(); 
  
    emit(PyramidInitial());
  }

  void toggleJerryVoice(){
    jerryVoice = !jerryVoice ;
    emit(PyramidToggleJerryVoice(jerryVoice));
  }

  void toggleMusic(){
    music = !music ;
    emit(PyramidToggleMusic(music));
  }

  void toggleSkipIntro(){
    skipIntro = !skipIntro;
    emit(PyramidToggleIntro(skipIntro));
  }

  void updateMusic(String selected){
    selectedMusic = musicList.indexOf(selected);
    switch (selectedMusic) {
      case 0:
        music = false;
        break;
      case 1:
        music = true;
        musicPath = MusicTrack.track1.path;
        break;
      case 2:
        music = true;
        musicPath = MusicTrack.track2.path;
        break;
      default: 
        music = true;
        musicPath = MusicTrack.track1.path;
    }
    emit(PyramidToggleMusic(music));
  }

  void toggleChimes(){
    chimes = !chimes ;
    emit(PyramidToggleChimes(chimes));
  }

  void toggleBreathHold(int index){
    choiceOfBreathHold =  breathHoldList[index];
    breathHoldIndex = index;
    log("breathHoldIndex set-> $breathHoldIndex", name: "toggleBreathHold");
    emit(PyramidToggleBreathHold(index));
  }

  void updateHold(int number){
    holdDuration = number ;
     emit(PyramidToggleBreathHold(holdDuration));
  }

  void setToogleSaveDialog(){
    isSaveDialogOn = !isSaveDialogOn;
    emit(PyramidToggleSave(isSaveDialogOn));
  }

  void onCloseDialogClick(){
    isSaveDialogOn = false;
    emit(PyramidToggleSave(isSaveDialogOn));
  }


  Future<void> playCloseEyes() async {
    try {
      if(jerryVoice){
        String path = '';
        if(skipIntro){
          path = GuideTrack.skipIntro.path ;
        }
        else if(step == "4"){
          path = GuideTrack.fourStepStart.path;
        }else if(step == "2"){
          path = GuideTrack.twoStepStart.path;
        }

        waitingTime = await audio.playVoiceAndGetDuration(path);
        emit(NavigateToWaitingScreen());
      }else{
        waitingTime = 5;
        emit(NavigateToWaitingScreen());
      }
    } on Exception catch (e) {
      log("playCloseEyes>> ${e.toString()}");
    }
  }

  Future<void> playBackgroundMusic() async {
    try {
      if (music) {
        if(selectedMusic != 0){
          await audio.playMusic(musicPath);
        }
      }
    } catch (e) {
      log("playMusic>> ${e.toString()}");
    }
  }

  Future<void> playExtra(String path) async {
    try {
      if(jerryVoice){
        await audio.playFx(path);
      }
    } catch (e) {
      log("playExtra>>$path>> ${e.toString()}");
    }
  }

  Future<void> playMotivation() async {
    try {
      if(jerryVoice){
        await audio.playFx(GuideTrack.motivation_2.path);
        await audio.playFx(GuideTrack.motivation_1.path);
      }
    } catch (e) {
      log("playMotivation>> ${e.toString()}");
    }
  }

  Future<void> playVoice(String path) async {
    try {
      if(jerryVoice){
        await audio.playVoice(path);
      }
    } catch (e) {
      log("playExtra>>$path>> ${e.toString()}");
    }
  }

  Future<void> playChime() async {
    try {
      if(chimes){
        await audio.playChime();
      }
    } catch (e) {
      log("playChime>> ${e.toString()}");
    }
  }

  // ------------ Breathing Logic ------------
  int getBreathingCycleTime(){
    if(speed == BreathSpeed.fast.name){
      return int.parse(BreathSpeedDuration.fast.duration);
    }
    else if(speed == BreathSpeed.slow.name){
      return int.parse(BreathSpeedDuration.slow.duration);
    }
    else{
      return int.parse(BreathSpeedDuration.standard.duration);
    }
  }

  int checkBreathnumber() {
    switch (currentRound) {
      case 1:
        return 12;
      case 2:
        return step == "4" ? 9 : 6;
      case 3:
        return 6;
      default:
        return 3;
    }
  }

  int getEachBreathingRoundTime(){
    int breathC = checkBreathnumber();

    if(speed == BreathSpeed.fast.name){
      return 2*(int.parse(BreathSpeedDuration.fast.duration)) * breathC;
    }
    else if(speed == BreathSpeed.slow.name){
      return 2*(int.parse(BreathSpeedDuration.slow.duration)) * breathC;
    }
    else{
      return 2*(int.parse(BreathSpeedDuration.standard.duration)) * breathC;
    }
  }

  void breathingWork(AnimationStatus status, double value) async {
    if (paused) return;
    if (breathCount == 0) return;

    if (status == AnimationStatus.reverse && value < 0.2 && !hasDecreased) {
      // inhale finished
      breathCount--;
      if (breathCount != 0) {
        emit(PyramidBreathingPhase(phase: "in", remainingBreaths: breathCount));
        currentBreathing = BreathHoldChoice.breatheIn.name ;
      }
      else{
        currentBreathing = 'Hold Time' ;
        emit(PyramidHold());
      }

      hasDecreased = true;  
    }

    if (status == AnimationStatus.forward && value > 0.98 && !hasIncreased) {
      // exhale finished
      if(breathHoldIndex == 1 && breathCount == 1){
        currentBreathing = 'Hold Time' ;
        emit(PyramidHold());
      }else{
        emit(PyramidBreathingPhase(phase: "out", remainingBreaths: breathCount));
        currentBreathing = BreathHoldChoice.breatheOut.name ;
      }
      // emit(PyramidBreathingPhase(phase: "out", remainingBreaths: breathCount));
      // currentBreathing = BreathHoldChoice.breatheOut.name ;
      hasIncreased = true; 
    }

    if (status == AnimationStatus.forward && hasDecreased) {
      hasDecreased = false;
    }

    if (status == AnimationStatus.reverse && hasIncreased) {
      hasIncreased = false;
    }
  }

  void togglePause() {
    paused = !paused;
    try {
      if (paused) {
        audio.pauseAll();
        emit(PyramidPaused());
      } else {
        audio.resumeAll();
        emit(PyramidResumed());
      }
    } catch (e) {
      log("togglePause>> ${e.toString()}");
    }
  }

  void playCount(String time) async {
    try{
      if (jerryVoice) {
        if(time == "3"){
          await audio.playFx(GuideTrack.three.path);
        }else if(time == "2"){
          await audio.playFx(GuideTrack.two.path);
        }else if(time == "1"){
          await audio.playFx(GuideTrack.one.path);
        }
      }
    }catch(e){
      log("playCount>> ${e.toString()}");
    }
  }

  void updateRound(){
    if(currentRound < int.parse(step??"0") ){
      currentRound += currentRound ;
    }
  }
  // ------------ Breathing Logic end ------------



  // ------------ Breathwork crud start------------
  List<PyramidBreathworkModel> savedBreathwork = [];

  void onSaveClick(String text) async{
    if(text.isEmpty){
      emit(PyramidToggleSave(isSaveDialogOn));
      return ;
    }


    var box = await Hive.openBox('pyramidBreathworkBox');

    PyramidBreathworkModel breathwork = PyramidBreathworkModel(
      title: text,
      speed: speed,
      step: step,
      jerryVoice: jerryVoice,
      music: music,
      chimes: chimes,
      choiceOfBreathHold: choiceOfBreathHold,
      holdDuration: holdDuration,
      breathingTimeList: breathingTimeList,
      holdBreathInTimeList: holdInbreathTimeList,
      holdBreathOutTimeList: holdBreathoutTimeList
    );

    await box.add(breathwork.toJson());
   
    savedBreathwork.add(breathwork);
    isSaveDialogOn = false;

    updateSavedPyramidBreathwork();
    
    showToast("Saved Successfuly");
    emit(PyramidToggleSave(isSaveDialogOn));
  }

  void getAllSavedPyramidBreathwork() async{
    var box = await Hive.openBox('pyramidBreathworkBox');

    if(box.values.isEmpty || savedBreathwork.isNotEmpty){
      emit(PyramidBreathworkFetched(true));
      return ;
    }
    
    savedBreathwork.clear();
    for (var item in box.values) {
      PyramidBreathworkModel breathworks = PyramidBreathworkModel.fromJson(Map<String, dynamic>.from(item));
      
      savedBreathwork.add(breathworks);
      emit(PyramidBreathworkFetched(true));
    }
  }

  void updateSavedPyramidBreathwork() async{
    var box = await Hive.openBox('pyramidBreathworkBox');

    if(box.values.isEmpty){
      emit(PyramidBreathworkFetched(true));
      return ;
    }
    
    savedBreathwork.clear();
    for (var item in box.values) {
      PyramidBreathworkModel breathworks = PyramidBreathworkModel.fromJson(Map<String, dynamic>.from(item));
      
      savedBreathwork.add(breathworks);
      emit(PyramidBreathworkFetched(true));
    }
  }

 
  void deleteSavedPyramidBreathwork(int index) async{
    var box = await Hive.openBox('pyramidBreathworkBox');

    if(box.values.isEmpty){
      emit(PyramidBreathworkFetched(true));
      return ;
    }
    
    var key = box.keyAt(index);
    await box.delete(key);
    savedBreathwork.removeAt(index);

    emit(PyramidBreathworkFetched(true));
  }
  // ------------ Breathwork crud end ------------

  @override
  Future<void> close() {
    audio.dispose();
    return super.close();
  }
}
