import 'dart:io';

import 'package:PocketBuddy/constants/ConstantValues.dart';
import 'package:PocketBuddy/mapper/UserDetails.dart';
import 'package:PocketBuddy/services/GroupDetailsService.dart';
import 'package:PocketBuddy/utils/AuthUtils.dart';
import 'package:PocketBuddy/widgets/groupWidgets/RegisterGroupWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'JoinGroupWidget.dart';

class NoGroupFoundWidget extends StatefulWidget {
  const NoGroupFoundWidget({super.key, required this.refreshGroupList});

  final Function refreshGroupList;

  @override
  State<NoGroupFoundWidget> createState() => _NoGroupFoundWidgetState();
}

class _NoGroupFoundWidgetState extends State<NoGroupFoundWidget> {
  final _searchFormKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  UserDetails? loginUser;
  String authToken = "";

  bool _loadingData = true;

  late BannerAd bannerAd;
  bool isAdLoaded = false;
  bool _findingGroup = false;

  final groupDetailService = GroupDetailService();

  @override
  void initState() {
    super.initState();
    _loadPreRequestData();
    initBannerAd();
  }

  void initBannerAd() {
    String addId =
        Platform.isAndroid
            ? ConstantValues.bannerAdIdAndroid
            : ConstantValues.bannerAdIdIOS;
    bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: addId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print("Failed to load Banner Ad in Nogroupfoundwidget: $error");
        },
      ),
      request: const AdRequest(),
    );

    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return _loadingData || _findingGroup
        ? const Center(child: CircularProgressIndicator())
        : Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Search Form
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Form(
                  key: _searchFormKey,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _searchController,
                          decoration: const InputDecoration(
                            labelText: 'Group code',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      ElevatedButton(
                        onPressed: () {
                          _findGroup();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 24,
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          "Find",
                          style: TextStyle(
                            letterSpacing: 0.3,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Message
              Column(
                children: const [
                  Text(
                    "No Group Found!",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Please Join OR Create a Group!",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),

              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RegisterGroupWidget(
                                savedUserDetails: loginUser,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(40),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Text(
                            "+",
                            style: GoogleFonts.lato(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (isAdLoaded) const SizedBox(height: 16),
                  if (isAdLoaded)
                    SizedBox(
                      width: bannerAd.size.width.toDouble(),
                      height: bannerAd.size.height.toDouble(),
                      child: AdWidget(ad: bannerAd),
                    ),
                ],
              ),
            ],
          ),
        );
  }

  Future<void> _loadPreRequestData() async {
    authToken = await AuthUtils().getAuthToken();
    loginUser = await UserDetails.fetchUserDetailsFromStorage();
    setState(() {
      _loadingData = false;
    });
  }

  void _findGroup() async {
    setState(() {
      _findingGroup = true;
    });
    // extract data
    final groupId = _searchController.text.trim();
    final findGroup = await groupDetailService.findGroup(groupId);
    final joinMembers = await groupDetailService.fetchJoinMembers(groupId);
    if (findGroup != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => JoinGroupWidget(
            joinGroup: findGroup!,
            joinMembers: joinMembers,
          ),
        ),
      );
      setState(() {
        _findingGroup = false;
      });
    } else {
      // show scafold message error message that invalid groupID
    }
  }
  void _registerGroup() {
    
  }

}
