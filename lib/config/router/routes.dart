import 'package:breathpacer_mvp/config/router/routes_name.dart';
import 'package:breathpacer_mvp/view/disclamer_widget.dart';
import 'package:breathpacer_mvp/view/fireBreathing/firebreathing_hold_screen.dart';
import 'package:breathpacer_mvp/view/fireBreathing/firebreathing_recovery_screen.dart';
import 'package:breathpacer_mvp/view/fireBreathing/firebreathing_screen.dart';
import 'package:breathpacer_mvp/view/fireBreathing/firebreathing_setting_screen.dart';
import 'package:breathpacer_mvp/view/fireBreathing/firebreathing_success_screen.dart';
import 'package:breathpacer_mvp/view/fireBreathing/firebreathing_waiting_screen.dart';
import 'package:breathpacer_mvp/view/interactive_breathing.dart';
import 'package:breathpacer_mvp/view/pyramidBreathing/breathing_step_guide_screen.dart';
import 'package:breathpacer_mvp/view/pyramidBreathing/pyramid_breath_hold_screen.dart';
import 'package:breathpacer_mvp/view/pyramidBreathing/pyramid_breathing_screen.dart';
import 'package:breathpacer_mvp/view/pyramidBreathing/pyramid_setting_screen.dart';
import 'package:breathpacer_mvp/view/pyramidBreathing/pyramid_success_screen.dart';
import 'package:breathpacer_mvp/view/pyramidBreathing/waiting_after_hold_screen.dart';
import 'package:breathpacer_mvp/view/pyramidBreathing/widget/pyramid_waiting_screen.dart';
import 'package:breathpacer_mvp/view/splash/splash_screen.dart';
import 'package:breathpacer_mvp/view/widget/countdown_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoutes {

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: "/",
        name: RoutesName.splashScreen,
        builder: (context, state) => const SplashScreen(),
        routes: [
          
          GoRoute(
            path: RoutesName.homeScreen,
            name: RoutesName.homeScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const InteractiveBreathingScreen(),  
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.disclamerScreen,
            name: RoutesName.disclamerScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const DisclamerScreen(), 
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.countdownScreen,
            name: RoutesName.countdownScreen,
            pageBuilder: (context, state) {
              String path = state.extra as String;
              return customPageRouteBuilder(
                CountdownScreen(pathToNavigate: path), 
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.interactiveBreathingScreen,
            name: RoutesName.interactiveBreathingScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const InteractiveBreathingScreen(), 
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.breathingStepGuideScreen,
            name: RoutesName.breathingStepGuideScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const BreathingStepGuideScreen(), 
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.pyramidSettingScreen,
            name: RoutesName.pyramidSettingScreen,
            pageBuilder: (context, state) {
              dynamic parameters = state.extra ;
              return customPageRouteBuilder(
                PyramidSettingScreen(
                  step: parameters["step"]!,
                ), 
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.pyramidWaitingScreen,
            name: RoutesName.pyramidWaitingScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const PyramidWaitingScreen(),
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.pyramidBreathingScreen,
            name: RoutesName.pyramidBreathingScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const PyramidBreathingScreen(),
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.pyramidBreathHoldScreen,
            name: RoutesName.pyramidBreathHoldScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const PyramidBreathHoldScreen(),
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.waitingAfterHoldScreen,
            name: RoutesName.waitingAfterHoldScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const WaitingAfterHoldScreen(),
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.pyramidSuccessScreen,
            name: RoutesName.pyramidSuccessScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const PyramidSuccessScreen(),
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),


          // ----- firebreathing routes -----
          GoRoute(
            path: RoutesName.fireSettingScreen,
            name: RoutesName.fireSettingScreen,
            pageBuilder: (context, state) {
              dynamic parameters = state.extra ;
              return customPageRouteBuilder(
                FirebreathingSettingScreen(
                  subTitle: parameters["subTitle"]!,
                ), 
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.fireBreathingWaitingScreen,
            name: RoutesName.fireBreathingWaitingScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const FirebreathingWaitingScreen(),
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.fireBreathingScreen,
            name: RoutesName.fireBreathingScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const FirebreathingScreen(),
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          // GoRoute(
          //   path: RoutesName.fireBreathingCountdownScreen,
          //   name: RoutesName.fireBreathingCountdownScreen,
          //   pageBuilder: (context, state) {
          //     dynamic params = state.extra ;
          //     return customPageRouteBuilder(
          //       FirebreathingCountdownScreen(
          //         gotoHold: params['hold'] ?? false,
          //         gotoRecover: params['recover'] ?? false,
          //         gotoSuccess: params['success'] ?? false,
          //       ),
          //       state.pageKey, 
          //       transitionDuration: const Duration(milliseconds: 500)
          //     );
          //   },
          // ),

          GoRoute(
            path: RoutesName.fireBreathingHoldScreen,
            name: RoutesName.fireBreathingHoldScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const FirebreathingHoldScreen(),
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.fireBreathingRecoveryScreen,
            name: RoutesName.fireBreathingRecoveryScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const FirebreathingRecoveryScreen(),
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),

          GoRoute(
            path: RoutesName.fireBreathingSuccessScreen,
            name: RoutesName.fireBreathingSuccessScreen,
            pageBuilder: (context, state) {
              return customPageRouteBuilder(
                const FirebreathingSuccessScreen(),
                state.pageKey, 
                transitionDuration: const Duration(milliseconds: 500)
              );
            },
          ),
          // ----- firebreathing routes end -----

        ] 
      ),
    ]
  );
}

CustomTransitionPage customPageRouteBuilder(Widget page, LocalKey pageKey, {required Duration transitionDuration}) {
  return CustomTransitionPage(
    key: pageKey,
    child: page,
    fullscreenDialog: true,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
    transitionDuration: transitionDuration,
  );
}


CustomTransitionPage customPageRouteBuilderBottomToTop(Widget page, LocalKey pageKey, {required Duration transitionDuration}) {
  return CustomTransitionPage(
    key: pageKey,
    child: page,
    fullscreenDialog: true,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(position: offsetAnimation, child: child);
    },
    transitionDuration: transitionDuration,
  );
}