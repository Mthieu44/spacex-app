import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacex_app/logic/cubit/launch.cubit.dart';
import 'package:spacex_app/logic/cubit/view.cubit.dart';
import 'package:spacex_app/ui/pages/home.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpaceX Launches',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
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