import 'dart:async';
import 'dart:developer';

import 'package:breathpacer_mvp/bloc/pyramid/pyramid_cubit.dart';
import 'package:breathpacer_mvp/config/router/routes_name.dart';
import 'package:breathpacer_mvp/config/theme.dart';
import 'package:breathpacer_mvp/utils/constant/interaction_breathing_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class PyramidBreathHoldScreen extends StatefulWidget {
  const PyramidBreathHoldScreen({super.key});

  @override
  State<PyramidBreathHoldScreen> createState() =>
      _PyramidBreathHoldScreenState();
}

class _PyramidBreathHoldScreenState extends State<PyramidBreathHoldScreen> {
  late CountdownController countdownController;
  late Timer _timer;
  int _startTime = 0;

  @override
  void initState() {
    super.initState();

    startTimer();
    context.read<PyramidCubit>().playVoice(GuideTrack.nowHold.path);
    countdownController = CountdownController(autoStart: true);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _startTime++;

        if (context.read<PyramidCubit>().holdDuration == -1) {
          //~ ------- to start motivation when infinite hold -------
          // if (_startTime % 10 == 0 && _startTime > 10) {
          //   // context.read<PyramidCubit>().playHoldMotivation();
          // }
        }else{

          //~ ----------- play motivation -------------
          if(context.read<PyramidCubit>().holdDuration >= 20 && (context.read<PyramidCubit>().holdDuration - _startTime) > 9 ){
            if(_startTime % 10 == 0){
              context.read<PyramidCubit>().playMotivation();
            }
          }
          //~ ----------- play motivation end ----------- 

          //~ to start last audios
          playLastAudios();
        }
      });
    });
  }

  void stopTimer() {
    try {
      _timer.cancel();
    } catch (e) {
      log(e.toString());
    }
  }

  void resumeTimer() {
    startTimer();
  }

  void playLastAudios() {
    final cubit = context.read<PyramidCubit>() ;
    if(context.read<PyramidCubit>().holdDuration - _startTime == 4){
      if(cubit.step == cubit.currentRound.toString() || (cubit.choiceOfBreathHold == BreathHoldChoice.both.name && cubit.breathHoldIndex == 0)){
        //~ last round || (both hold choosen && breatHoldIndex = 0)
        if(cubit.breathHoldIndex == 0){
          cubit.playExtra(GuideTrack.getReadyToBreathOut.path);
        }
        else if(cubit.breathHoldIndex == 1) {
          cubit.playExtra(GuideTrack.getReadyToBreathIn.path);
        }
      }
      else if(cubit.breathHoldIndex == 0){
        cubit.playExtra(GuideTrack.breathOutNext.path);
      }
      else if(cubit.breathHoldIndex == 1) {
        cubit.playExtra(GuideTrack.breathInNext.path);
      }
    }
    else if(cubit.holdDuration - _startTime == 1){
      if(cubit.breathHoldIndex == 0){
        cubit.playExtra(GuideTrack.singleBreathOut.path);
      }
      else if(cubit.breathHoldIndex == 1) {
        cubit.playExtra(GuideTrack.singleBreathIn.path);
      }
    }
  }

  String get getScreenTiming {
    int minutes = _startTime ~/ 60;
    int seconds = _startTime % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  void storeScreenTime() {
    if (context.read<PyramidCubit>().breathHoldIndex == 0 ||
        context.read<PyramidCubit>().breathHoldIndex == 2) {
      context.read<PyramidCubit>().holdInbreathTimeList.add(
        _startTime - 1 < 0 ? 0 : _startTime - 1,
      ); //~ -1 is added due to starttime auto increased 1 sec more
    } else {
      context.read<PyramidCubit>().holdBreathoutTimeList.add(
        _startTime - 1 < 0 ? 0 : _startTime - 1,
      ); //~ -1 is added due to starttime auto increased 1 sec more
    }

    if (kDebugMode) {
      log(">> breath hold Time: $getScreenTiming");
    }
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocConsumer<PyramidCubit, PyramidState>(
      listener: (context, state) {
        if (state is PyramidPaused){
          countdownController.pause();
          stopTimer();
        }
        if (state is PyramidResumed){
          countdownController.resume();
          startTimer();
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: Scaffold(
            body: Container(
              width: size,
              height: height,
              decoration: BoxDecoration(
                gradient: AppTheme.colors.linearGradient,
              ),
              child: Column(
                children: [
                  AppBar(
                    iconTheme: const IconThemeData(color: Colors.white),
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: GestureDetector(
                      onTap: () {
                        countdownController.pause();
                        stopTimer();

                        context.read<PyramidCubit>().resetSettings(
                          context.read<PyramidCubit>().step ?? '',
                          context.read<PyramidCubit>().speed ?? '',
                        );

                        context.goNamed(RoutesName.homeScreen);
                      },
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                    title: Text(
                      "Round ${context.read<PyramidCubit>().currentRound}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      IconButton(
                        onPressed: context.read<PyramidCubit>().togglePause,
                        icon: Icon(
                          context.read<PyramidCubit>().paused
                              ? Icons.play_arrow
                              : Icons.pause,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),

                      SizedBox(width: size * 0.03),
                    ],
                  ),
                  SizedBox(height: size * 0.02),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: size * 0.05),
                    color: Colors.white.withValues(alpha:.3),
                    height: 1,
                  ),

                  //~
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.1),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: size * 0.05),
                          alignment: Alignment.center,
                          child: Text(
                            checkBreathChoice(context) == "in-breath"
                                ? "Hold At Top of Inhale"
                                : "Hold at Bottom of Exhale",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.05),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: size * 0.12),
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: size * 0.3,
                            child: Image.asset(ImagePath.holdImage.path),
                          ),
                        ),

                        // if (context.read<PyramidCubit>().holdDuration != -1)
                          Container(
                            margin: EdgeInsets.only(
                              top: height * 0.04,
                              bottom: height * 0.04,
                            ),
                            width: size,
                            alignment: Alignment.center,
                            child: Center(
                              child: Countdown(
                                controller: countdownController,
                                seconds:context.read<PyramidCubit>().holdDuration,
                                build: (BuildContext context, double time) {
                                  return Text(
                                    formatTimer(time),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size * 0.2,
                                    ),
                                  );
                                },
                                interval: const Duration(seconds: 1),
                                onFinished: () {
                                  stopTimer();
                                  storeScreenTime();
                                  if(context.read<PyramidCubit>().choiceOfBreathHold == BreathHoldChoice.both.name && context.read<PyramidCubit>().breathHoldIndex == 0){
                                    context.read<PyramidCubit>().breathHoldIndex = 1;
                                    context.pushReplacementNamed(RoutesName.pyramidBreathHoldScreen);
                                  }else{
                                    context.goNamed(RoutesName.waitingAfterHoldScreen);
                                  }
                                  // context.goNamed(RoutesName.waitingAfterHoldScreen);
                                },
                              ),
                            ),
                          ),

                        const Spacer(),

                        SizedBox(height: height * 0.08),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String checkBreathChoice(BuildContext context) {
    log(
      "breathHoldIndex check-> ${context.read<PyramidCubit>().breathHoldIndex}",
      name: "toggleBreathHold",
    );
    if (context.read<PyramidCubit>().breathHoldIndex == 0) {
      return 'in-breath';
    } else {
      return 'out-breath';
    }
  }

  String formatTimer(double time) {
    int minutes = (time / 60).floor();
    int seconds = (time % 60).floor();

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    // //~ to start motivation
    // if(context.read<PyramidCubit>().holdDuration >= 20){
    //   if(time % 11 == 0 && time.toDouble() != context.read<PyramidCubit>().holdDuration && (context.read<PyramidCubit>().holdDuration - time) > 7 && int.parse(secondsStr) > 6){
    //     context.read<PyramidCubit>().playHoldMotivation();
    //   }
    // }
    // // if(context.read<PyramidCubit>().holdDuration >= 30){
    // //   if(time % 15 == 0 && time.toDouble() != context.read<PyramidCubit>().holdDuration && (context.read<PyramidCubit>().holdDuration - time) > 10 && int.parse(secondsStr) > 6){
    // //     context.read<PyramidCubit>().playHoldMotivation();
    // //   }
    // // }

    // //~ to start 3_2_1 voice
    // bool isLastRound = false;
    // if(context.read<PyramidCubit>().step == context.read<PyramidCubit>().currentRound.toString()){
    //   isLastRound = true;
    // }
    // if(secondsStr == "02"  && context.read<PyramidCubit>().choiceOfBreathHold != "Both"){
    //   context.read<PyramidCubit>().playHoldCountdown(isLastRound: isLastRound);
    // }
    // else if(secondsStr == "02" && context.read<PyramidCubit>().choiceOfBreathHold == "Both" && context.read<PyramidCubit>().breathHoldIndex == 0){
    //   context.read<PyramidCubit>().playHoldCountdown(isBoth: true, isLastRound: isLastRound);
    // }
    // else if(secondsStr == "02" && context.read<PyramidCubit>().choiceOfBreathHold == "Both" && context.read<PyramidCubit>().breathHoldIndex != 0){
    //   context.read<PyramidCubit>().playHoldCountdown(isBoth: true, isLastRound: isLastRound);
    // }
    // // if(secondsStr == "06" && context.read<PyramidCubit>().holdDuration != 10){
    // //   context.read<PyramidCubit>().playHoldCountdown();
    // // }
    // // if(secondsStr == "06" && context.read<PyramidCubit>().holdDuration == 10){
    // //   context.read<PyramidCubit>().playHoldCountdown();
    // // }

    return "$minutesStr:$secondsStr";
  }

  // String generateTapText(PyramidCubit cubit) {
  //   if(cubit.choiceOfBreathHold == "Both" && cubit.breathHoldIndex == 0){
  //     return "Tap to hold ${cubit.breathHoldList[1]}";
  //   }
  //   else{
  //     // if(cubit.recoveryBreath){
  //     if(1 > 2){
  //       return "Tap to go to recovery breath";
  //     }else{
  //       if(cubit.step == cubit.currentRound.toString() ){
  //         return "Tap to finish";
  //       }else{
  //         return "Tap to go to next set";
  //       }
  //     }
  //   }
  // }

  // void navigate(PyramidCubit cubit) async{
  //   if(cubit.choiceOfBreathHold == "Both" && cubit.breathHoldIndex == 0){
  //     cubit.breathHoldIndex = 1;
  //     context.read<PyramidCubit>().stopHold();

  //     // context.read<PyramidCubit>().playTimeToHoldOutBreath();
  //     await Future.delayed(const Duration(seconds: 0), () {
  //       // context.read<PyramidCubit>().playHold();
  //       context.read<PyramidCubit>().playTimeToHoldOutBreath();
  //       context.pushReplacementNamed(RoutesName.pyramidBreathHoldScreen);
  //     },);
  //   }
  //   else{
  //     cubit.stopHold();
  //     if(1 > 2){
  //       // context.read<PyramidCubit>().playRecovery();
  //       // context.goNamed(RoutesName.dnaRecoveryScreen);
  //     }else{
  //       if(cubit.step == cubit.currentRound.toString()){
  //         cubit.stopMusic();
  //         cubit.stopJerry();
  //         cubit.playChime();

  //         if (kDebugMode) {
  //           print("pyramid rounds finished");
  //         }
  //         context.goNamed(RoutesName.pyramidSuccessScreen);
  //       }else{
  //         // cubit.currentRound = cubit.currentRound+1;
  //         // cubit.resetJerryVoiceAndPLayAgain();

  //         // context.read<PyramidCubit>().playTimeToNextSet();
  //         await Future.delayed(const Duration(seconds: 0), () {
  //           cubit.currentRound = cubit.currentRound+1;
  //           context.goNamed(RoutesName.pyramidBreathingScreen);
  //         },);
  //       }
  //     }
  //   }
  // }
}
