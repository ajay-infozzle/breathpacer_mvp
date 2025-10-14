
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

class FirebreathingRecoveryScreen extends StatefulWidget {
  const FirebreathingRecoveryScreen({super.key});

  @override
  State<FirebreathingRecoveryScreen> createState() =>
      _FirebreathingRecoveryScreenState();
}

class _FirebreathingRecoveryScreenState
    extends State<FirebreathingRecoveryScreen> {
  late CountdownController countdownController;

  @override
  void initState() {
    super.initState();

    countdownController = CountdownController(autoStart: true);
    // context.read<FirebreathingCubit>().playVoice(GuideTrack.nowRecover.path);
  }

  void storeScreenTime() {
    context.read<FirebreathingCubit>().recoveryTimeList.add(
      context.read<FirebreathingCubit>().recoveryBreathDuration,
    );

    if (kDebugMode) {
      print(
        "breath recovery Time: ${context.read<FirebreathingCubit>().recoveryBreathDuration}",
      );
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
                      // if (countdownController.isCompleted == false)
                        IconButton(
                          onPressed:
                              context.read<FirebreathingCubit>().togglePause,
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
                            "Recovery breath",
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
                            child: Image.asset(
                              ImagePath.recoveryBreathIcon.path
                            ),
                          ),
                        ),

                        SizedBox(height: height * 0.04),
                        Container(
                          width: size,
                          alignment: Alignment.center,
                          child: Center(
                            child: Countdown(
                              controller: countdownController,
                              seconds:
                                  context
                                      .read<FirebreathingCubit>()
                                      .recoveryBreathDuration,
                              build:
                                  (BuildContext context, double time) => Text(
                                    formatTimer(time),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size * 0.2,
                                    ),
                                  ),
                              interval: const Duration(seconds: 1),
                              onFinished: () {
                                storeScreenTime();
                                navigate(context.read<FirebreathingCubit>());
                              },
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
            ),
          ),
        );
      },
    );
  }


  void navigate(FirebreathingCubit cubit) async {
    if (cubit.currentSet == cubit.noOfSets) {
      await context.read<FirebreathingCubit>().audio.stopAll();
      context.goNamed(RoutesName.fireBreathingSuccessScreen);
    } else {
      cubit.updateRound();
      context.goNamed(RoutesName.fireBreathingScreen);
    }
  }

  String formatTimer(double time) {
    int minutes = (time / 60).floor();
    int seconds = (time % 60).floor();

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    final cubit = context.read<FirebreathingCubit>();

    if(seconds == 5 && minutes == 0){

      //~ if not last set
      if(cubit.currentSet != cubit.noOfSets){
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
      if(cubit.currentSet != cubit.noOfSets){
        cubit.playExtra(GuideTrack.timeToNextSet.path);
      }
    }

    return "$minutesStr:$secondsStr";
  }
}
