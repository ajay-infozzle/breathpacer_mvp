import 'package:breathpacer_mvp/bloc/pineal/pineal_cubit.dart';
import 'package:breathpacer_mvp/config/theme.dart';
import 'package:breathpacer_mvp/utils/constant/interaction_breathing_constant.dart';
import 'package:breathpacer_mvp/view/widget/result_container_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PinealWorkPreferenceWidget extends StatelessWidget {
  const PinealWorkPreferenceWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
          title: 'Total duration:',
          content: getFormattedTime(context.read<PinealCubit>().noOfSets * 
            (context.read<PinealCubit>().holdDuration + context.read<PinealCubit>().recoveryBreathDuration)),
          iconPath: ImagePath.timeImage.path,
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
          content: context.read<PinealCubit>().currentSet.toString(),
          iconPath: ImagePath.timeImage.path,
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        divider(),


        ResultContainerSectionWidget(
          title: 'Hold time per set:',
          content: getFormattedTime(context.read<PinealCubit>().holdDuration),
          iconPath: ImagePath.timeImage.path,
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        divider(),


        ResultContainerSectionWidget(
          title: 'Recovery breath per set:',
          content: getFormattedTime(context.read<PinealCubit>().recoveryBreathDuration),
          iconPath: ImagePath.recoveryIcon.path,
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        divider(),


        ResultContainerSectionWidget(
          title: "Jerry's voice:",
          content: context.read<PinealCubit>().jerryVoice ?"Yes" : "No",
          iconPath: ImagePath.voiceImage.path,
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
          content: context.read<PinealCubit>().music ?"Yes" : "No",
          iconPath: ImagePath.musicImage.path,
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
          content: context.read<PinealCubit>().chimes ?"Yes" : "No",
          iconPath: ImagePath.chimeImage.path,
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: Colors.white,
          textColor: Colors.black.withOpacity(.7),
          iconColor: const Color(0xffFE60D4),
        ),
        divider(),

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