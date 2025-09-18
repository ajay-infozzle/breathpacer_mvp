
import 'package:breathpacer_mvp/bloc/pyramid/pyramid_cubit.dart';
import 'package:breathpacer_mvp/config/router/routes_name.dart';
import 'package:breathpacer_mvp/config/services/audio_services.dart';
import 'package:breathpacer_mvp/view/widget/waiting_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PyramidWaitingScreen extends StatefulWidget {
  const PyramidWaitingScreen({super.key});

  @override
  State<PyramidWaitingScreen> createState() => _PyramidWaitingScreenState();
}

class _PyramidWaitingScreenState extends State<PyramidWaitingScreen> {
  @override
  Widget build(BuildContext context) {
    return WaitingScreenWidget(
      title: "Pyramid Breathing",
      countdownTime: context.read<PyramidCubit>().waitingTime,
      onTimerFinished: (){
        context.read<PyramidCubit>().currentRound = 1 ;
        context.read<PyramidCubit>().audio.stop(AudioChannel.voice);
        context.read<PyramidCubit>().playChime();

        context.pushReplacementNamed(RoutesName.pyramidBreathingScreen);
      },
      onSkip: (){},
    );
  }
}