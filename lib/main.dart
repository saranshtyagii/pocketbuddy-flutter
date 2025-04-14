import 'dart:convert';
import 'package:PocketBuddy/constants/ConstantValues.dart';
import 'package:PocketBuddy/screens/AuthScreen.dart';
import 'package:PocketBuddy/screens/HomeScreen.dart';
import 'package:PocketBuddy/utils/AuthUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:json_theme/json_theme.dart';

final FlutterSecureStorage storage = FlutterSecureStorage();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final lightThemeString = await rootBundle.loadString(
    "assets/themes/theme_light.json",
  );
  final darkThemeString = await rootBundle.loadString(
    "assets/themes/theme_dark.json",
  );

  final lightTheme = ThemeDecoder.decodeThemeData(
    jsonDecode(lightThemeString),
  )!.copyWith(useMaterial3: false);
  final darkTheme = ThemeDecoder.decodeThemeData(
    jsonDecode(darkThemeString),
  )!.copyWith(useMaterial3: false);

  final savedThemeMode = await loadThemeFromStorage();

  runApp(
    MyApp(
      lightThemeData: lightTheme,
      darkThemeData: darkTheme,
      initialThemeMode: savedThemeMode,
    ),
  );
}

Future<ThemeMode> loadThemeFromStorage() async {
  try {
    final savedTheme = await storage.read(key: ConstantValues.themeKey);
    switch (savedTheme) {
      case ConstantValues.themeLight:
        return ThemeMode.light;
      case ConstantValues.themeDark:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  } catch (_) {
    return ThemeMode.system;
  }
}

class MyApp extends StatefulWidget {
  final ThemeData lightThemeData;
  final ThemeData darkThemeData;
  final ThemeMode initialThemeMode;

  const MyApp({
    super.key,
    required this.lightThemeData,
    required this.darkThemeData,
    required this.initialThemeMode,
  });

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.initialThemeMode;
  }

  void changeTheme(ThemeMode mode) async {
    setState(() {
      _themeMode = mode;
    });

    String value = ConstantValues.themeSystem;
    if (mode == ThemeMode.light) {
      value = ConstantValues.themeLight;
    } else if (mode == ThemeMode.dark) {
      value = ConstantValues.themeDark;
    }

    await storage.write(key: ConstantValues.themeKey, value: value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Pocket Buddy',
      theme: widget.lightThemeData,
      darkTheme: widget.darkThemeData,
      themeMode: _themeMode,
      home: FutureBuilder<bool>(
        future: AuthUtils().havingAuthToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData && snapshot.data == true) {
            return const HomeScreen();
          } else {
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
