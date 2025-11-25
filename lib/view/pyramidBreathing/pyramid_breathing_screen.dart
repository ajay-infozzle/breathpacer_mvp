// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';

import 'package:breathpacer_mvp/bloc/pyramid/pyramid_cubit.dart';
import 'package:breathpacer_mvp/config/router/routes_name.dart';
import 'package:breathpacer_mvp/config/theme.dart';
import 'package:breathpacer_mvp/utils/constant/interaction_breathing_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:go_router/go_router.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

class PyramidBreathingScreen extends StatefulWidget {
  const PyramidBreathingScreen({super.key});

  @override
  State<PyramidBreathingScreen> createState() => _PyramidBreathingScreenState();
}

class _PyramidBreathingScreenState extends State<PyramidBreathingScreen> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;
  late Timer _timer;
  int _startTime = 0;
  int breathingRoundTime = 0;
  bool showCountdown = false;
  StreamSubscription? _cubitSubscription;

  late CountdownController countdownController;

  @override
  void initState() {
    super.initState();

    if(context.read<PyramidCubit>().choiceOfBreathHold == BreathHoldChoice.both.name && (context.read<PyramidCubit>().breathHoldIndex == 2 || context.read<PyramidCubit>().breathHoldIndex == 1) ){
      context.read<PyramidCubit>().breathHoldIndex = 0;
    }

    context.read<PyramidCubit>().breathCount = context.read<PyramidCubit>().checkBreathnumber();
    breathingRoundTime = context.read<PyramidCubit>().getEachBreathingRoundTime();
    if(context.read<PyramidCubit>().breathHoldIndex == 1){
      if(context.read<PyramidCubit>().speed == BreathSpeed.standard.name){
        breathingRoundTime -= int.parse(BreathSpeedDuration.standard.duration);
      }
      else if(context.read<PyramidCubit>().speed == BreathSpeed.fast.name){
        breathingRoundTime -= int.parse(BreathSpeedDuration.fast.duration);
      }
      else if(context.read<PyramidCubit>().speed == BreathSpeed.slow.name){
        breathingRoundTime -= int.parse(BreathSpeedDuration.slow.duration);
      }
    }

    log(">> total time: $breathingRoundTime");

    setUpAnimation();
    startTimer();
    countdownController = CountdownController(autoStart: false);
  }

  void startTimer() {
    //~ this timer will use to store pyramid breath screen time
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        _startTime++;
        log(">> $_startTime : ${Duration(milliseconds: breathingRoundTime).inSeconds - _startTime}");

        //~ ----------- play motivation -------------
        // if(Duration(milliseconds: breathingRoundTime).inSeconds > 25 && (Duration(milliseconds: breathingRoundTime).inSeconds - _startTime) > 9 ){
        //   if(_startTime % 11 == 0){
        //     context.read<PyramidCubit>().playMotivation();
        //   }
        // }

        // final midTime = (Duration(milliseconds: breathingRoundTime).inSeconds / 2).ceil() ;
        // if( _startTime == midTime && (Duration(milliseconds: breathingRoundTime).inSeconds - _startTime) > 9 ){
        //   context.read<PyramidCubit>().playMotivation();
        // }
        //~ ----------- play motivation end ----------- 


        // if( (Duration(milliseconds: breathingRoundTime).inSeconds - _startTime) == 5){
        //   context.read<PyramidCubit>().playExtra(GuideTrack.getReadyTohold.path);
        // }
        // else if( (Duration(milliseconds: breathingRoundTime).inSeconds - _startTime) == 3){
        //   context.read<PyramidCubit>().playExtra(GuideTrack.three.path);
        // }
        // else if( (Duration(milliseconds: breathingRoundTime).inSeconds - _startTime) == 2){
        //   context.read<PyramidCubit>().playExtra(GuideTrack.two.path);
        // }
        // else if( (Duration(milliseconds: breathingRoundTime).inSeconds - _startTime) == 1){
        //   context.read<PyramidCubit>().playExtra(GuideTrack.one.path);
        // }

        if( (Duration(milliseconds: breathingRoundTime).inSeconds - _startTime) == 1){
          context.read<PyramidCubit>().playExtra(GuideTrack.getReadyTohold.path);
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

  void storeScreenTime() {
    context.read<PyramidCubit>().breathingTimeList.add(_startTime-1 < 0 ? 0 : _startTime-1); //~ -1 is added due to starttime auto increased 1 sec more..this is current problem
    log(">> Stored Screen Time: $getScreenTiming");
  }

  String get getScreenTiming {
    int minutes = _startTime ~/ 60;
    int seconds = _startTime % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');
    return "$minutesStr:$secondsStr";
  }

  void setUpAnimation(){
    final cubit = context.read<PyramidCubit>();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: cubit.getBreathingCycleTime()),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.1, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addListener(() {
      cubit.breathingWork(_controller.status, _animation.value);
    });

    _cubitSubscription = cubit.stream.listen((state) async{
      try {
          if(state is PyramidBreathingPhase){
            if(state.phase == "in"){
              context.read<PyramidCubit>().playVoice(GuideTrack.singleBreathIn.path);
            }else{
              context.read<PyramidCubit>().playVoice(GuideTrack.singleBreathOut.path);
            }
          }
          else if (state is PyramidPaused) {
            _controller.stop();
            stopTimer();
          } else if (state is PyramidResumed) { 
            _controller.repeat(reverse: true);
            startTimer();
          } else if (state is PyramidHold) {
            // context.read<PyramidCubit>().playChime();
            _controller.stop();
            stopTimer();
            storeScreenTime();
        
            // await context.read<PyramidCubit>().playExtra(GuideTrack.getReadyTohold.path);
            // setState(() {
            //   showCountdown = true;
            // });
            // WidgetsBinding.instance.addPostFrameCallback((_) {
            //   countdownController.start();
            // });
            if(context.read<PyramidCubit>().breathHoldIndex == 0){
              await context.read<PyramidCubit>().playVoice( GuideTrack.singleBreathIn.path);

              _controller.reset();
              context.read<PyramidCubit>().playChime();
              context.goNamed(RoutesName.pyramidBreathHoldScreen);
            }else{
              _controller.reset();
              context.read<PyramidCubit>().playChime();
              Future.delayed(Duration(milliseconds: 700),() {
                context.goNamed(RoutesName.pyramidBreathHoldScreen);
              },);
            }

            context.read<PyramidCubit>().currentBreathing = 'Breathe in';
          }
      } on Exception catch (e) {
        log(">>breath work ${e.toString()}");
      }
    });

    // Initial call to play the first "breathe in" sound
    context.read<PyramidCubit>().playVoice(GuideTrack.singleBreathIn.path);
  }

  @override
  void dispose() {
    _cubitSubscription?.cancel();
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PyramidCubit, PyramidState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        final size = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;

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
                      onTap: (){
                        _controller.stop(); 
                        stopTimer();
                        context.read<PyramidCubit>().resetSettings(
                          context.read<PyramidCubit>().step ?? '', 
                          context.read<PyramidCubit>().speed ?? ''
                        );
                        
                        context.goNamed(RoutesName.homeScreen,);
                      },
                      child: const Icon(Icons.close,color: Colors.white,),
                    ),
                    title: Text(
                      "Round ${context.read<PyramidCubit>().currentRound}",
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    actions: [
                      if(context.read<PyramidCubit>().breathCount > 0)
                      IconButton(
                        onPressed: context.read<PyramidCubit>().togglePause, 
                        icon: Icon(
                          context.read<PyramidCubit>().paused ? Icons.play_arrow : Icons.pause, 
                          color: Colors.white,
                          size: 30,
                        ),
                      ),

                      SizedBox(width: size*0.03,)
                    ],
                  ),

                  SizedBox(height: size*0.02,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: size*0.05),
                    color: Colors.white.withValues(alpha:.3),
                    height: 1,
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: height*0.1,),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: size*0.05),
                          alignment: Alignment.center,
                          child: Text(
                            "Take ${context.read<PyramidCubit>().checkBreathnumber()} deep breaths",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: size*0.05,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),

                        Container(
                          width: size*0.4,
                          margin: EdgeInsets.symmetric(horizontal: size*0.05, vertical: size*0.05),
                          padding: EdgeInsets.symmetric(vertical: size*0.03,horizontal: size*0.03),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            context.read<PyramidCubit>().currentBreathing,
                            style: TextStyle(
                              color: AppTheme.colors.primaryColor,
                              fontSize: size*0.05,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),

                        SizedBox(height: height*0.05,),

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
                                        context.read<PyramidCubit>().breathCount.toString(),
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
                                    context.read<PyramidCubit>().playCount(time.toString().split(".").first);
                                    if(time.toString().split(".").first == '0'){
                                      context.read<PyramidCubit>().playExtra(
                                        context.read<PyramidCubit>().breathHoldIndex == 0
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
                                    if(context.read<PyramidCubit>().breathHoldIndex == 0){
                                      await context.read<PyramidCubit>().playVoice( GuideTrack.singleBreathIn.path);

                                      _controller.reset();
                                      context.read<PyramidCubit>().playChime();
                                      context.goNamed(RoutesName.pyramidBreathHoldScreen);
                                    }else{
                                      _controller.reset();
                                      context.read<PyramidCubit>().playChime();
                                      Future.delayed(Duration(milliseconds: 700),() {
                                        context.goNamed(RoutesName.pyramidBreathHoldScreen);
                                      },);
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: height*0.04,),
                        const Spacer(),
                      ],
                    ) 
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
