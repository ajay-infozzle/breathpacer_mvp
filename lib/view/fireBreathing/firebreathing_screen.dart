
// ignore_for_file: use_build_context_synchronously

import 'package:breathpacer_mvp/bloc/firebreathing/firebreathing_cubit.dart';
import 'package:breathpacer_mvp/config/router/routes_name.dart';
import 'package:breathpacer_mvp/config/theme.dart';
import 'package:breathpacer_mvp/utils/constant/interaction_breathing_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class FirebreathingScreen extends StatefulWidget {
  const FirebreathingScreen({super.key});

  @override
  State<FirebreathingScreen> createState() => _FirebreathingScreenState();
}

class _FirebreathingScreenState extends State<FirebreathingScreen> {
  late CountdownController countdownController;

  @override
  void initState() {
    super.initState();

    countdownController = CountdownController(autoStart: true);

    // inital voice
    // context.read<FirebreathingCubit>().playVoice(GuideTrack.firebreathing.path);
  }
   
  void storeScreenTime() {
    context.read<FirebreathingCubit>().breathingTimeList.add(
      context.read<FirebreathingCubit>().durationOfSets,
    );

    if (kDebugMode) {
      print("Stored breathing Screen Time: ${context.read<FirebreathingCubit>().durationOfSets}");
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

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: BlocConsumer<FirebreathingCubit, FirebreathingState>(
          listener: (context, state) {
            if (state is FirebreathingPaused) {
              countdownController.pause();
              // stopTimer();
            } else if (state is FirebreathingResumed) {
               countdownController.resume();
              // startTimer();
            } 
            // else if (state is FirebreathingHold) {
            //   stopTimer();
            //   storeScreenTime();
            //   context.read<FirebreathingCubit>().playChime();
            //   context.goNamed(RoutesName.fireBreathingHoldScreen);
            // } else if (state is FirebreathingRecovery) {
            //   stopTimer();
            //   storeScreenTime();
            //   context.read<FirebreathingCubit>().playChime();
            //   context.goNamed(RoutesName.fireBreathingRecoveryScreen);
            // }
          },
          builder: (context, state) {
            return Container(
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
                        // stopTimer();
                        context.read<FirebreathingCubit>().resetSettings();

                        context.goNamed(RoutesName.homeScreen);
                      },
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                    title: Text(
                      "Set ${context.read<FirebreathingCubit>().currentSet}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      // if(countdownController.isCompleted == false)
                      IconButton(
                        onPressed:context.read<FirebreathingCubit>().togglePause,
                        icon: Icon(
                          context.read<FirebreathingCubit>().paused
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
                    color: Colors.white.withOpacity(.3),
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
                            "Fire Breathing",
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
                          height: size - 2 * (size * 0.12),
                          alignment: Alignment.center,
                          child: ClipPath(
                            clipper: OctagonalClipper(),
                            child: Container(
                              height: size - 2 * (size * 0.12),
                              color: AppTheme.colors.blueNotChosen.withOpacity(
                                .3,
                              ),
                              child: Center(
                                child: Countdown(
                                  controller: countdownController,
                                  seconds:context.read<FirebreathingCubit>().durationOfSets,
                                  build: (BuildContext context, double time) =>
                                          Text(
                                            formatTimer(time),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: size * 0.2,
                                            ),
                                          ),
                                  interval: const Duration(seconds: 1),
                                  onFinished: () async{
                                    final cubit = context.read<FirebreathingCubit>();

                                    storeScreenTime();

                                    if(cubit.holdingPeriod == false && cubit.recoveryBreath){
                                      await cubit.playExtra(GuideTrack.nowRecover.path);
                                    }
                                    // else if(cubit.holdingPeriod == false && cubit.recoveryBreath == false && cubit.currentSet != cubit.noOfSets){
                                    //   cubit.playExtra(GuideTrack.timeToNextSet.path);
                                    // }

                                    Future.delayed(
                                      Duration(seconds: cubit.holdingPeriod ? 1 : 0),
                                      () {
                                        cubit.playChime();
                                        navigate(cubit);
                                      },
                                    );
                                    
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.04),
                        const Spacer(),

                        SizedBox(height: height * 0.08),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String formatTimer(double time) {
    int minutes = (time / 60).floor();
    int seconds = (time % 60).floor();

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    final cubit = context.read<FirebreathingCubit>();

    final midTime = (cubit.durationOfSets / 2).ceil() ;
    // if((cubit.durationOfSets - seconds) % 25 == 0 && seconds > 30 && cubit.durationOfSets > 30){
    if((cubit.durationOfSets - time.toInt()) == midTime ){
      // cubit.playMotivation();
      cubit.playExtra(GuideTrack.noRegret.path);
    }
    else if(minutes == 1 && seconds == 0 && cubit.durationOfSets > 60){
      cubit.playExtra(GuideTrack.minToGo1.path);
    }
    // else if(seconds == 120 && cubit.durationOfSets > 120){
    else if(minutes == 2 && seconds == 0 && cubit.durationOfSets > 120){
      cubit.playExtra(GuideTrack.minToGo2.path);
    }
    // else if(seconds == 180 && cubit.durationOfSets > 180){
    else if(minutes == 3 && seconds == 0 && cubit.durationOfSets > 180){
      cubit.playExtra(GuideTrack.minToGo3.path);
    }
    // else if(seconds == 240 && cubit.durationOfSets > 240){
    else if(minutes == 4 && seconds == 0 && cubit.durationOfSets > 240){
      cubit.playExtra(GuideTrack.minToGo4.path);
    }
    // else if(seconds == 300 && cubit.durationOfSets > 300){
    else if(minutes == 5 && seconds == 0 && cubit.durationOfSets > 300){
      cubit.playExtra(GuideTrack.minToGo5.path);
    }
    // else if(seconds == 360 && cubit.durationOfSets > 360){
    else if(minutes == 6 && seconds == 0 && cubit.durationOfSets > 360){
      cubit.playExtra(GuideTrack.minToGo6.path);
    }

    //~ Play motivation sound every 13 seconds if durationOfSets is greater than 
    // final midTime = (Duration(milliseconds: cubit.durationOfSets).inSeconds / 2).ceil() ;
    // if((cubit.durationOfSets - seconds) % 13 == 0 && seconds > 30 && cubit.durationOfSets > 30){
    //   // cubit.playMotivation();
    // }
    else if(seconds == 30 && minutes == 0 && cubit.durationOfSets > 30){
      cubit.playExtra(GuideTrack.secToGo30.path);
    }
    else if(seconds == 15 && minutes == 0){
      cubit.playExtra(GuideTrack.secToGo15.path);
    }
    // else if(seconds == 9 && cubit.durationOfSets <= 30){
    else if(seconds == 9 && minutes == 0){
      // cubit.playMotivation();
    }
    else if(seconds == 5 && minutes == 0){
      //~ if hold is in-breath 
      if(cubit.choiceOfBreathHold == BreathHoldChoice.breatheIn.name && cubit.holdingPeriod){
        cubit.playVoice(GuideTrack.getReadyToBreathIn.path);
      }

      //~ if hold is out-breath 
      else if(cubit.choiceOfBreathHold == BreathHoldChoice.breatheOut.name && cubit.holdingPeriod){
        cubit.playVoice(GuideTrack.getReadyToBreathOut.path);
      }

      //~ if recover & not hold
      else if(cubit.holdingPeriod == false && cubit.recoveryBreath){
        cubit.playVoice(GuideTrack.getReadyToRecover.path);
      } 

      //~ if no hold & no recover & not last set
      else if(cubit.holdingPeriod == false && cubit.recoveryBreath == false && cubit.currentSet != cubit.noOfSets){
        cubit.playVoice(GuideTrack.getReadyForNextSet.path);
      } 

      //~ if no hold & no recover & last set
      else{
        // cubit.playVoice(GuideTrack.relax.path);
        cubit.playVoice(GuideTrack.secToGo5.path);
      }
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
      //~ if hold is in-breath 
      if(cubit.choiceOfBreathHold == BreathHoldChoice.breatheIn.name && cubit.holdingPeriod){
        cubit.playExtra(GuideTrack.singleBreathIn.path);
      }

      //~ if hold is out-breath 
      else if(cubit.choiceOfBreathHold == BreathHoldChoice.breatheOut.name && cubit.holdingPeriod){
        cubit.playExtra(GuideTrack.singleBreathOut.path);
      }

      else if(cubit.holdingPeriod == false && cubit.recoveryBreath == false && cubit.currentSet != cubit.noOfSets){
        // cubit.playExtra(GuideTrack.timeToNextSet.path);
      }
    }

    return "$minutesStr:$secondsStr";
  }


  void navigate(FirebreathingCubit cubit) async {
    if (cubit.currentSet == cubit.noOfSets) {
      if (cubit.holdingPeriod) {
        context.goNamed(RoutesName.fireBreathingHoldScreen);
      } else if (cubit.recoveryBreath) {
        context.goNamed(RoutesName.fireBreathingRecoveryScreen);
      } else {
        await context.read<FirebreathingCubit>().audio.stopAll();
        context.goNamed(RoutesName.fireBreathingSuccessScreen);
      }
    } else if (cubit.holdingPeriod) {
      context.goNamed(RoutesName.fireBreathingHoldScreen);
    } else if (cubit.recoveryBreath) {
      context.goNamed(RoutesName.fireBreathingRecoveryScreen);
    } else {
      cubit.updateRound();
      context.pushReplacementNamed(RoutesName.fireBreathingScreen);
    }
  }

}
