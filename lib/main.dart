import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spacex_app/logic/cubit/launch.cubit.dart';
import 'package:spacex_app/logic/cubit/view.cubit.dart';
import 'package:spacex_app/ui/pages/home.page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getApplicationDocumentsDirectory()).path),
  );

  HydratedBloc.storage = storage;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpaceX Launches',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        scaffoldBackgroundColor: Colors.transparent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        textTheme: GoogleFonts.shareTechTextTheme(
          ThemeData.dark().textTheme
        ).copyWith(
          bodyMedium: GoogleFonts.shareTech(fontSize: 16),
          bodyLarge: GoogleFonts.shareTech(fontSize: 18),
          bodySmall: GoogleFonts.shareTech(fontSize: 14),
        )
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<LaunchCubit>(
            create: (context) => LaunchCubit()..fetchLaunches(),
          ),
          BlocProvider<ViewCubit>(
            create: (context) => ViewCubit(),
          ),
        ],
        child: const HomePage()
      )
    );
  }
}