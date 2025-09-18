import 'package:breathpacer_mvp/bloc/firebreathing/firebreathing_cubit.dart';
import 'package:breathpacer_mvp/config/router/routes_name.dart';
import 'package:breathpacer_mvp/config/services/audio_services.dart';
import 'package:breathpacer_mvp/view/widget/waiting_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FirebreathingWaitingScreen extends StatelessWidget {
  const FirebreathingWaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WaitingScreenWidget(
      title: "Fire Breathing",
      countdownTime: context.read<FirebreathingCubit>().waitingTime,
      onTimerFinished: (){
        context.read<FirebreathingCubit>().currentSet = 1 ;
        context.read<FirebreathingCubit>().audio.stop(AudioChannel.voice);
        context.read<FirebreathingCubit>().playChime();

        context.pushReplacementNamed(RoutesName.fireBreathingScreen);
      },
      onSkip: (){},
    );
  }
}