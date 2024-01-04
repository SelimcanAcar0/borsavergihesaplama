// ignore_for_file: prefer_const_constructors





import 'package:borsavergihesaplama/screens/anasayfa.dart';
import 'package:borsavergihesaplama/screens/sozlesmeSayfa.dart';
import 'package:borsavergihesaplama/screens/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() {
  runApp(Main());
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          textTheme: GoogleFonts.openSansTextTheme(
              Theme.of(context).textTheme.apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                  decorationColor: Colors.white
              ),
          ),
      ),
      initialRoute: '/',
      routes: {
        "/": (context) => SplashScreen(),
        "/sozlesmeSayfa":(context)=> SozlesmeSayfa(),
        "/anasayfa": (context) => Anasayfa(),
      },
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
       Locale('tr','TR'),
      ],
    );
  }
}

