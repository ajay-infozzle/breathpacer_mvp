import 'package:breathpacer_mvp/bloc/pyramid/pyramid_cubit.dart';
import 'package:breathpacer_mvp/config/theme.dart';
import 'package:breathpacer_mvp/utils/constant/interaction_breathing_constant.dart';
import 'package:breathpacer_mvp/view/widget/result_container_section_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PyramidOutBreathHoldTimeWidget extends StatelessWidget {
  const PyramidOutBreathHoldTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        if(context.read<PyramidCubit>().holdBreathoutTimeList.isNotEmpty)
        ResultContainerSectionWidget(
          title: 'Out-breath holding time:',
          content: getTotalTimeString(context.read<PyramidCubit>().holdBreathoutTimeList),
          iconPath: ImagePath.timeImage.path,
          iconSize: 25.0,
          showIcon: true,
          showContent: true,
          containerColor: AppTheme.colors.newPrimaryColor,
          textColor: Colors.white,
          iconColor: Colors.white,
        ),

        if(context.read<PyramidCubit>().holdBreathoutTimeList.isNotEmpty)
        for (int i = 0; i < context.read<PyramidCubit>().holdBreathoutTimeList.length; i++) ...[
          ResultContainerSectionWidget(
            title: "Round ${i + 1} hold time:",
            showIcon: false,
            showContent: true,
            content: getFormattedTime(context.read<PyramidCubit>().holdBreathoutTimeList[i]),
            containerColor: Colors.white,
            textColor: Colors.black.withOpacity(.7),
          ),
          divider(),
        ],
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