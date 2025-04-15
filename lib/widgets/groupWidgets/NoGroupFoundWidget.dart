import 'package:PocketBuddy/mapper/UserDetails.dart';
import 'package:PocketBuddy/utils/AuthUtils.dart';
import 'package:PocketBuddy/widgets/groupWidgets/RegisterGroupWidget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Nogroupfoundwidget extends StatefulWidget {
  const Nogroupfoundwidget({super.key, required this.refershGroupList});

  final Function refershGroupList;

  @override
  State<Nogroupfoundwidget> createState() => _NogroupfoundwidgetState();
}

class _NogroupfoundwidgetState extends State<Nogroupfoundwidget> {
  final _searchFormKey = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();

  // load login user details form storage
  UserDetails? loginUser;
  String authToken = "";

  bool _loadingData = true;

  @override
  void initState() {
    _loadPreRequestData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loadingData
        ? Center(child: CircularProgressIndicator())
        : Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Form(
                  key: _searchFormKey,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: 'Group code',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      SizedBox(width: 14),
                      ElevatedButton(
                        onPressed: () {},
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
              Column(
                children: [
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
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => RegisterGroupWidget(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        "+",
                        style: GoogleFonts.lato(
                          fontSize: 36,
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryFixedDim,
                    ),
                    child: Center(child: Text("Loading Ads...")),
                  ),
                ],
              ),
            ],
          ),
        );
  }

  _loadPreRequestData() async {
    authToken = await AuthUtils().getAuthToken();
    loginUser = await UserDetails.getInstance();
    setState(() {
      _loadingData = false;
    });
  }

  _findGroup() {}

  _registerGroup() {}
}
