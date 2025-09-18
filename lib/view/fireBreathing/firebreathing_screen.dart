import 'dart:async';
import 'dart:developer';

import 'package:breathpacer_mvp/bloc/firebreathing/firebreathing_cubit.dart';
import 'package:breathpacer_mvp/config/router/routes_name.dart';
import 'package:breathpacer_mvp/config/theme.dart';
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
  late Timer _timer;
  int _startTime = 0;

  @override
  void initState() {
    super.initState();

    startTimer();

    countdownController = CountdownController(autoStart: true);
  }

  // void setUpAnimation() {
  //   Duration duration = const Duration(seconds: 1);

  //   _controller = AnimationController(vsync: this, duration: duration)
  //     ..repeat(reverse: true);
  // }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _startTime++;
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

  String get getScreenTiming {
    int minutes = _startTime ~/ 60;
    int seconds = _startTime % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }
   
  void storeScreenTime() {
    context.read<FirebreathingCubit>().breathingTimeList.add(
      _startTime - 1 < 0 ? 0 : _startTime - 1,
    ); //~ -1 is added due to starttime auto increased 1 sec more

    if (kDebugMode) {
      print("Stored breathing Screen Time: $getScreenTiming");
    }
  }

  @override
  void dispose() {
    _timer.cancel();
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
              stopTimer();
            } else if (state is FirebreathingResumed) {
               countdownController.resume();
              startTimer();
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
                        stopTimer();
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
                                  build:
                                      (BuildContext context, double time) =>
                                          Text(
                                            formatTimer(time),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: size * 0.2,
                                            ),
                                          ),
                                  interval: const Duration(seconds: 1),
                                  onFinished: () {
                                    // storeScreenTime();
                                    // context
                                    //     .read<FirebreathingCubit>()
                                    //     .stopJerry();

                                    // navigate(
                                    //   context.read<FirebreathingCubit>(),
                                    // );
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

    // if (seconds == 3 && context.read<FirebreathingCubit>().holdingPeriod) {
    //   context.read<FirebreathingCubit>().playTimeToHold();
    // }

    // if (seconds == 2 &&
    //     context.read<FirebreathingCubit>().holdingPeriod == false &&
    //     context.read<FirebreathingCubit>().recoveryBreath == true) {
    //   context.read<FirebreathingCubit>().playTimeToHold();
    // }

    return "$minutesStr:$secondsStr";
  }


  // void navigate(FirebreathingCubit cubit) async {
  //   if (cubit.currentSet == cubit.noOfSets) {
  //     if (cubit.holdingPeriod) {
  //       // context.read<FirebreathingCubit>().playTimeToHold();

  //       // await Future.delayed(const Duration(seconds: 2), () {
  //       //   // context.read<FirebreathingCubit>().playHold();
  //       //   context.goNamed(RoutesName.fireBreathingCountdownScreen);
  //       // },);
  //       context.goNamed(
  //         RoutesName.fireBreathingCountdownScreen,
  //         extra: {'hold': true},
  //       );
  //     } else if (cubit.recoveryBreath) {
  //       // context.read<FirebreathingCubit>().playTimeToRecover();

  //       // await Future.delayed(const Duration(seconds: 2), () {
  //       //   context.read<FirebreathingCubit>().playRecovery();
  //       //   context.goNamed(RoutesName.fireBreathingRecoveryScreen);
  //       // },);
  //       context.goNamed(
  //         RoutesName.fireBreathingCountdownScreen,
  //         extra: {'recover': true},
  //       );
  //     } else {
  //       await Future.delayed(const Duration(seconds: 2), () {
  //         context.read<FirebreathingCubit>().playChime();
  //         context.read<FirebreathingCubit>().playRelax();
  //         cubit.stopMusic();
  //         context.goNamed(RoutesName.fireBreathingSuccessScreen);
  //       });
  //     }
  //   } else if (cubit.holdingPeriod) {
  //     // context.read<FirebreathingCubit>().playTimeToHold();

  //     // await Future.delayed(const Duration(seconds: 2), () {
  //     //   // context.read<FirebreathingCubit>().playHold();
  //     //   context.goNamed(RoutesName.fireBreathingCountdownScreen);
  //     // },);
  //     context.goNamed(
  //       RoutesName.fireBreathingCountdownScreen,
  //       extra: {'hold': true},
  //     );
  //   } else if (cubit.recoveryBreath) {
  //     // context.read<FirebreathingCubit>().playTimeToRecover();

  //     // await Future.delayed(const Duration(seconds: 2), () {
  //     //   context.read<FirebreathingCubit>().playRecovery();
  //     //   context.goNamed(RoutesName.fireBreathingRecoveryScreen);
  //     // },);
  //     context.goNamed(
  //       RoutesName.fireBreathingCountdownScreen,
  //       extra: {'recover': true},
  //     );
  //   } else {
  //     context.read<FirebreathingCubit>().playTimeToNextSet();

  //     await Future.delayed(const Duration(seconds: 2), () {
  //       context.read<FirebreathingCubit>().playJerry();
  //       cubit.currentSet = cubit.currentSet + 1;
  //       context.pushReplacementNamed(RoutesName.fireBreathingScreen);
  //     });
  //   }
  // }

}
