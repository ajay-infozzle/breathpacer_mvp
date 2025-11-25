// ignore_for_file: use_build_context_synchronously

import 'package:breathpacer_mvp/bloc/dna/dna_cubit.dart';
import 'package:breathpacer_mvp/config/router/routes_name.dart';
import 'package:breathpacer_mvp/config/services/audio_services.dart';
import 'package:breathpacer_mvp/view/widget/waiting_screen_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DnaWaitingScreen extends StatelessWidget {
  const DnaWaitingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WaitingScreenWidget(
      title: "DNA Breathing",
      countdownTime: context.read<DnaCubit>().waitingTime,
      onTimerFinished: () async{
        context.read<DnaCubit>().currentSet = 1 ;
        context.read<DnaCubit>().audio.stop(AudioChannel.voice);
        
        Future.delayed(
          Duration(milliseconds: 400), 
          (){
            context.read<DnaCubit>().playChime();
            context.pushReplacementNamed(RoutesName.dnaBreathingScreen);
          }
        );
      },
      onSkip: (){      },
    );
  }
}