import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:war_chest/pages/game_page.dart';
import 'package:war_chest/utils/navigation.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  runApp(
    MaterialApp(
      initialRoute: Navigation.gamePage,
      routes: {
        Navigation.gamePage: (context) => const GamePage(),
      },
      theme: ThemeData.dark(),
    ),
  );
}
