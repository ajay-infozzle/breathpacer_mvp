import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:breathpacer_mvp/config/model/fire_breathwork_model.dart';
import 'package:breathpacer_mvp/config/services/audio_services.dart';
import 'package:breathpacer_mvp/utils/constant/interaction_breathing_constant.dart';
import 'package:breathpacer_mvp/utils/constant/toast.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'firebreathing_state.dart';

class FirebreathingCubit extends Cubit<FirebreathingState> {
  final AudioOrchestrator audio;
  
  FirebreathingCubit(this.audio) : super(FirebreathingInitial());

  int noOfSets = 1;
  int currentSet = 0;
  int durationOfSets = 30;  //sec
  bool recoveryBreath = false;
  int recoveryBreathDuration = 10;
  bool holdingPeriod = false;
  int holdDuration = 20;
  bool jerryVoice = true;
  bool music = true;
  bool chimes = true;
  bool pineal = false;
  bool skipIntro = false;

  String choiceOfBreathHold = BreathHoldChoice.breatheIn.name;
  int breathHoldIndex = 0;
  List<String> breathHoldList = [BreathHoldChoice.breatheIn.name, BreathHoldChoice.breatheOut.name] ; 
  List<int> setsList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] ; 
  List<int> durationsList = [30, 60, 120, 180, 240, 300, 360, 420, 480, 540, 600, 660, 720, 780, 840, 900, 960, 1020, 1080, 1140, 1200] ; //sec
  List<int> recoveryDurationList = [10,20, 30, 40, 60, 120, 180] ;
  List<int> holdDurationList = [10, 20, 30, 40, 50, 60] ;

  int selectedMusic = 1; 
  String musicPath = MusicTrack.track1.path;

  bool isReatartEnable = false;
  bool isSaveDialogOn = false;

  late int waitingTime ;
  bool paused = false;

  List<int> breathingTimeList = []; //sec
  List<int> holdTimeList = []; //sec
  List<int> recoveryTimeList = []; //sec

  List<FireBreathworkModel> savedBreathwork = [];


  void initialSettings(String stepp, String speedd){
    noOfSets = 1;
    currentSet = 0;
    durationOfSets = 30;
    jerryVoice = false;
    music = true;
    chimes = true;
    pineal = false;
    recoveryBreath = false;
    recoveryBreathDuration = 10;
    holdingPeriod = false;
    holdDuration = 20;
    isReatartEnable = true ;
    breathHoldIndex = 0;
    isSaveDialogOn = false;
  
    emit(FirebreathingInitial());
  }


  void resetSettings(){
    jerryVoice = true;
    pineal = false;
    music = true;
    chimes = true;
    isReatartEnable = false;
    recoveryBreath = false;
    holdingPeriod = false;
    paused = false;

    currentSet = 0;
    breathingTimeList.clear();
    holdTimeList.clear();
    recoveryTimeList.clear();

    audio.reset(); 
 
    emit(FirebreathingInitial());
  }


  void updateSetsDuration(int sec){
    durationOfSets = sec ;
    emit(FirebreathingUpdateSetDuration(sec));
  }

  void updateSetsNumber(int number){
    noOfSets = number ;
    emit(FirebreathingUpdateSetNumber(number));
  }

  void toggleRecoveryBreath(){
    recoveryBreath = !recoveryBreath ;
    emit(FirebreathingToggleRecoveryBreath(recoveryBreath));
  }

  void updateRecoveryDuration(int number){
    recoveryBreathDuration = number ;
    emit(FirebreathingUpdateSetDuration(number));
  }

  void toggleHolding(){
    holdingPeriod = !holdingPeriod ;
    emit(FirebreathingToggleHolding(holdingPeriod));
  }

  void updateHold(int number){
    bool temp = holdDuration == number ? true : false;
    holdDuration = number ;
    emit(FirebreathingToggleHolding(temp));
  }

  void toggleJerryVoice(){
    jerryVoice = !jerryVoice ;
    emit(FirebreathingToggleJerryVoice(jerryVoice));
  }

  void togglePineal(){
    pineal = !pineal ;
    emit(FirebreathingTogglePineal(pineal));
  }

  void toggleMusic(){
    music = !music ;
    emit(FirebreathingToggleMusic(music));
  }

  void toggleSkipIntro(){
    skipIntro = !skipIntro ;
    emit(FirebreathingToggleSkipIntro(skipIntro));
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
    emit(FirebreathingToggleMusic(music));
  }

  void toggleChimes(){
    chimes = !chimes ;
    emit(FirebreathingToggleChimes(chimes));
  }

  void toggleBreathHold(int index){
    choiceOfBreathHold =  breathHoldList[index];
    breathHoldIndex = index;
    emit(FirebreathingToggleBreathHoldChoice(index));
  }

  void playCloseEyes() async {
    try {
      if(jerryVoice){
        String path = '';
        if(skipIntro){
          path = GuideTrack.skipIntro.path ;
        }
        else if(pineal){
          path = GuideTrack.firebreathingPinealStart.path ;
        }
        else{
          path = GuideTrack.firebreathingStart.path ;
        }

        waitingTime = await audio.playVoiceAndGetDuration(path);
        emit(NavigateToWaitingScreen());
      }
      else{
        waitingTime = 5;
        emit(NavigateToWaitingScreen());
      }
    } on Exception catch (e) {
      log("closeEyesMusic>> ${e.toString()}");
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
  
  void togglePause() {
    paused = !paused;
    try {
      if (paused) {
        audio.pauseAll();
        emit(FirebreathingPaused());
      } else {
        audio.resumeAll();
        emit(FirebreathingResumed());
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

  // void playHold() async {
  //   try {
  //     if(jerryVoice){
  //       if(breathHoldIndex == 0){
  //         await breathHoldPlayer.play(AssetSource('audio/hold_in_breath.mp3'));
  //       }
  //       if(breathHoldIndex == 1){
  //         await breathHoldPlayer.play(AssetSource('audio/hold_out_breath.mp3'));
  //       }
  //     }
  //   } on Exception catch (e) {
  //     if (kDebugMode) {
  //       print("playHold>> ${e.toString()}");
  //     }
  //   }
  // }


  // void playHoldCountdown({required bool isLastRound}) async {
  //   try {
  //     if(jerryVoice){
  //       breathHoldPlayer.stop();
  //       if(breathHoldIndex == 0){
  //         if(isLastRound && recoveryBreath == false){
  //           await breathHoldPlayer.play(AssetSource('audio/ready_to_breath_out_countdown_at_end.mp3'));
  //           return ;
  //         }

  //         recoveryBreath 
  //         ?await breathHoldPlayer.play(AssetSource('audio/breathing_out_recovery_countdown.mp3'))
  //         :await breathHoldPlayer.play(AssetSource('audio/pyramid_breath_out_countdown.mp3'));
  //       }else{
  //         if(isLastRound && recoveryBreath == false){
  //           await breathHoldPlayer.play(AssetSource('audio/ready_to_breath_in_countdown_at_end.mp3'));
  //           return ;
  //         }

  //         recoveryBreath 
  //         ?await breathHoldPlayer.play(AssetSource('audio/breathing_in_recovery_countdown.mp3'))
  //         :await breathHoldPlayer.play(AssetSource('audio/pyramid_breath_in_countdown.mp3'));
  //       }
  //       // if(holdDuration == 10){
  //       //   // await breathHoldPlayer.play(AssetSource('audio/single_3_2_1.mp3'));
          
  //       //   if(breathHoldIndex == 0){
  //       //     recoveryBreath 
  //       //     ?await breathHoldPlayer.play(AssetSource('audio/breathing_out_recovery_countdown.mp3'))
  //       //     :await breathHoldPlayer.play(AssetSource('audio/pyramid_breath_out_countdown.mp3'));
  //       //   }else{
  //       //     recoveryBreath 
  //       //     ?await breathHoldPlayer.play(AssetSource('audio/breathing_in_recovery_countdown.mp3'))
  //       //     :await breathHoldPlayer.play(AssetSource('audio/pyramid_breath_in_countdown.mp3'));
  //       //   }
  //       // }else{
  //       //   // await breathHoldPlayer.play(AssetSource('audio/3_2_1.mp3'));
          
  //       //   if(breathHoldIndex == 0){
  //       //     recoveryBreath 
  //       //     ?await breathHoldPlayer.play(AssetSource('audio/breathing_out_recovery_countdown.mp3'))
  //       //     :await breathHoldPlayer.play(AssetSource('audio/pyramid_breath_out_countdown.mp3'));
  //       //   }else{
  //       //     recoveryBreath 
  //       //     ?await breathHoldPlayer.play(AssetSource('audio/breathing_in_recovery_countdown.mp3'))
  //       //     :await breathHoldPlayer.play(AssetSource('audio/pyramid_breath_in_countdown.mp3'));
  //       //   }
  //       // }
  //     }
  //   } on Exception catch (e) {
  //     if (kDebugMode) {
  //       print("playHoldCountdown>> ${e.toString()}");
  //     }
  //   }
  // }

  // void playTimeToHold() async {
  //   try {
  //     if(jerryVoice){
  //       breathHoldPlayer.stop();
        
  //       if(holdingPeriod){
  //         breathHoldIndex  == 0 
  //         ? await breathHoldPlayer.play(AssetSource('audio/countdown_for_breathe_in_and_hold.mp3'))
  //         : await breathHoldPlayer.play(AssetSource('audio/countdown_for_breathe_out_and_hold.mp3'));
  //       }else if(recoveryBreath){
  //        await breathHoldPlayer.play(AssetSource('audio/breathing_in_recovery_countdown.mp3'));
  //       }
  //     }
  //     else{
  //       playChime();
  //     }
  //   } on Exception catch (e) {
  //     if (kDebugMode) {
  //       print("playTimeToHold>> ${e.toString()}");
  //     }
  //   }
  // }

  // void playHoldMotivation() async {
  //   try {
  //     if(jerryVoice){
  //       if(jerryVoicePlayer.state != PlayerState.playing) jerryVoicePlayer.stop();

  //       breathHoldPlayer.stop();
  //       await breathHoldPlayer.play(AssetSource('audio/motivation.mp3'));
  //     }
  //   } on Exception catch (e) {
  //     if (kDebugMode) {
  //       print("playHoldMotivation>> ${e.toString()}");
  //     }
  //   }
  // }
  

  // void playRecovery() async {
  //   try {
  //     if(jerryVoice){
  //       await recoveryPlayer.play(AssetSource('audio/recover.mp3'));
  //     }
  //   } on Exception catch (e) {
  //     if (kDebugMode) {
  //       print("playRecovery>> ${e.toString()}");
  //     }
  //   }
  // }

  // void playTimeToRecover() async {
  //   try {
  //     if(jerryVoice){
  //       recoveryPlayer.stop();
  //       // await recoveryPlayer.play(AssetSource('audio/time_to_recover.mp3'));
  //       await recoveryPlayer.play(AssetSource('audio/recover_short.mp3'));
  //     }
  //     else{
  //       playChime();
  //     }
  //   } on Exception catch (e) {
  //     if (kDebugMode) {
  //       print("playTimeToRecover>> ${e.toString()}");
  //     }
  //   }
  // }

  // void stopRecovery() async {
  //   try {
  //     if(jerryVoice){
  //       await recoveryPlayer.stop();
  //     }
  //   } on Exception catch (e) {
  //     if (kDebugMode) {
  //       print("stopRecovery>> ${e.toString()}");
  //     }
  //   }
  // }

  // void playRelax() async {
  //   try {
  //     if(jerryVoice){
  //       await relaxPlayer.play(AssetSource('audio/relax.mp3'), );
      
  //       //~ Listen for when completed
  //       relaxPlayer.onPlayerComplete.listen((event) {
  //         relaxPlayer.stop();
  //       });
  //     }
  //   } on Exception catch (e) {
  //     if (kDebugMode) {
  //       print("playRelax>> ${e.toString()}");
  //     }
  //   }
  // }

  void setToogleSaveDialog(){
    isSaveDialogOn = !isSaveDialogOn;
    emit(FirebreathingToggleSave(isSaveDialogOn));
  }

  void onCloseDialogClick(){
    isSaveDialogOn = false;
    emit(FirebreathingToggleSave(isSaveDialogOn));
  }

  void onSaveClick(String text) async{
    if(text.isEmpty){
      emit(FirebreathingToggleSave(false));
      return ;
    }


    var box = await Hive.openBox('fireBreathworkBox');

    FireBreathworkModel breathwork = FireBreathworkModel(
      title: text,
      holdPeriodEnabled: holdingPeriod,
      numberOfSets: noOfSets.toString(),
      durationOfEachSet: durationOfSets,
      recoveryEnabled: recoveryBreath,
      jerryVoice: jerryVoice,
      music: music,
      chimes: chimes,
      pineal: pineal,
      choiceOfBreathHold: choiceOfBreathHold,
      holdDuration: holdDuration,
      recoveryDuration: recoveryBreathDuration,
      breathingTimeList: breathingTimeList,
      holdTimeList: holdTimeList,
      recoveryTimeList: recoveryTimeList
    );

    await box.add(breathwork.toJson());
   
    savedBreathwork.add(breathwork);
    isSaveDialogOn = false;

    updateSavedFireBreathwork();
    
    showToast("Saved Successfuly");
    emit(FirebreathingToggleSave(true));
  }

  void getAllSavedFireBreathwork() async{
    var box = await Hive.openBox('fireBreathworkBox');

    if(box.values.isEmpty || savedBreathwork.isNotEmpty){
      emit(FireBreathworkFetched(false));
      return ;
    }

    savedBreathwork.clear();
    for (var item in box.values) {
      FireBreathworkModel breathworks = FireBreathworkModel.fromJson(Map<String, dynamic>.from(item));
      
      savedBreathwork.add(breathworks);
      emit(FireBreathworkFetched(true));
    }
  }

  void updateSavedFireBreathwork() async{
    var box = await Hive.openBox('fireBreathworkBox');

    if(box.values.isEmpty){
      emit(FireBreathworkFetched(false));
      return ;
    }

    savedBreathwork.clear();
    for (var item in box.values) {
      FireBreathworkModel breathworks = FireBreathworkModel.fromJson(Map<String, dynamic>.from(item));
      
      savedBreathwork.add(breathworks);
      emit(FireBreathworkFetched(true));
    }
  }

  void deleteSavedFireBreathwork(int index) async{
    var box = await Hive.openBox('fireBreathworkBox');

    if(box.values.isEmpty){
      emit(FireBreathworkFetched(false));
      return ;
    }
    
    var key = box.keyAt(index);
    await box.delete(key);
    savedBreathwork.removeAt(index);

    emit(FireBreathworkFetched(true));
  }


}
