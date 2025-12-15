import 'package:breathpacer_mvp/bloc/dna/dna_cubit.dart';
import 'package:breathpacer_mvp/bloc/firebreathing/firebreathing_cubit.dart';
import 'package:breathpacer_mvp/bloc/pineal/pineal_cubit.dart';
import 'package:breathpacer_mvp/bloc/pyramid/pyramid_cubit.dart';
import 'package:breathpacer_mvp/config/router/routes.dart';
import 'package:breathpacer_mvp/config/services/audio_services.dart';
import 'package:breathpacer_mvp/config/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  
  // Only enable wakelock on mobile
  if (!kIsWeb) {
    WakelockPlus.enable();
  }

  if (!kIsWeb) {
    final dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
  }

  // final dir = await getApplicationDocumentsDirectory();
  // Hive.init(dir.path);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    final AudioOrchestrator audioOrchestrator = AudioOrchestrator();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PyramidCubit(audioOrchestrator)),
        BlocProvider(create: (context) => FirebreathingCubit(audioOrchestrator)),
        BlocProvider(create: (context) => DnaCubit(audioOrchestrator)),
        BlocProvider(create: (context) => PinealCubit(audioOrchestrator)),
      ],
      child: Builder(
        builder: (context){
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
            child: MaterialApp.router(
              title: 'Breath Pacer',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.define(),
              routerConfig: AppRoutes.router,
            ),
          );
        },
      ),
    );
  }
}
