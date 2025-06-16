import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/Provider/Theme_Provider.dart';
import 'package:weather_app/Theme/Theme.dart';
import 'package:weather_app/View/Splash_Screen.dart';

void main(){
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref){
    final themeMode = ref.watch(themeNotifierProvider);
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}