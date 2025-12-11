import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:breathpacer_mvp/config/model/dna_breathwork_model.dart';
import 'package:breathpacer_mvp/config/services/audio_services.dart';
import 'package:breathpacer_mvp/utils/constant/interaction_breathing_constant.dart';
import 'package:breathpacer_mvp/utils/constant/toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'dna_state.dart';

class DnaCubit extends Cubit<DnaState> {
  final AudioOrchestrator audio;
  
  DnaCubit(this.audio) : super(DnaInitial());

  String? speed; 
  int noOfSets = 3;
  int currentSet = 0;

  bool isTimeBreathingApproch = false;
  int noOfBreath = 10;
  int durationOfSet = 30;
  int recoveryBreathDuration = 10;
  int holdDuration = 20;
  bool recoveryBreath = false;
  bool holdingPeriod = false;
  bool jerryVoice = true;
  bool music = true;
  bool chimes = true;
  bool pineal = false;
  bool skipIntro = false;

  // String jerryVoiceAssetFile = jerryVoiceOver(JerryVoiceEnum.breatheIn); //~ temporary
  String choiceOfBreathHold = BreathHoldChoice.breatheIn.name;
  int breathHoldIndex = 0;
  String breathingApproachGroupValue = 'No. of Breaths' ; //No. of Breaths,Time per set
  List<String> breathHoldList = [BreathHoldChoice.breatheIn.name, BreathHoldChoice.breatheOut.name, BreathHoldChoice.both.name] ; 
  List<int> breathList = [10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60] ; 
  List<int> setsList = [1, 2, 3, 4, 5, 6] ; 
  List<int> durationsList = [30, 60, 120, 180, 240, 300, 360, 420, 480, 540, 600, 900, 1200, 1800, 3600] ; //sec
  List<int> holdDurationList = [10, 20, 30, 40, 50, 60, 70, 80, 90] ;
  List<int> recoveryDurationList = [10,20, 30, 40, 60, 120, 180] ;

  int selectedMusic = 1; 
  String musicPath = MusicTrack.track1.path;

  bool isReatartEnable = false;
  bool isSaveDialogOn = false;

  List<int> breathingTimeList = []; //sec
  List<int> holdInbreathTimeList = []; //sec
  List<int> holdBreathoutTimeList = []; //sec
  List<int> recoveryTimeList = []; //sec

  late int waitingTime ;
  int breathCount = 0;
  bool paused = false;
  bool hasDecreased = false;
  bool hasIncreased = false;
  String currentBreathing = BreathHoldChoice.breatheIn.name ;

  void initialSettings(String speedd){
    speed = speedd;
    noOfSets = 3;
    breathCount = 0;
    breathHoldIndex = 0;
    durationOfSet = 30;
    jerryVoice = true;
    music = true;
    chimes = true;
    pineal = false;
    recoveryBreath = false;
    isReatartEnable = true ;
    // jerryVoiceAssetFile = jerryVoiceOver(JerryVoiceEnum.breatheIn);
    breathHoldIndex = 0;
    isSaveDialogOn = false;
    // saveInputCont.clear();

    isTimeBreathingApproch = false;
    currentSet = 0;
    paused = false;
    hasDecreased = false;
    hasIncreased = false;
    currentBreathing = BreathHoldChoice.breatheIn.name ;
  
    emit(DnaInitial());
  }

  void resetSettings(String speedd){
    speed = speedd;
    jerryVoice = true;
    pineal = false;
    music = true;
    chimes = true;
    durationOfSet = 30;
    isReatartEnable = false;
    holdingPeriod = false;
    recoveryBreath = false;
    noOfBreath = 10;
    noOfSets = 3;


    breathHoldIndex = 0;
    breathingTimeList.clear();
    holdInbreathTimeList.clear();
    holdBreathoutTimeList.clear();
    recoveryTimeList.clear();

    isTimeBreathingApproch = false;
    currentSet = 0;
    paused = false;
    hasDecreased = false;
    hasIncreased = false;
    currentBreathing = BreathHoldChoice.breatheIn.name ;
    
    emit(DnaInitial());
  }


