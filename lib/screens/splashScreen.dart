import 'dart:async';
import 'package:flutter/material.dart';
import 'package:site720_client/model/forceUpdateModel.dart';
import 'package:site720_client/screens/dashboard.dart';
import 'package:site720_client/screens/forceUpdate.dart';
import 'package:site720_client/screens/pushNotification.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final splashDelay = 2;
  String? firebaseToken;
  ForceUpdateModel? updatedata;
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  void initState() {
    super.initState();
    // handleAsync();
    getData();

    //_loadWidget();
  }

  getData() async {
    updatedata = await HttpService.forceUpdate();
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
    final _appVersion = _packageInfo.version;
    print(_appVersion);
    print('min version');
    print(updatedata!.data!.minVersion);
    print('current version');
    print(updatedata!.data!.currentVersion);
    int versionCompare =
        _appVersion.compareTo(updatedata!.data!.minVersion.toString());
    print(versionCompare);

    if (versionCompare < 0) {
      _checkVersion();
    } else {
      _loadWidget();
    }
  }

  void _checkVersion() async {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => ForceUpdate()),
        (Route<dynamic> route) => false);
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    // return '';
    // return Timer(_duration, navigationPage);
    return Timer(_duration, routeTOHomePage);
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      FirebaseServices().init(context);
    });

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(Assets.splash),
          fit: BoxFit.cover,
        ),
      ),
    ));
  }

  routeTOHomePage() async {
    String? token = await Common.getSharedPref("token");
    print(token);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Dashboard(token: token)),
        (Route<dynamic> route) => false);

    //
    //   print(token);
    //
    //   if (token != null)
    //   {
    //     UserCheckModel userCheck = await HttpService.userCheck(token);
    //     if(userCheck.data==true){
    //       SurveyCountModel object = await HttpService.surveyCount(token);
    //       if(object.data!>0)
    //       {
    //         Navigator.of(context).pushAndRemoveUntil(
    //             MaterialPageRoute(builder: (context) => Dashboard(token)),
    //                 (Route<dynamic> route) => false);
    //       }
    //       else
    //       {
    //         Navigator.of(context).pushAndRemoveUntil(
    //             MaterialPageRoute(builder: (context) => SurveyPage(token)),
    //                 (Route<dynamic> route) => false);
    //       }
    //     }
    //     else{
    //       Common.toastMessaage(
    //           'Token Expired', Colors.green);
    //       Navigator.of(context).pushAndRemoveUntil(
    //           MaterialPageRoute(builder: (context) => LoginPage()),
    //               (Route<dynamic> route) => false);
    //     }
    //
    //
    //   }
    //
    //
    //   else
    //   {
    //     Navigator.of(context).pushAndRemoveUntil(
    //         MaterialPageRoute(builder: (context) => IntroductionScreenPage()),
    //             (Route<dynamic> route) => false);
    //   }
    //   // Navigator.of(context).pushAndRemoveUntil(
    //   //     MaterialPageRoute(builder: (context) => IntroductionScreenPage()),
    //   //     (Route<dynamic> route) => false);
    // }
  }
}
