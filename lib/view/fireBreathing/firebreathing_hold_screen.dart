
// ignore_for_file: use_build_context_synchronously

import 'package:breathpacer_mvp/bloc/firebreathing/firebreathing_cubit.dart';
import 'package:breathpacer_mvp/config/router/routes_name.dart';
import 'package:breathpacer_mvp/config/theme.dart';
import 'package:breathpacer_mvp/utils/constant/interaction_breathing_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class FirebreathingHoldScreen extends StatefulWidget {
  const FirebreathingHoldScreen({super.key});

  @override
  State<FirebreathingHoldScreen> createState() =>
      _FirebreathingHoldScreenState();
}

class _FirebreathingHoldScreenState extends State<FirebreathingHoldScreen> {
  late CountdownController countdownController;
 

  @override
  void initState() {
    super.initState();

    context.read<FirebreathingCubit>().playVoice(GuideTrack.nowHold.path);
    countdownController = CountdownController(autoStart: true);
  }


  void storeScreenTime() {
    context.read<FirebreathingCubit>().holdTimeList.add(
      context.read<FirebreathingCubit>().holdDuration
    ); 

    if (kDebugMode) {
      print("breath hold Time: ${context.read<FirebreathingCubit>().holdDuration}");
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

    return BlocConsumer<FirebreathingCubit, FirebreathingState>(
      listener: (context, state) {
        if (state is FirebreathingPaused) {
          countdownController.pause();
        } else if (state is FirebreathingResumed) {
          countdownController.resume();
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
                        onPressed: context.read<FirebreathingCubit>().togglePause,
                        icon: Icon(
                          context.read<FirebreathingCubit>().paused ? Icons.play_arrow : Icons.pause,
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

                        // if (context.read<FirebreathingCubit>().holdDuration != -1)
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
                                seconds:context.read<FirebreathingCubit>().holdDuration,
                                build:
                                    (BuildContext context, double time) => Text(
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

                                  Future.delayed(
                                    const Duration(seconds: 1),
                                    () async{
                                      if(cubit.recoveryBreath){
                                        await cubit.playExtra(GuideTrack.nowRecover.path);
                                      }
                                      // else if(cubit.currentSet != cubit.noOfSets){
                                      //   await cubit.playExtra(GuideTrack.timeToNextSet.path);
                                      // }
                                      if(cubit.currentSet != cubit.noOfSets && cubit.recoveryBreath == false){
                                        await cubit.playExtra(GuideTrack.timeToNextSet.path);
                                      }

                                      cubit.playChime();
                                      navigate(cubit);
                                    },
                                  );

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
    if (context.read<FirebreathingCubit>().breathHoldIndex == 0) {
      return 'in-breath';
    } else {
      return 'out-breath';
    }
  }

  void navigate(FirebreathingCubit cubit) async {
    if (cubit.currentSet == cubit.noOfSets) {
      if (cubit.recoveryBreath) {
        context.goNamed(RoutesName.fireBreathingRecoveryScreen);
      } else {
        await context.read<FirebreathingCubit>().audio.stopAll();
        context.goNamed(RoutesName.fireBreathingSuccessScreen);
      }
    } else if (cubit.recoveryBreath) {
      context.goNamed(RoutesName.fireBreathingRecoveryScreen);
    } else {
      cubit.updateRound();
      context.pushReplacementNamed(RoutesName.fireBreathingScreen);
    }
  }

  String formatTimer(double time) {
    int minutes = (time / 60).floor();
    int seconds = (time % 60).floor();

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');


    final cubit = context.read<FirebreathingCubit>();

    final midTime = (cubit.holdDuration / 2).ceil() ;
    if((cubit.holdDuration - time.toInt()) == midTime ){
      // cubit.playMotivation();
      cubit.playExtra(GuideTrack.noRegret.path);
    }
    if(minutes == 1 && seconds == 0 && cubit.durationOfSets > 60){
      cubit.playExtra(GuideTrack.minToGo1.path);
    }
    else if(minutes == 2 && seconds == 0 && cubit.durationOfSets > 120){
      cubit.playExtra(GuideTrack.minToGo2.path);
    }
    else if(minutes == 3 && seconds == 0 && cubit.durationOfSets > 180){
      cubit.playExtra(GuideTrack.minToGo3.path);
    }
    else if(minutes == 4 && seconds == 0 && cubit.durationOfSets > 240){
      cubit.playExtra(GuideTrack.minToGo4.path);
    }
    else if(minutes == 5 && seconds == 0 && cubit.durationOfSets > 300){
      cubit.playExtra(GuideTrack.minToGo5.path);
    }

    //~ Play motivation sound every 9 seconds if holdDuration is greater than 30
    // if((cubit.holdDuration - seconds) % 9 == 0 && seconds > 20){
    //   cubit.playMotivation();
    // }
    else if(seconds == 30 && minutes == 0 && cubit.holdDuration > 30){
      cubit.playExtra(GuideTrack.secToGo30.path);
    }
    // else if((cubit.holdDuration - seconds) % 9 == 0 && seconds > 20){
    //   // cubit.playMotivation();
    //   cubit.playExtra(GuideTrack.noRegret.path);
    // }
    else if(seconds == 5 && minutes == 0){
      cubit.playExtra(GuideTrack.secToGo15.path);
    }
    else if(seconds == 9 && minutes == 0 && cubit.holdDuration > 10){
      // cubit.playMotivation();
    }
    else if(seconds == 5 && minutes == 0){
      //~ if hold is in-breath 
      if(cubit.choiceOfBreathHold == BreathHoldChoice.breatheIn.name){
        cubit.playVoice(GuideTrack.getReadyToBreathOut.path);
      }

      //~ if hold is out-breath 
      else if(cubit.choiceOfBreathHold == BreathHoldChoice.breatheOut.name){
        cubit.playVoice(GuideTrack.getReadyToBreathIn.path);
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
      if(cubit.choiceOfBreathHold == BreathHoldChoice.breatheIn.name){
        cubit.playExtra(GuideTrack.singleBreathOut.path);
      }

      //~ if hold is out-breath 
      else if(cubit.choiceOfBreathHold == BreathHoldChoice.breatheOut.name){
        cubit.playExtra(GuideTrack.singleBreathIn.path);
      }
    }

    return "$minutesStr:$secondsStr";
  }

}
