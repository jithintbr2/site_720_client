import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/model/client_details/drawings_model.dart';
import 'package:site720_client/screens/bottomNavigationBarScreen.dart';
import 'package:site720_client/screens/fullImagePage.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';
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
  bool isLoading = true;
  int stageIndex = 0;
  Map<String, List<Drawings>> groupedDrawings = {};

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
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
    
    // Group drawings by stageName
    if (drawings != null && drawings!.status == true && drawings!.data.isNotEmpty) {
      groupedDrawings = {};
      for (var drawing in drawings!.data) {
        // Handle empty or null stageName
        String stageKey = drawing.stageName.trim().isEmpty ? "No Stage" : drawing.stageName;
        if (!groupedDrawings.containsKey(stageKey)) {
          groupedDrawings[stageKey] = [];
        }
        groupedDrawings[stageKey]!.add(drawing);
      }
    }
    
    setState(() {
      isLoading = false;
    });
  }

  List<String> getStageNames() {
    return groupedDrawings.keys.toList();
  }

  @override
  Widget build(BuildContext context) {
    return result == true
        ? RefreshIndicator(
            onRefresh: () async {
              getData();
              return;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: const Color.fromARGB(248, 218, 177, 188),
                iconTheme: const IconThemeData(
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                title: const Text("Drawings", style: TextStyle(color: Colors.white)),
              ),
              body: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : (drawings == null || drawings!.status == false || drawings!.data.isEmpty)
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 250,
                                height: 250,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(Assets.noResult),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                drawings?.message ?? "No Drawings Found!",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 126, 126, 126),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 40),
                                child: Text(
                                  drawings?.status == false 
                                    ? "We couldn't retrieve the drawings at this time. Please try again later."
                                    : "It seems there are no drawings available for this site at the moment.",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () => getData(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(248, 218, 177, 188),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const SizedBox(height: 5),
                                // Stage selector tabs
                                Container(
                                  alignment: Alignment.center,
                                  margin: const EdgeInsets.only(left: 10, top: 18),
                                  width: MediaQuery.of(context).size.width,
                                  height: 30,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: [
                                      for (int i = 0; i < getStageNames().length; i++)
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              stageIndex = i;
                                            });
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.25,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Colors.white, width: 0),
                                              color: Colors.white,
                                              borderRadius: const BorderRadius.all(Radius.circular(6)),
                                            ),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        getStageNames()[i],
                                                        style: TextStyle(
                                                          color: stageIndex == i
                                                              ? const Color(0xFF3c9f9a)
                                                              : const Color(0xFF717171),
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 5),
                                                      stageIndex == i
                                                          ? Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(5),
                                                                color: const Color(0xFF3c9f9a),
                                                              ),
                                                              height: 3,
                                                              width: MediaQuery.of(context).size.width * 0.2,
                                                            )
                                                          : Container(),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Check if selected stage has drawings
                                groupedDrawings[getStageNames()[stageIndex]]?.isEmpty ?? true
                                    ? const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(50),
                                          child: Text(
                                            "No drawings available for this stage",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          final drawing = groupedDrawings[getStageNames()[stageIndex]]![index];
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 20, bottom: 20),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => FullImagePage(drawing.imgPath),
                                                      ),
                                                    );
                                                  },
                                                  child: SizedBox(
                                                    width: MediaQuery.of(context).size.width * 1,
                                                    height: 220,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: CachedNetworkImage(
                                                        height: MediaQuery.of(context).size.height * 0.3,
                                                        imageUrl: drawing.imgPath,
                                                        fit: BoxFit.cover,
                                                        placeholder: (_, __) => Center(
                                                          child: Lottie.asset(
                                                            'assets/images/loading.json',
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                        errorWidget: (_, __, ___) => Center(
                                                          child: Icon(
                                                            Icons.error,
                                                            color: Theme.of(context).primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                // Remarks section
                                                if (drawing.remarks.isNotEmpty)
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                                    child: Text(
                                                      'Remarks: ${drawing.remarks}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                if (drawing.remarks.isEmpty)
                                                  const Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 5),
                                                    child: Text(
                                                      "No remarks available",
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                        fontStyle: FontStyle.italic,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          );
                                        },
                                        itemCount: groupedDrawings[getStageNames()[stageIndex]]?.length ?? 0,
                                      ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
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
                  const Text(
                    'No Network Found !',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
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
                          child: const Center(
                            child: Text(
                              'Try Again',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
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