
// ignore_for_file: use_build_context_synchronously

import 'package:breathpacer_mvp/bloc/dna/dna_cubit.dart';
import 'package:breathpacer_mvp/config/router/routes_name.dart';
import 'package:breathpacer_mvp/config/theme.dart';
import 'package:breathpacer_mvp/utils/constant/interaction_breathing_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class DnaRecoveryScreen extends StatefulWidget {
  const DnaRecoveryScreen({super.key});

  @override
  State<DnaRecoveryScreen> createState() => _DnaRecoveryScreenState();
}

class _DnaRecoveryScreenState extends State<DnaRecoveryScreen> {
  late CountdownController countdownController;

  @override
  void initState() {
    super.initState();

    countdownController = CountdownController(autoStart: true);
    context.read<DnaCubit>().playVoice(GuideTrack.nowRecover.path);
  }

  void storeScreenTime() {
    context.read<DnaCubit>().recoveryTimeList.add(
      context.read<DnaCubit>().recoveryBreathDuration,
    );

    if (kDebugMode) {
      print(
        "breath recovery Time: ${context.read<DnaCubit>().recoveryBreathDuration}",
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

    return BlocConsumer<DnaCubit, DnaState>(
      listener: (context, state) {
       if (state is DnaPaused) {
          countdownController.pause();
        } else if (state is DnaResumed) {
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
                        context.read<DnaCubit>().resetSettings(BreathSpeed.standard.name);

                        context.goNamed(RoutesName.homeScreen);
                      },
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                    title: Text(
                      "Set ${context.read<DnaCubit>().currentSet}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    actions: [
                      // if (countdownController.isCompleted == false)
                        IconButton(
                          onPressed:
                              context.read<DnaCubit>().togglePause,
                          icon: Icon(
                            context.read<DnaCubit>().paused
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
                                      .read<DnaCubit>()
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
                                navigate(context.read<DnaCubit>());
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


  void navigate(DnaCubit cubit) async {
    if (cubit.currentSet == cubit.noOfSets) {
      await context.read<DnaCubit>().audio.stopAll();
      context.read<DnaCubit>().playChime();
      context.goNamed(RoutesName.dnaSuccessScreen);
    } else {
      cubit.updateRound();
      context.read<DnaCubit>().playChime();
      context.goNamed(RoutesName.dnaBreathingScreen);
    }
  }

  String formatTimer(double time) {
    int minutes = (time / 60).floor();
    int seconds = (time % 60).floor();

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    final cubit = context.read<DnaCubit>();

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
        // cubit.playExtra(GuideTrack.timeToNextSet.path);
      }
    }

    return "$minutesStr:$secondsStr";
  }
}
