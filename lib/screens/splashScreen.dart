import 'dart:async';
import 'package:flutter/material.dart';
import 'package:site720_client/model/forceUpdateModel.dart';
import 'package:site720_client/screens/client_profile/pin_entry_screen.dart';
import 'package:site720_client/screens/dashboard.dart';
import 'package:site720_client/screens/forceUpdate.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 2;
  ForceUpdateModel? updatedata;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  final Color backgroundColor =  Color.fromARGB(255, 230, 195, 204); 

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _packageInfo = info;
      });

      final appVersion = _packageInfo.version;
      print(appVersion);

      updatedata = await HttpService.forceUpdate();

      if (updatedata == null || updatedata!.data == null) {
        print("Force update API failed, skipping version check");
        _checkFirstInstall();
        return;
      }

      print('min version: ${updatedata!.data!.minVersion}');
      print('current version: ${updatedata!.data!.currentVersion}');

      int versionCompare =
          appVersion.compareTo(updatedata!.data!.minVersion.toString());

      if (versionCompare < 0) {
        _checkVersion();
      } else {
        _checkFirstInstall();
      }
    } catch (e) {
      print("Splash error: $e");
      _checkFirstInstall();
    }
  }

  void _checkVersion() {
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const ForceUpdate()),
      (Route<dynamic> route) => false,
    );
  }

  void _checkFirstInstall() {
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      _checkPinStatus();
    });
  }

  void _checkPinStatus() async {
    if (!mounted) return;
    String? pinVerified = await Common.getSharedPref("pin_verified");
    if (pinVerified == "true") {
      String? token = await Common.getSharedPref("token");
      _goToDashboard(token ?? '');
    } else {
      _goToPinEntry();
    }
  }

  void _goToDashboard(String token) {
    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => Dashboard(token: token)),
      (Route<dynamic> route) => false,
    );
  }

  void _goToPinEntry() {
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PinEntryScreen(
          onComplete: (bool success, String? message) {
            if (success) {
              Future.microtask(() {
                if (!mounted) return;
                Navigator.pop(context);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  Common.getSharedPref("token").then((token) {
                    if (!mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => Dashboard(token: token ?? ''),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  });
                });
              });
            } else {
              print('PIN verification failed: $message');
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Container(
          width: 150, 
          height: 150, 
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.whiteSplash),
              fit: BoxFit.contain, 
            ),
          ),
        ),
      ),
    );
  }
}