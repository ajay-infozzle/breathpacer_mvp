import 'package:breathpacer_mvp/bloc/firebreathing/firebreathing_cubit.dart';
import 'package:breathpacer_mvp/config/router/routes_name.dart';
import 'package:breathpacer_mvp/config/theme.dart';
import 'package:breathpacer_mvp/utils/constant/interaction_breathing_constant.dart';
import 'package:breathpacer_mvp/view/widget/breathing_choices_widget.dart';
import 'package:breathpacer_mvp/view/widget/custom_button.dart';
import 'package:breathpacer_mvp/view/widget/custom_modal_dropdown.dart';
import 'package:breathpacer_mvp/view/widget/modal_dropdown.dart';
import 'package:breathpacer_mvp/view/widget/settings_toggle_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FirebreathingSettingScreen extends StatelessWidget {
  const FirebreathingSettingScreen({super.key, required this.subTitle});

  final String subTitle;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: context.read<FirebreathingCubit>().isReatartEnable?false:true,
      onPopInvoked: (didPop) {
        if (context.read<FirebreathingCubit>().isReatartEnable) {
          context.read<FirebreathingCubit>().resetSettings();
          context.goNamed(RoutesName.homeScreen);
        }
        else{
          context.read<FirebreathingCubit>().resetSettings();
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
          child: Column(
            children: [
              AppBar(
                iconTheme: const IconThemeData(color: Colors.white),
                backgroundColor: Colors.transparent,
                centerTitle: true,
                scrolledUnderElevation: 0,
                leading: GestureDetector(
                  onTap: () {
                    if (context.read<FirebreathingCubit>().isReatartEnable) {
                      context.read<FirebreathingCubit>().resetSettings();
                      context.goNamed(RoutesName.homeScreen);
                    }
                    else{
                      context.read<FirebreathingCubit>().resetSettings();
                      context.pop();
                    }
                  },
                  child: const Icon(Icons.arrow_back_ios),
                ),
                title: const Text(
                  "Fire Breathing",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(
                height: size * 0.02,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: size * 0.05),
                color: Colors.white.withOpacity(.3),
                height: 1,
              ),

              //~
              Expanded(
                  child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: size * 0.04),
                      child: ListView(
                        children: [
                          SizedBox(
                            width: size,
                            child: CircleAvatar(
                              radius: size * 0.12,
                              child: Image.asset(ImagePath.fireIcon.path),
                            ),
                          ),

                          Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: size * 0.04),
                            width: size,
                            child: Text(
                              subTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: size * 0.04,
                              ),
                            ),
                          ),

                          SizedBox(
                            height: size * 0.06,
                          ),
                          SizedBox(
                            width: size,
                            child:
                                BlocBuilder<FirebreathingCubit, FirebreathingState>(
                              buildWhen: (previous, current) =>
                                  current is FirebreathingInitial ||
                                  current is FirebreathingUpdateSetDuration,
                              builder: (context, state) {
                                return CustomDropDown(
                                  onSelected: (int selectedDuration) {
                                    context
                                        .read<FirebreathingCubit>()
                                        .updateSetsDuration(selectedDuration);
                                  },
                                  title: "Duration of set:",
                                  selected: context
                                      .read<FirebreathingCubit>()
                                      .durationOfSets,
                                  options: context
                                      .read<FirebreathingCubit>()
                                      .durationsList,
                                  isTime: true,
                                );
                              },
                            ),
                          ),

                          SizedBox(height: size * 0.05,),
                          SizedBox(
                            width: size,
                            child:
                                BlocBuilder<FirebreathingCubit, FirebreathingState>(
                              buildWhen: (previous, current) =>
                                  current is FirebreathingInitial ||
                                  current is FirebreathingUpdateSetNumber,
                              builder: (context, state) {
                                return CustomDropDown(
                                  onSelected: (int selectedSet) {
                                    context
                                        .read<FirebreathingCubit>()
                                        .updateSetsNumber(selectedSet);
                                  },
                                  title: "Number of sets:",
                                  selected:
                                      context.read<FirebreathingCubit>().noOfSets,
                                  options:
                                      context.read<FirebreathingCubit>().setsList,
                                );
                              },
                            ),
                          ),


                          SizedBox(height: size * 0.05,),
                          SizedBox(
                            width: size,
                            child:
                                BlocBuilder<FirebreathingCubit, FirebreathingState>(
                              buildWhen: (previous, current) =>
                                  current is FirebreathingInitial ||
                                  current is FirebreathingToggleRecoveryBreath,
                              builder: (context, state) {
                                return SettingsToggleButton(
                                    onToggle: () {
                                      context
                                          .read<FirebreathingCubit>()
                                          .toggleRecoveryBreath();
                                    },
                                    title: "Recovery breath after each set :",
                                    isOn: context
                                        .read<FirebreathingCubit>()
                                        .recoveryBreath);
                              },
                            ),
                          ),

                          BlocBuilder<FirebreathingCubit, FirebreathingState>(
                            builder: (context, state) {
                              if (context
                                  .read<FirebreathingCubit>()
                                  .recoveryBreath) {
                                return Container(
                                  width: size,
                                  margin: EdgeInsets.only(top: size * 0.05),
                                  child: CustomDropDown(
                                    onSelected: (int selected) {
                                      context
                                          .read<FirebreathingCubit>()
                                          .updateRecoveryDuration(selected);
                                    },
                                    title: "Recovery breath duration:",
                                    selected: context
                                        .read<FirebreathingCubit>()
                                        .recoveryBreathDuration,
                                    options: context
                                        .read<FirebreathingCubit>()
                                        .recoveryDurationList,
                                    isTime: true,
                                  ),
                                );
                              }
                              return const SizedBox();
                            },
                          ),

                          SizedBox(height: size * 0.05,),
                          SizedBox(
                            width: size,
                            child:
                                BlocBuilder<FirebreathingCubit, FirebreathingState>(
                              buildWhen: (previous, current) =>
                                  current is FirebreathingInitial ||
                                  current is FirebreathingToggleHolding,
                              builder: (context, state) {
                                return SettingsToggleButton(
                                    onToggle: () {
                                      context
                                          .read<FirebreathingCubit>()
                                          .toggleHolding();
                                    },
                                    title: "Holding period after each set :",
                                    isOn: context
                                        .read<FirebreathingCubit>()
                                        .holdingPeriod);
                              },
                            ),
                          ),


                          BlocBuilder<FirebreathingCubit, FirebreathingState>(
                            buildWhen: (previous, current) =>
                                current is FirebreathingInitial ||
                                current is FirebreathingToggleBreathHoldChoice ||
                                current is FirebreathingToggleHolding,
                            builder: (context, state) {
                              if (!context
                                  .read<FirebreathingCubit>()
                                  .holdingPeriod) {
                                return const SizedBox();
                              }
                              return Container(
                                width: size,
                                margin: EdgeInsets.only(top: size * 0.05),
                                child: CustomDropDown(
                                  onSelected: (int selected) {
                                    context
                                        .read<FirebreathingCubit>()
                                        .updateHold(selected);
                                  },
                                  title: "Holding period duration:",
                                  selected: context
                                      .read<FirebreathingCubit>()
                                      .holdDuration,
                                  options: context
                                      .read<FirebreathingCubit>()
                                      .holdDurationList,
                                  isTime: true,
                                ),
                              );
                            },
                          ),


                          BlocBuilder<FirebreathingCubit, FirebreathingState>(
                            buildWhen: (previous, current) =>
                                current is FirebreathingInitial ||
                                current is FirebreathingToggleBreathHoldChoice ||
                                current is FirebreathingToggleHolding,
                            builder: (context, state) {
                              if (!context
                                  .read<FirebreathingCubit>()
                                  .holdingPeriod) {
                                return const SizedBox();
                              }
                              return Container(
                                width: size,
                                margin: EdgeInsets.only(top: size * 0.05),
                                child: BreathingChoices(
                                  chosenItem: context
                                      .read<FirebreathingCubit>()
                                      .breathHoldIndex,
                                  choicesList: context
                                      .read<FirebreathingCubit>()
                                      .breathHoldList,
                                  onUpdateChoiceIndex: (int index) {
                                    context
                                        .read<FirebreathingCubit>()
                                        .toggleBreathHold(index);
                                  },
                                ),
                              );
                            },
                          ),


                          SizedBox(height: size * 0.05,),
                          SizedBox(
                            width: size,
                            child:
                                BlocBuilder<FirebreathingCubit, FirebreathingState>(
                              buildWhen: (previous, current) => current is FirebreathingInitial ||
                                  current is FirebreathingToggleJerryVoice,
                              builder: (context, state) {
                                return SettingsToggleButton(
                                    onToggle: () {
                                      context.read<FirebreathingCubit>().toggleJerryVoice();
                                    },
                                    title: "Jerry's voice :",
                                    isOn: context.read<FirebreathingCubit>().jerryVoice);
                              },
                            ),
                          ),


                          SizedBox(height: size * 0.05,),
                          Container(
                            width: size,
                            margin: EdgeInsets.only(left: size*0.03),
                            child:
                                BlocBuilder<FirebreathingCubit, FirebreathingState>(
                              buildWhen: (previous, current) =>
                                  current is FirebreathingInitial ||
                                  current is FirebreathingTogglePineal,
                              builder: (context, state) {
                                return SettingsToggleButton(
                                  onToggle: () {
                                    context
                                        .read<FirebreathingCubit>()
                                        .togglePineal();
                                  },
                                  title: "Pineal Gland :",
                                  isOn: context.read<FirebreathingCubit>().pineal,
                                  showPopup: true,
                                  showIcon: true,
                                );
                              },
                            ),
                          ),


                          SizedBox(height: size * 0.05,),
                          SizedBox(
                            width: size,
                            child: BlocBuilder<FirebreathingCubit, FirebreathingState>(
                              buildWhen: (previous, current) =>
                                  current is FirebreathingInitial ||
                                  current is FirebreathingToggleMusic,
                              builder: (context, state) => ModalDropDown(
                                onSelected: (String selected) {
                                  context.read<FirebreathingCubit>().updateMusic(selected);
                                },
                                title: "Music :",
                                selected:context.read<FirebreathingCubit>().selectedMusic,
                                options: musicList,
                              ),
                            ),
                          ),


                          SizedBox(height: size * 0.05,),
                          SizedBox(
                            width: size,
                            child:
                                BlocBuilder<FirebreathingCubit, FirebreathingState>(
                              buildWhen: (previous, current) =>
                                  current is FirebreathingInitial ||
                                  current is FirebreathingToggleChimes,
                              builder: (context, state) {
                                return SettingsToggleButton(
                                    onToggle: () {
                                      context
                                          .read<FirebreathingCubit>()
                                          .toggleChimes();
                                    },
                                    title: "Chimes at start / stop points :",
                                    isOn:
                                        context.read<FirebreathingCubit>().chimes);
                              },
                            ),
                          ),
                          
                          SizedBox(height: size * 0.05,),
                          SizedBox(
                            width: size,
                            child:
                                BlocBuilder<FirebreathingCubit, FirebreathingState>(
                              buildWhen: (previous, current) => current is FirebreathingInitial ||
                                  current is FirebreathingToggleSkipIntro,
                              builder: (context, state) {
                                return SettingsToggleButton(
                                    onToggle: () {
                                      context.read<FirebreathingCubit>().toggleSkipIntro();
                                    },
                                    title: "Skip intro",
                                    isOn: context.read<FirebreathingCubit>().skipIntro);
                              },
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(
                                top: size * 0.09,
                                bottom: size * 0.09,
                                right: size * 0.05,
                                left: size * 0.05),
                            height: 48,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                          margin: EdgeInsets.only(
                            top: size * 0.09,
                          ),
                          child: BlocConsumer<FirebreathingCubit, FirebreathingState>(
                            listener: (context, state) {
                              if(state is NavigateToWaitingScreen){
                                context.pushNamed(
                                  RoutesName.fireBreathingWaitingScreen,
                                );
                              }
                            },
                            builder: (context, state) {
                              return CustomButton(
                                title: "Start",
                                textsize: size * 0.043,
                                height: height * 0.062,
                                spacing: .7,
                                radius: 0,
                                onPress: () {
                                  context.read<FirebreathingCubit>().playBackgroundMusic();
                                  context.read<FirebreathingCubit>().playCloseEyes();
                                }
                              );
                            },
                          )),
                    )
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
