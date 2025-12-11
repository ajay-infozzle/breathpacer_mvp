// ignore_for_file: use_build_context_synchronously

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

class PinealRecoveryScreen extends StatefulWidget {
  const PinealRecoveryScreen({super.key});

  @override
  State<PinealRecoveryScreen> createState() => _PinealRecoveryScreenState();
}

class _PinealRecoveryScreenState extends State<PinealRecoveryScreen> {
  late CountdownController recoverCountdownController;

  @override
  void initState() {
    super.initState();

    recoverCountdownController = CountdownController(autoStart: true);
  }

  void storeScreenTime() {
    context.read<PinealCubit>().recoveryTimeList.add(
      context.read<PinealCubit>().recoveryBreathDuration,
    );

    if (kDebugMode) {
      print(
        "breath recovery Time: ${context.read<PinealCubit>().recoveryBreathDuration}",
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

    return BlocConsumer<PinealCubit, PinealState>(
      listener: (context, state) {
        if (state is PinealPaused) {
          recoverCountdownController.pause();
        } else if (state is PinealResumed) {
          recoverCountdownController.resume();
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
                        recoverCountdownController.pause();
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
                      if ( !(recoverCountdownController.isCompleted??false) )
                      IconButton(
                        onPressed: context.read<PinealCubit>().togglePause,
                        icon: Icon(
                          context.read<PinealCubit>().paused
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
                    child: ListView(
                      padding: const EdgeInsets.all(0),
                      children: [
                        SizedBox(height: height * 0.03),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: size * 0.05,
                          ),
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
              
                        SizedBox(height: height * 0.03),
                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: size * 0.12,
                          ),
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: size * 0.25,
                            child: Image.asset(
                              ImagePath.recoveryBreathIcon.path,
                            ),
                          ),
                        ),
              
                        // Container(
                        //   margin: EdgeInsets.only(top: height * 0.04),
                        //   width: size,
                        //   alignment: Alignment.center,
                        //   child: Center(
                        //     child: Text(
                        //       "Recover for:",
                        //       style: TextStyle(
                        //         color: Colors.white,
                        //         fontSize: size * 0.045,
                        //       ),
                        //     ),
                        //   ),
                        // ),
              
                        Container(
                          margin: EdgeInsets.only(top: height * 0.001),
                          width: size,
                          alignment: Alignment.center,
                          child: Center(
                            child: Countdown(
                              controller: recoverCountdownController,
                              seconds:
                                  context
                                      .read<PinealCubit>()
                                      .recoveryBreathDuration,
                              build: (BuildContext context, double time) {
                                // if(formatTimer(time) == "00:00"){
                                //   storeScreenTime();
                                //   context.read<PinealCubit>().stopRecovery();
                                // }
              
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
                                storeScreenTime();
                                navigate(context.read<PinealCubit>());
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

  String formatTimer(double time, {bool isForRecover = false}) {
    int minutes = (time / 60).floor();
    int seconds = (time % 60).floor();

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    final cubit = context.read<PinealCubit>();

    if(seconds == 5 && minutes == 0){

      //~ if not last set
      if(cubit.currentSet != cubit.noOfSets){
        cubit.playVoice(GuideTrack.getReadyForNextSet.path);
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

    return "$minutesStr:$secondsStr" ;
  }

  void navigate(PinealCubit cubit) async {
    if (cubit.currentSet == cubit.noOfSets) {
      await context.read<PinealCubit>().audio.stopAll();
      context.read<PinealCubit>().playChime();
      context.goNamed(RoutesName.pinealSuccessScreen);
    } else {
      cubit.updateRound();
      context.read<PinealCubit>().playChime();
      context.goNamed(RoutesName.pinealScreen);
    }
  }
}
