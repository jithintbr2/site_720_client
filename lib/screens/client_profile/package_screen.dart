import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:site720_client/screens/bottomNavigationBarScreen.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';
import 'package:path_provider/path_provider.dart';

class PackageScreen extends StatefulWidget {
  final String projectId;
  const PackageScreen(this.projectId, {super.key});

  @override
  State<PackageScreen> createState() => _PackageScreenState();
}

class _PackageScreenState extends State<PackageScreen> {
  dynamic package;
  bool? result = true;
  String token = "";
  String filePath = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    token = await Common.getSharedPref("token");

    final connectivityResult = await Connectivity().checkConnectivity();

    final hasInternet =
        connectivityResult.contains(ConnectivityResult.mobile) ||
            connectivityResult.contains(ConnectivityResult.wifi);

    if (!hasInternet) {
      if (!mounted) return;

      setState(() {
        result = false;
      });
      return;
    }

    try {
      final data = await HttpService.getClientPackage(
        token,
        widget.projectId,
      );

      if (data == null) {
        if (!mounted) return;

        setState(() {
          result = false;
        });
        return;
      }

      final tempDir = await getTemporaryDirectory();
      final path = "${tempDir.path}/downloaded_file.pdf";

      final file = File(path);
      await file.writeAsBytes(data.data);

      if (!mounted) return;

      setState(() {
        result = true;
        package = data;
        filePath = path;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        result = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return result == true
        ? RefreshIndicator(
            onRefresh: () async {
              await getData();
              return;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Color.fromARGB(248, 218, 177, 188),
                iconTheme: IconThemeData(
                  color: const Color.fromARGB(
                      255, 255, 255, 255), //change your color here
                ),
                title: Text("Package Details",
                    style: TextStyle(color: Colors.white)),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        // Container(
                        //   height: 25,
                        //   width: 25,
                        //   decoration: BoxDecoration(
                        //     image: DecorationImage(
                        //       image: AssetImage(Assets.h4logo),
                        //       fit: BoxFit.fitWidth,
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(width: 5,),
                        // Text('HOMES4',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ],
              ),
              body: package != null
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: PDFView(
                        filePath: filePath,
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
              bottomNavigationBar: BottomNavigationBarScreen(token: token),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: SizedBox(
              width: MediaQuery.of(context).size.width * 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(Assets.noNetwork),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    'No Network Found !',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      getData();
                    },
                    child: SizedBox(
                      width: 120,
                      height: 35,
                      child: Padding(
                        padding: const EdgeInsets.all(1.5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              'Try Again',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }
}
