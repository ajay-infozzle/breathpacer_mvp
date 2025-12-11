// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:breathpacer_mvp/bloc/pineal/pineal_cubit.dart';
import 'package:breathpacer_mvp/config/router/routes_name.dart';
import 'package:breathpacer_mvp/config/theme.dart';
import 'package:breathpacer_mvp/utils/constant/interaction_breathing_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class PinealScreen extends StatefulWidget {
  const PinealScreen({super.key});

  @override
  State<PinealScreen> createState() => _PinealScreenState();
}

class _PinealScreenState extends State<PinealScreen> {
  late CountdownController holdCountdownController;

  @override
  void initState() {
    super.initState();

    startGuide();
    holdCountdownController = CountdownController(autoStart: false);
  }

  void startGuide() async{
    await context.read<PinealCubit>().playBeforeHold();
    holdCountdownController.start();
  }

  void storeScreenTime() {
    context.read<PinealCubit>().holdTimeList.add(
      context.read<PinealCubit>().holdDuration,
    );

    if (kDebugMode) {
      print("breath hold Time: ${context.read<PinealCubit>().holdDuration}");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return BlocConsumer<PinealCubit, PinealState>(
      listener: (context, state) {
        if (state is PinealPaused) {
          holdCountdownController.pause();
        } else if (state is PinealResumed) {
          holdCountdownController.resume();
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
                    scrolledUnderElevation: 0,
                    iconTheme: const IconThemeData(color: Colors.white),
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                    leading: GestureDetector(
                      onTap: () {
                        holdCountdownController.pause();
                        context.read<PinealCubit>().resetSettings();

                        context.goNamed(RoutesName.homeScreen);
                      },
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                    title: Text(
                      "Set ${context.read<PinealCubit>().currentSet}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      if( !(holdCountdownController.isCompleted??false) )
                      IconButton(
                        onPressed: context.read<PinealCubit>().togglePause,
                        icon: Icon(
                          context.read<PinealCubit>().paused ? Icons.play_arrow : Icons.pause,
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
                    color: Colors.white.withOpacity(.3),
                    height: 1,
                  ),

                  //~
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(0),
                      children: [
                        SizedBox(height: height * 0.03),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: size * 0.05),
                          alignment: Alignment.center,
                          child: Text(
                            "Squeeze & Hold on Breathe in",
                            // "Squeeze & Breathe in",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.03),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: size * 0.12),
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: size * 0.25,
                            child: Image.asset(ImagePath.breathInIcon.path),
                          ),
                        ),


                        // if (context.read<PinealCubit>().holdDuration != -1)
                        Container(
                          margin: EdgeInsets.only(top: height * 0.04),
                          width: size,
                          alignment: Alignment.center,
                          child: Center(
                            child: Text(
                              "Hold for:",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: size * 0.045,
                              ),
                            ),
                          ),
                        ),

                        // if (context.read<PinealCubit>().holdDuration != -1)
                          Container(
                            margin: EdgeInsets.only(top: height * 0.001),
                            width: size,
                            alignment: Alignment.center,
                            child: Center(
                              child: Countdown(
                                controller: holdCountdownController,
                                seconds:
                                    context.read<PinealCubit>().holdDuration,
                                build: (BuildContext cnt, double time) {
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
                                  final cubit = context.read<PinealCubit>();

                                  storeScreenTime();
                                  
                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () async{
                                      await cubit.playExtra(GuideTrack.nowRecover.path);
                                      
                                      // if(cubit.currentSet != cubit.noOfSets && cubit.recoveryBreath == false){
                                      //   await cubit.playExtra(GuideTrack.timeToNextSet.path);
                                      // }

                                      cubit.playChime();
                                      navigate(cubit);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),

                        
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

  String formatTimer(double time) {
    int minutes = (time / 60).floor();
    int seconds = (time % 60).floor();

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    final cubit = context.read<PinealCubit>();

    final midTime = (cubit.holdDuration / 2).ceil() ;
    if(cubit.holdDuration > 10 && (cubit.holdDuration - time.toInt()) == midTime ){
      cubit.playMotivation();
      // cubit.playExtra(GuideTrack.noRegret.path);
    }
    if(minutes == 1 && seconds == 0 && cubit.holdDuration > 60){
      cubit.playExtra(GuideTrack.minToGo1.path);
    }
    else if(minutes == 2 && seconds == 0 && cubit.holdDuration > 120){
      cubit.playExtra(GuideTrack.minToGo2.path);
    }
    else if(minutes == 3 && seconds == 0 && cubit.holdDuration > 180){
      cubit.playExtra(GuideTrack.minToGo3.path);
    }
    else if(minutes == 4 && seconds == 0 && cubit.holdDuration > 240){
      cubit.playExtra(GuideTrack.minToGo4.path);
    }
    else if(minutes == 5 && seconds == 0 && cubit.holdDuration > 300){
      cubit.playExtra(GuideTrack.minToGo5.path);
    }
    else if(seconds == 30 && minutes == 0 && cubit.holdDuration > 30){
      cubit.playExtra(GuideTrack.secToGo30.path);
    }
    else if(seconds == 5 && minutes == 0){
      //~ default hold is in-breath 
      cubit.playVoice(GuideTrack.getReadyToBreathOut.path);
    }
    else if(seconds == 3 && minutes == 0){
      cubit.playExtra(GuideTrack.three.path);
    }
    else if(seconds == 2 && minutes == 0){
      cubit.playExtra(GuideTrack.two.path);
    }
    else if(seconds == 1 && minutes == 0){
      cubit.playExtra(GuideTrack.one.path);
    }
    else if(seconds == 0 && minutes == 0){
      //~ default hold is in-breath 
      cubit.playExtra(GuideTrack.singleBreathOut.path);
    }

    return "$minutesStr:$secondsStr";
  }

  void navigate(PinealCubit cubit) async {
    context.goNamed(RoutesName.pinealRecoveryScreen);

    // if (cubit.currentSet == cubit.noOfSets) {
    //   if (cubit.recoveryBreath) {
    //     context.goNamed(RoutesName.pinealRecoveryScreen);
    //   } else {
    //     await context.read<PinealCubit>().audio.stopAll();
    //     context.goNamed(RoutesName.pinealSuccessScreen);
    //   }
    // } else {
    //   context.goNamed(RoutesName.pinealRecoveryScreen);
    // } 
    // else {
    //   cubit.updateRound();
    //   context.pushReplacementNamed(RoutesName.pinealScreen);
    // }
  }
}
