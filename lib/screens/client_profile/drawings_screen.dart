import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:site720_client/model/client_details/drawings_model.dart';
import 'package:site720_client/screens/bottomNavigationBarScreen.dart';
import 'package:site720_client/screens/fullImagePage.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:lottie/lottie.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  DrawingsModel? drawings;
  bool? result = true;
  String token = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

 getData() async {
    token = await Common.getSharedPref("token");
    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      setState(() {
        result = true;
      });
    } else {
      setState(() {
        result = false;
      });
    }
    drawings = await HttpService.getClientSiteDrawings(token);
    if (drawings != null) {
      setState(() {});
    }
  }

  // Download PDF to temporary directory
  Future<String> downloadPdf(String url) async {
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/${url.split('/').last}';
    final file = File(filePath);
    if (!await file.exists()) {
      await Dio().download(url, filePath);
    }
    return filePath;
  }

  // PDF viewer page
  void openPdf(String filePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text("PDF Viewer")),
          body: PDFView(
            filePath: filePath,
            enableSwipe: true,
            swipeHorizontal: false,
            autoSpacing: true,
            pageFling: true,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return result == true
        ? RefreshIndicator(
            onRefresh: () async {
              await getData();
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                iconTheme: const IconThemeData(color: Colors.black),
                title: const Text("Drawings", style: TextStyle(color: Colors.black)),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Container(
                      height: 25,
                      width: 25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Assets.h4logo),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              body: drawings != null
                  ? Padding(
                      padding: const EdgeInsets.all(20),
                      child: ListView.builder(
                        itemCount: drawings!.data.length,
                        itemBuilder: (context, index) {
                          final fileUrl = drawings!.data[index].imgPath;
                          final isPdf = fileUrl.toLowerCase().endsWith('.pdf');

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: InkWell(
                              onTap: () async {
                                if (isPdf) {
                                  final path = await downloadPdf(fileUrl);
                                  openPdf(path);
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => FullImagePage(fileUrl)),
                                  );
                                }
                              },
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 220,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: isPdf
                                      ? Container(
                                          color: Colors.grey.shade200,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: const [
                                                Icon(Icons.picture_as_pdf,
                                                    size: 50, color: Colors.red),
                                                SizedBox(height: 10),
                                                Text(
                                                  'PDF Document',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: fileUrl,
                                          fit: BoxFit.cover,
                                          placeholder: (_, __) => Center(
                                              child: Lottie.asset(
                                                  'assets/images/loading.json',
                                                  fit: BoxFit.fill)),
                                          errorWidget: (_, __, ___) =>
                                              const Icon(Icons.error),
                                        ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
              bottomNavigationBar:  BottomNavigationBarScreen(),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: SizedBox(
              width: MediaQuery.of(context).size.width,
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
                  const SizedBox(height: 15),
                  const Text(
                    'No Network Found !',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: () {
                      getData();
                    },
                    child: Container(
                      width: 120,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Center(
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
                ],
              ),
            ),
          );
  }
}
