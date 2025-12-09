// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:breathpacer_mvp/bloc/pyramid/pyramid_cubit.dart';
import 'package:breathpacer_mvp/config/router/routes_name.dart';
import 'package:breathpacer_mvp/config/services/audio_services.dart';
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
  // late Timer _timer;
  // int _startTime = 0;

  @override
  void initState() {
    super.initState();

    startTimer();
    context.read<PyramidCubit>().playVoice(GuideTrack.nowHold.path);
    countdownController = CountdownController(autoStart: true);
  }

  @override
  void dispose() {
    // _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    // _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
    //   setState(() {
    //     _startTime++;

    //     if (context.read<PyramidCubit>().holdDuration == -1) {
    //       //~ ------- to start motivation when infinite hold -------
    //       // if (_startTime % 10 == 0 && _startTime > 10) {
    //       //   // context.read<PyramidCubit>().playHoldMotivation();
    //       // }
    //     }else{

    //       //~ ----------- play motivation -------------
    //       // if(context.read<PyramidCubit>().holdDuration >= 20 && (context.read<PyramidCubit>().holdDuration - _startTime) > 9 ){
    //       //   if(_startTime % 10 == 0){
    //       //     // context.read<PyramidCubit>().playMotivation();
    //       //     context.read<PyramidCubit>().playExtra(GuideTrack.noRegret.path);
    //       //   }

    //       // if( context.read<PyramidCubit>().holdDuration > 10 && (context.read<PyramidCubit>().holdDuration / 2).ceil()  == (context.read<PyramidCubit>().holdDuration - _startTime) ){
    //       //     context.read<PyramidCubit>().playMotivation();
    //       //     // context.read<PyramidCubit>().playExtra(GuideTrack.noRegret.path);
    //       // }
    //       //~ ----------- play motivation end ----------- 


    //       //~ to start last audios
    //       // playLastAudios();
    //     }
    //   });
    // });
  }

  void stopTimer() {
    try {
      // _timer.cancel();
    } catch (e) {
      log(e.toString());
    }
  }

  void resumeTimer() {
    startTimer();
  }

  void playLastAudios({required int min, required int sec, required bool doChange}) {
    final cubit = context.read<PyramidCubit>() ;
    // // if( min == 0 && sec > 1 && sec <= 6 ){
    // if( min == 0 && sec == (doChange?5:4) ){
    //   if(cubit.step == cubit.currentRound.toString() || (cubit.choiceOfBreathHold == BreathHoldChoice.both.name && cubit.breathHoldIndex == 0 )){
    //   // if( (cubit.step == cubit.currentRound.toString() || (cubit.choiceOfBreathHold == BreathHoldChoice.both.name && cubit.breathHoldIndex == 0)) && sec == 5 ){
    //     //~ last round || (both hold choosen && breatHoldIndex = 0)
    //     if(cubit.breathHoldIndex == 0){
    //       cubit.playExtra(GuideTrack.getReadyToBreathOut.path);
    //     }
    //     else if(cubit.breathHoldIndex == 1) {
    //       cubit.playExtra(GuideTrack.getReadyToBreathIn.path);
    //     }
    //   }
    //   else if(cubit.breathHoldIndex == 0){
    //   // else if(cubit.breathHoldIndex == 0 && sec == 4){
    //     cubit.playExtra(GuideTrack.breathOutNext.path);
    //   }
    //   else if(cubit.breathHoldIndex == 1) {
    //   // else if(cubit.breathHoldIndex == 1 && sec == 6) {
    //     cubit.playExtra(GuideTrack.breathInNext.path);
    //   }
    // }
    if((cubit.step == cubit.currentRound.toString() || (cubit.choiceOfBreathHold == BreathHoldChoice.both.name && cubit.breathHoldIndex == 0 ) ) && min == 0 && sec == (doChange?5:5)){
      if(cubit.breathHoldIndex == 0){
        cubit.playExtra(GuideTrack.getReadyToBreathOut.path);
      }
      else if(cubit.breathHoldIndex == 1) {
        cubit.playExtra(GuideTrack.getReadyToBreathIn.path);
      }
    }
    else if( min == 0 && sec == (doChange?5:6) && cubit.step != cubit.currentRound.toString() ){
      if(cubit.breathHoldIndex == 0){
        cubit.playExtra(GuideTrack.breathOutNext.path);
      }
      else if(cubit.breathHoldIndex == 1) {
        cubit.playExtra(GuideTrack.breathInNext.path);
      }
    }
    else if(min == 0 && sec == 1){
      if(cubit.breathHoldIndex == 0 && doChange == false){
        cubit.playExtra(GuideTrack.singleBreathOut.path);
      }
      else if(cubit.breathHoldIndex == 1) {
        //~ only pay for last round
        if(cubit.step == cubit.currentRound.toString()){
          cubit.playExtra(GuideTrack.singleBreathIn.path);
        }
        // cubit.playExtra(GuideTrack.singleBreathIn.path);
      }
    }
  }

  void storeScreenTime() {
    final cubit = context.read<PyramidCubit>();
    if (cubit.breathHoldIndex == 0 || cubit.breathHoldIndex == 2) {
      cubit.holdInbreathTimeList.add(
        cubit.holdDuration
      ); 
    } else {
      cubit.holdBreathoutTimeList.add(
        cubit.holdDuration
      ); 
    }

    if (kDebugMode) {
      log(">> breath hold Time: ${cubit.holdDuration}");
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
                                onFinished: () async{
                                  stopTimer();
                                  storeScreenTime();
                                  if(context.read<PyramidCubit>().choiceOfBreathHold == BreathHoldChoice.both.name && context.read<PyramidCubit>().breathHoldIndex == 0){
                                    context.read<PyramidCubit>().breathHoldIndex = 1;

                                    await Future.delayed(const Duration(milliseconds: 600), () {
                                      context.pushReplacementNamed(RoutesName.pyramidBreathHoldScreen);
                                      context.read<PyramidCubit>().playChime();
                                    },);
                                  }else{
                                    // context.goNamed(RoutesName.waitingAfterHoldScreen);
                                    navigate(context.read<PyramidCubit>());
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
    final cubit =context.read<PyramidCubit>();
    int minutes = (time / 60).floor();
    int seconds = (time % 60).floor();

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    //~ ----------- play motivation start ---------
    final midTime = (cubit.holdDuration / 2).ceil() ;
    if( cubit.holdDuration > 10 && (cubit.holdDuration - time.toInt()) == midTime ){
        cubit.playMotivation();
    }
    //~ ----------- play motivation end -----------

    playLastAudios(min: minutes, sec: seconds, doChange: cubit.breathHoldIndex == 0 && cubit.choiceOfBreathHold == BreathHoldChoice.both.name);

    // if(cubit.breathHoldIndex == 0 && cubit.choiceOfBreathHold == BreathHoldChoice.both.name){
    if( (cubit.breathHoldIndex == 0 && cubit.choiceOfBreathHold == BreathHoldChoice.both.name) || cubit.breathHoldIndex == 0 || cubit.breathHoldIndex == 1 ){
      if(seconds == 3 && minutes == 0){
        cubit.playExtra(GuideTrack.three.path);
      }
      else if(seconds == 2 && minutes == 0){
        cubit.playExtra(GuideTrack.two.path);
      }
      else if(seconds == 1 && minutes == 0){
        cubit.playExtra(GuideTrack.one.path);
      }
      else if(seconds == 0 && minutes == 0){
        cubit.playExtra(GuideTrack.singleBreathOut.path);
      }
    }

    return "$minutesStr:$secondsStr";
  }


  //~ inplace of waiting screen after hold when countdown fineshed
  void navigate(PyramidCubit cubit) async{
    if(cubit.choiceOfBreathHold == BreathHoldChoice.both.name && cubit.breathHoldIndex == 0){
      cubit.breathHoldIndex = 1;
      context.read<PyramidCubit>().audio.stop(AudioChannel.voice);
      
      // context.read<PyramidCubit>().playTimeToHoldOutBreath();

      await Future.delayed(const Duration(seconds: 0), () {
        // context.read<PyramidCubit>().playHold();
        // context.read<PyramidCubit>().playTimeToHoldOutBreath();
        context.read<PyramidCubit>().playChime();
        context.pushReplacementNamed(RoutesName.pyramidBreathHoldScreen);
      },);
    } 
    else{
      if(cubit.step == cubit.currentRound.toString()){
        await context.read<PyramidCubit>().audio.stopAll();
        context.read<PyramidCubit>().playChime();


        if (kDebugMode) {
          print("pyramid rounds finished");
        }
        context.goNamed(RoutesName.pyramidSuccessScreen);
      }else{
        await Future.delayed(const Duration(seconds: 0), () {
          context.read<PyramidCubit>().updateRound();
          context.read<PyramidCubit>().playChime();
          context.goNamed(RoutesName.pyramidBreathingScreen);
        },);
      }
    }
  }
  
}