  void updateSetsNumber(int number){
    noOfSets = number ;
    emit(DnaUpdateSetNumber(number));
  }


  void updateHold(int number){
    holdDuration = number ;
    emit(DnaHoldDurationUpdate(holdDuration));
  }

  void updateRecoveryDuration(int number){
    recoveryBreathDuration = number ;
    emit(DnaRecoveryDurationUpdate(recoveryBreathDuration));
  }

  void updateBreathingApproach(String value){
    breathingApproachGroupValue = value ;
    emit(DnaUpdateBreathingApproach(breathingApproachGroupValue));
  }

  void updateBreathNumber(int number){
    noOfBreath = number ;
    emit(DnaUpdateBreathNumber(noOfBreath));
  }

  void updateBreathTime(int number){
    durationOfSet = number ;
    emit(DnaUpdateBreathTime(durationOfSet));
  }

  void toggleRecoveryBreath(){
    recoveryBreath = !recoveryBreath ;
    emit(DnaToggleRecoveryBreath(recoveryBreath));
  }

  void toggleHolding(){
    holdingPeriod = !holdingPeriod ;
    emit(DnaToggleHolding(holdingPeriod));
  }

  void toggleJerryVoice(){
    jerryVoice = !jerryVoice ;
    emit(DnaToggleJerryVoice(jerryVoice));
  }

  void togglePineal(){
    pineal = !pineal ;
    emit(DnaTogglePineal(pineal));
  }

  void toggleMusic(){
    music = !music ;
    emit(DnaToggleMusic(music));
  }

  void toggleSkipIntro(){
    skipIntro = !skipIntro ;
    emit(DnaToggleSkipIntro(skipIntro));
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
    emit(DnaToggleMusic(music));
  }

  void toggleChimes(){
    chimes = !chimes ;
    emit(DnaToggleChimes(chimes));
  }

  void toggleBreathHold(int index){
    choiceOfBreathHold =  breathHoldList[index];
    breathHoldIndex = index;
    emit(DnaToggleBreathHoldChoice(index));
  }

  // void changeJerryVoiceAudio(String audioFile){
  //   jerryVoiceAssetFile = audioFile;
  //   emit(DnaToggleBreathHoldChoice());
  // }

  void setToogleSaveDialog(){
    isSaveDialogOn = !isSaveDialogOn;
    emit(DnaToggleSave(isSaveDialogOn));
  }

  void onCloseDialogClick(){
    isSaveDialogOn = false;
    emit(DnaToggleSave(isSaveDialogOn));
  }

