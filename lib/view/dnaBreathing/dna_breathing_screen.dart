// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:breathpacer_mvp/bloc/dna/dna_cubit.dart';
import 'package:breathpacer_mvp/config/router/routes_name.dart';
import 'package:breathpacer_mvp/config/theme.dart';
import 'package:breathpacer_mvp/utils/constant/interaction_breathing_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class DnaBreathingScreen extends StatefulWidget {
  const DnaBreathingScreen({super.key});

  @override
  State<DnaBreathingScreen> createState() => _DnaBreathingScreenState();
}

class _DnaBreathingScreenState extends State<DnaBreathingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  late double size, height;
  // int breathCount = 0;
  int breathingRoundTime = 0;
  bool isTimeBreathingApproch = false;
  bool showCountdown = false;
  late CountdownController countdownController;
  StreamSubscription? _cubitSubscription;

  late Timer _timer;
  final ValueNotifier<int> _startTime = ValueNotifier(0);


  @override
  void initState() {
    super.initState();

    if (context.read<DnaCubit>().choiceOfBreathHold ==
            BreathHoldChoice.both.name &&
        (context.read<DnaCubit>().breathHoldIndex == 2 ||
            context.read<DnaCubit>().breathHoldIndex == 1)) {
      context.read<DnaCubit>().breathHoldIndex = 0;
    }

    isTimeBreathingApproch = context.read<DnaCubit>().isTimeBreathingApproch;
    if (!isTimeBreathingApproch) {
      context.read<DnaCubit>().breathCount = context.read<DnaCubit>().noOfBreath;

      breathingRoundTime = context.read<DnaCubit>().getEachBreathingRoundTime();
      if (context.read<DnaCubit>().breathHoldIndex == 1) {
        if (context.read<DnaCubit>().speed == BreathSpeed.standard.name) {
          breathingRoundTime -= int.parse(
            BreathSpeedDuration.standard.duration,
          );
        } else if (context.read<DnaCubit>().speed == BreathSpeed.fast.name) {
          breathingRoundTime -= int.parse(BreathSpeedDuration.fast.duration);
        } else if (context.read<DnaCubit>().speed == BreathSpeed.slow.name) {
          breathingRoundTime -= int.parse(BreathSpeedDuration.slow.duration);
        }
      }

      log(">> total time: $breathingRoundTime");
      setUpAnimation();
    } else {
      countdownController = CountdownController(autoStart: true);
      setUpAnimation();
    }
    startTimer();
  }

  void setUpAnimation() {
    final cubit = context.read<DnaCubit>();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: cubit.getBreathingCycleTime()),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.1,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.addListener(() {
      cubit.breathingWork(_controller.status, _animation.value);
    });

    _cubitSubscription = cubit.stream.listen((state) async {
      try {
        if (state is DnaBreathingPhase) {
          if (state.phase == "in") {
            context.read<DnaCubit>().playVoice(GuideTrack.singleBreathIn.path);
          } else {
            context.read<DnaCubit>().playVoice(GuideTrack.singleBreathOut.path);
          }
        } else if (state is DnaPaused) {
          _controller.stop();
          stopTimer();
        } else if (state is DnaResumed) {
          _controller.repeat(reverse: true);
          startTimer();
        } else if (state is DnaHold) {
          // context.read<DnaCubit>().playChime();
          _controller.stop();
          stopTimer();
          storeScreenTime();

          if (context.read<DnaCubit>().breathHoldIndex == 0) {
            await context.read<DnaCubit>().playVoice(
              GuideTrack.singleBreathIn.path,
            );

            _controller.reset();
            context.read<DnaCubit>().playChime();
            context.goNamed(RoutesName.dnaHoldScreen);
          } else {
            _controller.reset();
            context.read<DnaCubit>().playChime();
            Future.delayed(Duration(milliseconds: 700), () {
              context.goNamed(RoutesName.dnaHoldScreen);
            });
          }

          context.read<DnaCubit>().currentBreathing = 'Breathe in';
        }
        else if (state is DnaRecover) {
          _controller.stop();
          stopTimer();
          storeScreenTime();

          // await context.read<DnaCubit>().playVoice(
          //   GuideTrack.getReadyToRecover.path,
          // );

          _controller.reset();
          context.read<DnaCubit>().playChime();
          navigate(cubit);

          context.read<DnaCubit>().currentBreathing = 'Breathe in';
        }
        else if (state is DnaNext) {
          _controller.stop();
          stopTimer();
          storeScreenTime();

          await context.read<DnaCubit>().playVoice(
            GuideTrack.getReadyForNextSet.path,
          );

          _controller.reset();
          context.read<DnaCubit>().playChime();
          navigate(cubit);

          context.read<DnaCubit>().currentBreathing = 'Breathe in';
        }
        else if (state is DnaEnd) {
          _controller.stop();
          stopTimer();
          storeScreenTime();

          _controller.reset();
          context.read<DnaCubit>().playChime();
          navigate(cubit);

          context.read<DnaCubit>().currentBreathing = 'Breathe in';
        }
      } on Exception catch (e) {
        log(">>breath work ${e.toString()}");
      }
    });

    // Initial call to play the first "breathe in" sound
    if(!isTimeBreathingApproch){
      context.read<DnaCubit>().playVoice(GuideTrack.singleBreathIn.path);
    }
  }

  @override
  void dispose() {
    _cubitSubscription?.cancel();
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    size = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _startTime.value++;
      log(
        ">> ${_startTime.value} : ${Duration(milliseconds: breathingRoundTime).inSeconds - _startTime.value}",
      );

      if ((Duration(milliseconds: breathingRoundTime).inSeconds - _startTime.value) == 1) {
        if(context.read<DnaCubit>().holdingPeriod){
          context.read<DnaCubit>().playExtra(GuideTrack.getReadyTohold.path);
        }
        else if(context.read<DnaCubit>().recoveryBreath){
          context.read<DnaCubit>().playExtra(GuideTrack.nowRecover.path);
        }
      }
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

  // String get getScreenTiming {
  //   int minutes = _startTime ~/ 60;
  //   int seconds = _startTime % 60;
  //   String minutesStr = minutes.toString().padLeft(2, '0');
  //   String secondsStr = seconds.toString().padLeft(2, '0');
  //   return "$minutesStr:$secondsStr";
  // }

  void storeScreenTime() {
    if(isTimeBreathingApproch){
      context.read<DnaCubit>().breathingTimeList.add(
        context.read<DnaCubit>().durationOfSet,
      );
    }else{
      context.read<DnaCubit>().breathingTimeList.add(
        Duration(milliseconds: breathingRoundTime).inSeconds,
        // _startTime - 1 < 0 ? 0 : _startTime - 1,
      ); //~ -1 is added due to starttime auto increased 1 sec more
    }

    // log(">> Stored Screen Time: $getScreenTiming");
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DnaCubit, DnaState>(
      listener: (context, state) {
        
      },
      builder: (context, state) {
        size = MediaQuery.of(context).size.width;
        height = MediaQuery.of(context).size.height;
        
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
                        _controller.stop(); 
                        stopTimer();
                        if (context.read<DnaCubit>().isTimeBreathingApproch) {
                          countdownController.pause();
                        } 
              
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
                      if(context.read<DnaCubit>().breathCount > 0)
                      IconButton(
                        onPressed: context.read<DnaCubit>().togglePause,
                        icon: Icon(
                          context.read<DnaCubit>().paused ? Icons.play_arrow : Icons.pause,
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
                          margin: EdgeInsets.symmetric(
                            horizontal: size * 0.05,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            context.read<DnaCubit>().isTimeBreathingApproch
                                ? "Breathe for ${getFormattedTime(context.read<DnaCubit>().durationOfSet)}"
                                : "Take ${context.read<DnaCubit>().noOfBreath} deep breaths",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
              
                        // if(!context.read<DnaCubit>().isTimeBreathingApproch)
                        Container(
                          width: size * 0.4,
                          margin: EdgeInsets.symmetric(
                            horizontal: size * 0.05,
                            vertical: size * 0.05,
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: size * 0.03,
                            horizontal: size * 0.03,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            context.read<DnaCubit>().currentBreathing,
                            style: TextStyle(
                              color: AppTheme.colors.primaryColor,
                              fontSize: size * 0.05,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
              
                        SizedBox(height: height * 0.05),
              
                        if (!context.read<DnaCubit>().isTimeBreathingApproch)
                        !showCountdown ?
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: _animation.value,
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: size * 0.12),
                                height: size - 2 * (size * 0.12),
                                alignment: Alignment.center,
                                child: ClipPath(
                                  clipper: OctagonalClipper(),
                                  child: Container(
                                    height: size - 2 * (size * 0.12),
                                    color: AppTheme.colors.blueNotChosen.withValues(alpha:.3),
                                    child: Center(
                                      child: Text(
                                        context.read<DnaCubit>().breathCount.toString(),
                                        style: TextStyle(color: Colors.white, fontSize: size * 0.2),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            );
                          }
                        )
                        :
                        Container(
                          width: size,
                          margin: EdgeInsets.symmetric(horizontal: size*0.12),
                          height: size-2*(size*0.12),
                          alignment: Alignment.center,
                          child: ClipPath(
                            clipper: OctagonalClipper(),
                            child: Container(
                              height: size-2*(size*0.12),
                              color: AppTheme.colors.blueNotChosen.withOpacity(.3),
                              child: Center(
                                child: Countdown(
                                  controller: countdownController,
                                  seconds: 3,
                                  build: (BuildContext context, double time) {
                                    context.read<DnaCubit>().playCount(time.toString().split(".").first);
                                    if(time.toString().split(".").first == '0'){
                                      context.read<DnaCubit>().playExtra(
                                        context.read<DnaCubit>().breathHoldIndex == 0
                                        ? GuideTrack.singleBreathIn.path
                                        : GuideTrack.singleBreathOut.path
                                      );
                                    }

                                    return Text(
                                      time.toString().split(".").first,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size*0.2
                                      ),
                                    );
                                  },
                                  interval: const Duration(seconds: 1),
                                  onFinished: () async{
                                    final cubit = context.read<DnaCubit>();

                                    if(cubit.holdingPeriod == true && cubit.breathHoldIndex == 0){
                                      await cubit.playVoice( GuideTrack.singleBreathIn.path);

                                      _controller.reset();
                                      cubit.playChime();
                                      context.goNamed(RoutesName.dnaHoldScreen);
                                    }
                                    else if(cubit.holdingPeriod == true && cubit.breathHoldIndex == 1){
                                      _controller.reset();
                                      cubit.playChime();
                                      Future.delayed(Duration(milliseconds: 700),() {
                                        context.goNamed(RoutesName.dnaHoldScreen);
                                      },);
                                    }
                                    else if(cubit.holdingPeriod == false && cubit.recoveryBreath){
                                      await cubit.playExtra(GuideTrack.nowRecover.path);
                                      cubit.playChime();
                                      navigate(cubit);
                                    }

                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
              
                        if (context.read<DnaCubit>().isTimeBreathingApproch)
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: size * 0.12,
                            ),
                            height: size - 2 * (size * 0.12),
                            alignment: Alignment.center,
                            child: ClipPath(
                              clipper: OctagonalClipper(),
                              child: Container(
                                height: size - 2 * (size * 0.12),
                                color: AppTheme.colors.blueNotChosen
                                    .withOpacity(.3),
                                child: Center(
                                  child: Countdown(
                                    controller: countdownController,
                                    seconds: context.read<DnaCubit>().durationOfSet,
                                    build: (BuildContext context, double time) =>
                                      Text(
                                        formatTimer(time),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size * 0.2,
                                        ),
                                      ),
                                    interval: const Duration(seconds: 1),
                                    onFinished: () async {
                                      final cubit = context.read<DnaCubit>();

                                      storeScreenTime();
                                      if(cubit.holdingPeriod == false && cubit.recoveryBreath){
                                        await cubit.playExtra(GuideTrack.nowRecover.path);
                                      }

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

    final cubit = context.read<DnaCubit>();

    final midTime = (cubit.durationOfSet / 2).ceil() ;
    // if((cubit.durationOfSets - seconds) % 25 == 0 && seconds > 30 && cubit.durationOfSets > 30){
    if((cubit.durationOfSet - time.toInt()) == midTime ){
      cubit.playMotivation();
    }
    else if(minutes == 1 && seconds == 0 && cubit.durationOfSet > 60){
      cubit.playExtra(GuideTrack.minToGo1.path);
    }
    // else if(seconds == 120 && cubit.durationOfSets > 120){
    else if(minutes == 2 && seconds == 0 && cubit.durationOfSet > 120){
      cubit.playExtra(GuideTrack.minToGo2.path);
    }
    // else if(seconds == 180 && cubit.durationOfSets > 180){
    else if(minutes == 3 && seconds == 0 && cubit.durationOfSet > 180){
      cubit.playExtra(GuideTrack.minToGo3.path);
    }
    // else if(seconds == 240 && cubit.durationOfSets > 240){
    else if(minutes == 4 && seconds == 0 && cubit.durationOfSet > 240){
      cubit.playExtra(GuideTrack.minToGo4.path);
    }
    // else if(seconds == 300 && cubit.durationOfSets > 300){
    else if(minutes == 5 && seconds == 0 && cubit.durationOfSet > 300){
      cubit.playExtra(GuideTrack.minToGo5.path);
    }
    // else if(seconds == 360 && cubit.durationOfSets > 360){
    else if(minutes == 6 && seconds == 0 && cubit.durationOfSet > 360){
      cubit.playExtra(GuideTrack.minToGo6.path);
    }

    //~ Play motivation sound every 13 seconds if durationOfSets is greater than 
    // final midTime = (Duration(milliseconds: cubit.durationOfSets).inSeconds / 2).ceil() ;
    // if((cubit.durationOfSets - seconds) % 13 == 0 && seconds > 30 && cubit.durationOfSets > 30){
    //   // cubit.playMotivation();
    // }
    else if(seconds == 30 && minutes == 0 && cubit.durationOfSet > 30){
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

  void navigate(DnaCubit cubit) async {
    if (cubit.currentSet == cubit.noOfSets) {
      if (cubit.holdingPeriod) {
        context.goNamed(RoutesName.dnaHoldScreen);
      } else if (cubit.recoveryBreath) {
        context.goNamed(RoutesName.dnaRecoveryScreen);
      } else {
        await context.read<DnaCubit>().audio.stopAll();
        context.goNamed(RoutesName.dnaSuccessScreen);
      }
    } else if (cubit.holdingPeriod) {
      context.goNamed(RoutesName.dnaHoldScreen);
    } else if (cubit.recoveryBreath) {
      context.goNamed(RoutesName.dnaRecoveryScreen);
    } else {
      cubit.updateRound();
      context.pushReplacementNamed(RoutesName.dnaBreathingScreen);
    }
  }

}
