import 'package:PocketBuddy/mapper/UserDetails.dart';
import 'package:PocketBuddy/screens/AuthScreen.dart';
import 'package:PocketBuddy/utils/AuthUtils.dart';
import 'package:PocketBuddy/widgets/settingWidgets/ContactUsWidget.dart';
import 'package:PocketBuddy/widgets/settingWidgets/SecurityWidget.dart';
import 'package:PocketBuddy/widgets/settingWidgets/StopAdsWidgets.dart';
import 'package:PocketBuddy/widgets/settingWidgets/ThemeWidgets.dart';
import 'package:PocketBuddy/widgets/settingWidgets/UpdateWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late UserDetails? savedUserDetails;
  bool _loadingUserDetails = true;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _loadingUserDetails
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    _buildProfileCard(context),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ListView(
                        children: [
                          _buildSettingOption("Stop Ads", Icons.block, 0),
                          _buildSettingOption("Theme", Icons.palette, 1),
                          _buildSettingOption("Security", Icons.security, 2),
                          _buildSettingOption("Update", Icons.system_update, 3),
                          _buildSettingOption(
                            "Contact Us",
                            Icons.contact_support,
                            4,
                          ),
                        ],
                      ),
                    ),
                    _buildLogoutButton(context),
                  ],
                ),
              ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(
                "assets/images/Pocket_Buddy_Logo_bg_removed.png",
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    savedUserDetails?.userFirstName ?? "User",
                    style: GoogleFonts.farro(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    savedUserDetails?.email ?? "",
                    style: GoogleFonts.abel(fontSize: 14),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption(String title, IconData icon, int index) {
    return InkWell(
      onTap: () => _jumpToScreenWidget(index),
      child: ListTile(
        leading: Icon(icon, size: 26, color: Colors.blueGrey),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: Colors.grey,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            _logout(context);
          },
          icon: const Icon(Icons.logout, color: Colors.white),
          label: const Text("Logout", style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  void _logout(BuildContext context) async {
    final isLogout = await AuthUtils().logout();

    if (!context.mounted) return;

    if (isLogout) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AuthScreen()),
            (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout failed. Please try again.')),
      );
    }
  }


  void _loadUserDetails() async {
    savedUserDetails = await UserDetails.fetchUserDetailsFromStorage();
    setState(() {
      _loadingUserDetails = false;
    });
  }

  void _jumpToScreenWidget(int index) {
    switch (index) {
      case 0:
        _pushWidget(const StopAdsWidget());
        break;
      case 1:
        _pushWidget(const ThemeWidget());
        break;
      case 2:
        _pushWidget(const SecurityWidget());
        break;
      case 3:
        _pushWidget(const UpdateWidget());
        break;
      case 4:
        _pushWidget(const ContactUsWidget());
        break;
      default:
        break;
    }
  }

  void _pushWidget(Widget widget) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => widget));
  }
}
