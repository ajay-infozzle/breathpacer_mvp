// ignore_for_file: use_build_context_synchronously

import 'package:breathpacer_mvp/bloc/pineal/pineal_cubit.dart';
import 'package:breathpacer_mvp/config/router/routes_name.dart';
import 'package:breathpacer_mvp/config/services/audio_services.dart';
import 'package:breathpacer_mvp/view/widget/waiting_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PinealWaitingScreen extends StatelessWidget {
  const PinealWaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WaitingScreenWidget(
      title: "Pineal Gland Activation",
      countdownTime: context.read<PinealCubit>().waitingTime,
      onTimerFinished: (){
        context.read<PinealCubit>().currentSet = 1 ;
        context.read<PinealCubit>().audio.stop(AudioChannel.voice);

        Future.delayed(
          Duration(milliseconds: 700), 
          (){
            context.read<PinealCubit>().playChime();
            context.pushReplacementNamed(RoutesName.pinealScreen);
          }
        );
      },
      onSkip: (){},
    );
  }
}