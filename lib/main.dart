import 'dart:convert';
import 'package:PocketBuddy/constants/ConstantValues.dart';
import 'package:PocketBuddy/screens/AuthScreen.dart';
import 'package:PocketBuddy/screens/HomeScreen.dart';
import 'package:PocketBuddy/utils/AuthUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:json_theme/json_theme.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:video_player/video_player.dart';

final FlutterSecureStorage storage = FlutterSecureStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  final lightThemeString = await rootBundle.loadString(
    "assets/themes/theme_light.json",
  );
  final darkThemeString = await rootBundle.loadString(
    "assets/themes/theme_dark.json",
  );

  final lightTheme =
      ThemeDecoder.decodeThemeData(jsonDecode(lightThemeString))!.copyWith();
  final darkTheme =
      ThemeDecoder.decodeThemeData(jsonDecode(darkThemeString))!.copyWith();

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
      debugShowCheckedModeBanner: false,
      title: 'Pocket Buddy',
      theme: widget.lightThemeData,
      darkTheme: widget.darkThemeData,
      themeMode: _themeMode,
      home: const SplashAndAuthGate(),
    );
  }
}

// ✅ Handles Splash Video + Auth Check
class SplashAndAuthGate extends StatefulWidget {
  const SplashAndAuthGate({super.key});

  @override
  State<SplashAndAuthGate> createState() => _SplashAndAuthGateState();
}

class _SplashAndAuthGateState extends State<SplashAndAuthGate> {
  late VideoPlayerController _controller;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(
        'assets/video/Pocket_Buddy_Animation_Logo.mp4',
      )
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

    _controller.addListener(() {
      if (_controller.value.position >= _controller.value.duration &&
          !_navigated) {
        _navigated = true;
        _checkAuthAndNavigate();
      }
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    bool isLoggedIn = await AuthUtils().havingAuthToken();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => isLoggedIn ? const HomeScreen() : const AuthScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _controller.value.isInitialized
              ? SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
