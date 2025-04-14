import 'package:PocketBuddy/constants/ConstantValues.dart';
import 'package:PocketBuddy/main.dart';
import 'package:flutter/material.dart';

class ThemeWidget extends StatefulWidget {
  const ThemeWidget({super.key});

  @override
  State<ThemeWidget> createState() => _ThemeWidgetState();
}

class _ThemeWidgetState extends State<ThemeWidget> {
  ThemeMode _selectedMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadCurrentTheme();
  }

  void _loadCurrentTheme() async {
    final current = await loadThemeFromStorage();
    setState(() {
      _selectedMode = current;
    });
  }

  void _onThemeSelected(ThemeMode mode, index) async {
    await _saveTheme(index);
    setState(() {
      _selectedMode = mode;
    });
    MyApp.of(context)?.changeTheme(mode);
  }

  _saveTheme(index) async {
    switch (index) {
      case 0:
        await storage.write(
          key: ConstantValues.themeKey,
          value: ConstantValues.themeSystem,
        );
      case 1:
        await storage.write(
          key: ConstantValues.themeKey,
          value: ConstantValues.themeLight,
        );
      case 2:
        await storage.write(
          key: ConstantValues.themeKey,
          value: ConstantValues.themeDark,
        );
      default:
        await storage.write(
          key: ConstantValues.themeKey,
          value: ConstantValues.themeSystem,
        );
    }
  }

  Widget _buildTile(String label, ThemeMode mode, IconData icon, index) {
    return RadioListTile<ThemeMode>(
      value: mode,
      groupValue: _selectedMode,
      onChanged: (value) {
        if (value != null) _onThemeSelected(value, index);
      },
      title: Text(label),
      secondary: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Choose Theme")),
      body: Column(
        children: [
          _buildTile(
            "System Default",
            ThemeMode.system,
            Icons.phone_android,
            0,
          ),
          _buildTile("Light Theme", ThemeMode.light, Icons.light_mode, 1),
          _buildTile("Dark Theme", ThemeMode.dark, Icons.dark_mode, 2),
        ],
      ),
    );
  }
}
