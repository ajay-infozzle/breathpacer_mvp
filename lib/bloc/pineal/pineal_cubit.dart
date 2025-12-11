import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:breathpacer_mvp/config/model/pineal_breathwork_model.dart';
import 'package:breathpacer_mvp/config/services/audio_services.dart';
import 'package:breathpacer_mvp/utils/constant/interaction_breathing_constant.dart';
import 'package:breathpacer_mvp/utils/constant/toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'pineal_state.dart';

class PinealCubit extends Cubit<PinealState> {
  final AudioOrchestrator audio;

  PinealCubit(this.audio) : super(PinealInitial());

  int noOfSets = 1;
  int currentSet = 0;
  // int durationOfSet = 120;
  // bool recoveryBreath = false;
  bool jerryVoice = true;
  bool music = true;
  bool chimes = true;
  bool skipIntro = false;
  int recoveryBreathDuration = 20;
  // String jerryVoiceAssetFile = jerryVoiceOver(JerryVoiceEnum.pinealSqeez);
  int holdDuration = 20;
  // int breathingPeriod = 300;
  List<int> setsList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] ; 
  List<int> breathingDurationList = [30, 60, 120, 180, 240, 300, 360, 420, 480, 540, 600] ;
  List<int> holdDurationList = [10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 75, 90, 120] ;
  List<int> recoveryDurationList = [10, 20, 30, 60, 120] ;

  // List<int> breathingTimeList = []; //sec
  List<int> holdTimeList = []; //sec
  List<int> recoveryTimeList = []; //sec

  int selectedMusic = 1; 
  String musicPath = MusicTrack.track1.path;
  
  // int remainingBreathTime = 0;
  bool paused = false;
  bool isReatartEnable = false;
  bool isSaveDialogOn = false;
  // bool isFirstSet = true;

  void resetSettings(){
    jerryVoice = true;
    music = true;
    chimes = true;
    // isFirstSet = true;
    // durationOfSet = 120;
    isReatartEnable = false;
    holdDuration = 20;
    // breathingPeriod = 300;
    noOfSets = 1;
    skipIntro = false;
    recoveryBreathDuration = 20;

    currentSet = 0;
    // remainingBreathTime = 0;
    // breathingTimeList.clear();
    holdTimeList.clear();
    recoveryTimeList.clear();
    isSaveDialogOn = false;
    paused = false;
    
    emit(PinealInitial());
  }

  // void calculateRemainingBreathTime(int time){
  //   if((remainingBreathTime - time) < 0){
  //     remainingBreathTime = 0;
  //   }
  //   else{
  //     remainingBreathTime = remainingBreathTime - time ;
  //   }
  //   emit(PinealInitial());
  // }

  // void updateRemainingBreathTime(int time){
  //   remainingBreathTime = time ;
  //   emit(PinealInitial());
  // }

  void updateBreathing(int number){
    // breathingPeriod = number ;
    noOfSets = number ;
    emit(PinealBreathingUpdate(noOfSets));
  }

  void updateHold(int number){
    holdDuration = number ;
    emit(PinealHoldUpdate(holdDuration));
  }

  void updateRecovery(int number){
    recoveryBreathDuration = number ;
    emit(PinealRecoveryUpdate(recoveryBreathDuration));
  }

  void toggleJerryVoice(){
    jerryVoice = !jerryVoice ;
    emit(PinealToggleJerryVoice(jerryVoice));
  }

  void toggleMusic(){
    music = !music ;
    emit(PinealToggleMusic(music));
  }
  
  void toggleSkipIntro(){
    skipIntro = !skipIntro ;
    emit(PinealToggleSkipIntro(skipIntro));
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
    emit(PinealToggleMusic(music));
  }

  void toggleChimes(){
    chimes = !chimes ;
    emit(PinealToggleChimes(chimes));
  }

  // bool checkBreathingPeriod(){
  //   if(breathingPeriod % holdDuration == 0){
  //     return true;
  //   }
  //   else{
  //     return false;
  //   }
  // }


  late int waitingTime ;
  Future<void> playCloseEyes() async {
    try {
      if(jerryVoice){
        String path = '';
        if(skipIntro){
          path = GuideTrack.skipIntro.path ;
        }
        else{
          path = GuideTrack.pinealStart.path ;
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

  Future<void> playBeforeHold() async {
    try {
      if(jerryVoice){
        return await audio.playVoice(GuideTrack.pinealStartNext.path);
      }else{
        return ;
      }
    } on Exception catch (e) {
      log("playBeforeHold>> ${e.toString()}");
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


  void togglePause() {
    paused = !paused;
    try {
      if (paused) {
        audio.pauseAll();
        emit(PinealPaused());
      } else {
        audio.resumeAll();
        emit(PinealResumed());
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
    if(currentSet < noOfSets ){
      currentSet = currentSet + 1;
    }
  }

  
  void setToogleSaveDialog(){
    isSaveDialogOn = !isSaveDialogOn;
    emit(PinealToggleSave(isSaveDialogOn));
  }

  void onCloseDialogClick(){
    isSaveDialogOn = false;
    emit(PinealToggleSave(isSaveDialogOn));
  }

  List<PinealBreathworkModel> savedBreathwork = [];
  void onSaveClick(String text) async{
    if(text.isEmpty){
      emit(PinealToggleSave(isSaveDialogOn));
      return ;
    }

    var box = await Hive.openBox('pinealBreathworkBox');

    PinealBreathworkModel breathwork = PinealBreathworkModel(
      title: text,
      numberOfSets: noOfSets.toString(),
      jerryVoice: jerryVoice,
      music: music,
      chimes: chimes,
      breathingPeriod: noOfSets,
      // breathingPeriod: breathingPeriod,
      holdTimePerSet: holdDuration,
      recoveryTimePerSet: recoveryBreathDuration,
      breathingTimeList: holdTimeList,
      recoveryTimeList: recoveryTimeList
    );

    await box.add(breathwork.toJson());
   
    savedBreathwork.add(breathwork);
    isSaveDialogOn = false;

    updateSavedPinealBreathwork();
    
    showToast("Saved Successfuly");
    emit(PinealToggleSave(isSaveDialogOn));
  }

  void getAllSavedPinealBreathwork() async{
    var box = await Hive.openBox('pinealBreathworkBox');

    
    if(box.values.isEmpty || savedBreathwork.isNotEmpty){
      emit(PinealBreathworkFetched());
      return ;
    }

    savedBreathwork.clear();
    for (var item in box.values) {
      PinealBreathworkModel breathworks = PinealBreathworkModel.fromJson(Map<String, dynamic>.from(item));
      
      savedBreathwork.add(breathworks);
      emit(PinealBreathworkFetched());
    }
  }

  void updateSavedPinealBreathwork() async{
    var box = await Hive.openBox('pinealBreathworkBox');

    
    if(box.values.isEmpty){
      emit(PinealBreathworkFetched());
      return ;
    }

    savedBreathwork.clear();
    for (var item in box.values) {
      PinealBreathworkModel breathworks = PinealBreathworkModel.fromJson(Map<String, dynamic>.from(item));
      
      savedBreathwork.add(breathworks);
      emit(PinealBreathworkFetched());
    }
  }


  void deleteSavedPinealBreathwork(int index) async{
    var box = await Hive.openBox('pinealBreathworkBox');

    if(box.values.isEmpty){
      emit(PinealBreathworkFetched());
      return ;
    }
    
    var key = box.keyAt(index);
    await box.delete(key);
    savedBreathwork.removeAt(index);

    emit(PinealBreathworkFetched());
  }
  
}
