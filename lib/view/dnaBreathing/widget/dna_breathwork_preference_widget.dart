import 'package:breathpacer_mvp/bloc/content/content_cubit.dart';
import 'package:breathpacer_mvp/bloc/dna/dna_cubit.dart';
import 'package:breathpacer_mvp/config/theme.dart';
import 'package:breathpacer_mvp/utils/constant/interaction_breathing_constant.dart';
import 'package:breathpacer_mvp/view/widget/result_container_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DnaBreathWorkPreferenceWidget extends StatelessWidget {
  const DnaBreathWorkPreferenceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final contentCubit = context.read<ContentCubit>();
    return Column(
      children: [
        ResultContainerSectionWidget(
          title: "Breathwork Preference",
          showIcon: false,
          showContent: false,
          containerColor: AppTheme.colors.newPrimaryColor,
          textColor: Colors.white,
        ),

        ResultContainerSectionWidget(
          title: 'Speed:',
          content: context.read<DnaCubit>().speed,
          iconPath: contentCubit.imagePath+contentCubit.images.timeImage!,
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        divider(),


        ResultContainerSectionWidget(
          title: 'No. of sets:',
          content: context.read<DnaCubit>().noOfSets.toString(),
          iconPath: contentCubit.imagePath+contentCubit.images.timeImage!,
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),


        divider(),
        ResultContainerSectionWidget(
          title: 'Breathing approach:',
          content: context.read<DnaCubit>().breathingApproachGroupValue,
          iconPath: contentCubit.imagePath+contentCubit.images.breathHoldIcon!,
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        divider(),

        if(context.read<DnaCubit>().isTimeBreathingApproch)
        ResultContainerSectionWidget(
          title: 'Duration of each set:',
          content: getFormattedTime(context.read<DnaCubit>().durationOfSet),
          iconPath: contentCubit.imagePath+contentCubit.images.timeImage!,
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        if(context.read<DnaCubit>().isTimeBreathingApproch)
        divider(),


        if(!context.read<DnaCubit>().isTimeBreathingApproch)
        ResultContainerSectionWidget(
          title: 'Breathe per set:',
          content: context.read<DnaCubit>().noOfBreath.toString(),
          iconPath: contentCubit.imagePath+contentCubit.images.timeImage!,
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        if(!context.read<DnaCubit>().isTimeBreathingApproch)
        divider(),

        ResultContainerSectionWidget(
          title: "Jerry's voice:",
          content: context.read<DnaCubit>().jerryVoice ?"Yes" : "No",
          iconPath: contentCubit.imagePath+contentCubit.images.voiceImage!,
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        divider(),


        ResultContainerSectionWidget(
          title: "Music:",
          content: context.read<DnaCubit>().music ?"Yes" : "No",
          iconPath: contentCubit.imagePath+contentCubit.images.musicImage!,
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        divider(),

        ResultContainerSectionWidget(
          title: 'Recovery breath duration:',
          content: getTotalTimeString(context.read<DnaCubit>().recoveryTimeList),
          iconPath: contentCubit.imagePath+contentCubit.images.recoveryIcon!,
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        divider(),

        ResultContainerSectionWidget(
          title: "Chimes at start/stop points:",
          content: context.read<DnaCubit>().chimes ?"Yes" : "No",
          iconPath: contentCubit.imagePath+contentCubit.images.chimeImage!,
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        divider(),


        // ResultContainerSectionWidget(
        //   title: "Pineal Gland:",
        //   content: context.read<DnaCubit>().pineal ?"Yes" : "No",
        //   iconPath: "assets/images/pineal_1",
        //   iconSize: 25.0,
        //   showIcon: true,
        //   showContent: true,
        //   containerColor: Colors.white,
        //   textColor: Colors.black.withOpacity(.7),
        //   iconColor: const Color(0xffFE60D4),
        // ),
        // divider(),

      ],
    );
  }
  
  divider() {
    return Container(
      height: 1,
      color: Colors.grey.withOpacity(.5),
    );
  }
}