  Future<void> playCloseEyes() async {
    try {
      if(jerryVoice){
        String path = '';
        if(skipIntro){
          path = GuideTrack.skipIntro.path ;
        }
        else{
          path = GuideTrack.dnaStart.path ;
        }

        waitingTime = await audio.playVoiceAndGetDuration(path);
        waitingTime += 1; // to increase wait time by 1 sec after voice over
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
        // await audio.playFx(GuideTrack.motivation_2.path);
        // await audio.playFx(GuideTrack.motivation_1.path);
        await audio.playFx(GuideTrack.motivation_2_1.path);
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
    return noOfBreath;
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
        emit(DnaBreathingPhase(phase: "in", remainingBreaths: breathCount));
        // currentBreathing = BreathHoldChoice.breatheIn.name ;
        currentBreathing = 'Breathe in' ;
      }
      else{
        if(holdingPeriod){
          currentBreathing = 'Ready to Hold' ;
          emit(DnaHold());
        }
        else if(recoveryBreath){
          currentBreathing = 'Ready to Recover' ;
          emit(DnaRecover());
        }
        else if(currentSet < noOfSets ){
          currentBreathing = 'Ready for next set' ;
          emit(DnaNext());
        }
        else if(currentSet == noOfSets ){
          emit(DnaEnd());
        }
      }

      hasDecreased = true;  
    }

    if (status == AnimationStatus.forward && value > 0.98 && !hasIncreased) {
      // exhale finished
      if (breathCount == 0) return;
      
      // if(breathHoldIndex == 1 && breathCount == 1){
      //   currentBreathing = 'Hold Time' ;
      //   emit(PyramidHold());
      // }else{
      //   emit(PyramidBreathingPhase(phase: "out", remainingBreaths: breathCount));
      //   // currentBreathing = BreathHoldChoice.breatheOut.name ;
      //   currentBreathing = 'Breath out' ;
      // }

      emit(DnaBreathingPhase(phase: "out", remainingBreaths: breathCount));
      currentBreathing = 'Breathe out' ;

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
        emit(DnaPaused());
      } else {
        audio.resumeAll();
        emit(DnaResumed());
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
    if(currentSet < noOfSets){
      currentSet += 1 ;
    }
  }
  // ------------ Breathing Logic end ------------

  // ------------ Save Breathwork ------------
  List<DnaBreathworkModel> savedBreathwork = [];

  void onSaveClick(String text) async{
    if(text.isEmpty){
      emit(DnaToggleSave(false));
      return ;
    }


    var box = await Hive.openBox('DnaBreathworkBox');

    DnaBreathworkModel breathwork = DnaBreathworkModel(
      title: text,
      numberOfSets: noOfSets.toString(),
      breathingApproach: breathingApproachGroupValue,
      durationOfEachSet: durationOfSet,
      recoveryEnabled: recoveryBreath,
      holdEnabled: holdingPeriod,
      jerryVoice: jerryVoice,
      music: music,
      chimes: chimes,
      pineal: pineal,
      choiceOfBreathHold: choiceOfBreathHold,
      numberOfBreath: noOfBreath,
      holdDuration: holdDuration,
      recoveryDuration: recoveryBreathDuration,
      breathingTimeList: breathingTimeList,
      breathInholdTimeList: holdInbreathTimeList,
      breathOutholdTimeList: holdBreathoutTimeList,
      recoveryTimeList: recoveryTimeList
    );

    await box.add(breathwork.toJson());
   
    savedBreathwork.add(breathwork);
    isSaveDialogOn = false;

    updateSavedDnaBreathwork();

    showToast("Saved Successfuly");
    emit(DnaToggleSave(true));
  }

  void getAllSavedDnaBreathwork() async{
    
    var box = await Hive.openBox('dnaBreathworkBox');
  
    if(box.values.isEmpty || savedBreathwork.isNotEmpty){
      emit(DnaBreathworkFetched());
      return ;
    }
    
    savedBreathwork.clear();
    for (var item in box.values) {
      DnaBreathworkModel breathworks = DnaBreathworkModel.fromJson(Map<String, dynamic>.from(item));
      savedBreathwork.add(breathworks);
      emit(DnaBreathworkFetched());
    }
  }

  void updateSavedDnaBreathwork() async{
    var box = await Hive.openBox('dnaBreathworkBox');
  
    if(box.values.isEmpty){
      emit(DnaBreathworkFetched());
      return ;
    }
    
    savedBreathwork.clear();
    for (var item in box.values) {
      DnaBreathworkModel breathworks = DnaBreathworkModel.fromJson(Map<String, dynamic>.from(item));
      savedBreathwork.add(breathworks);
      emit(DnaBreathworkFetched());
    }
  }

  void deleteSavedDnaBreathwork(int index) async{
    var box = await Hive.openBox('dnaBreathworkBox');

    if(box.values.isEmpty){
      emit(DnaBreathworkFetched());
      return ;
    }
    
    var key = box.keyAt(index);
    await box.delete(key);
    savedBreathwork.removeAt(index);

    emit(DnaBreathworkFetched());
  }


}
