import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../model/villaProjectModel.dart';
import '../service/service.dart';
import '../settings/assets.dart';
import 'bottomNavigationBarScreen.dart';

class VillaProjectListPage extends StatefulWidget {
  final String? token;

  VillaProjectListPage({this.token, super.key});

  @override
  State<VillaProjectListPage> createState() => _VillaProjectListPageState();
}

class _VillaProjectListPageState extends State<VillaProjectListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool? result = true;
  VillaProjectModel? villaProjects;

  int _currentPage = 0;
  Timer? _timer;

  final PageController _pageController = PageController(initialPage: 0);

  /// ✅ YouTube controllers
  List<YoutubePlayerController> youtubeControllers = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  void dispose() {
    for (var c in youtubeControllers) {
      c.dispose();
    }
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    // CHECK NETWORK
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    result = connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);

    setState(() {});

    if (!result!) return;

    // API CALL
    villaProjects =
        await HttpService.villaProjectList(token: widget.token ?? "");

    if (villaProjects != null) {
      _setupImageSlider();
      _setupYoutubeControllers();
      setState(() {});
    }
  }

  /// ---------- IMAGE SLIDER TIMER ----------
  void _setupImageSlider() {
    _timer?.cancel();
    if (villaProjects!.data!.images!.isEmpty) return;

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < villaProjects!.data!.images!.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  void _setupYoutubeControllers() {
    youtubeControllers.clear();

    for (var url in villaProjects!.data!.youtubeLinks!) {
      debugPrint("Processing URL: $url");
      final videoId = YoutubePlayer.convertUrlToId(url.trim());
      debugPrint("Extracted Video ID: $videoId");

      if (videoId != null && videoId.isNotEmpty) {
        youtubeControllers.add(YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            disableDragSeek: false,
            loop: false,
            mute: false,
            controlsVisibleAtStart: true,
          ),
        ));

        debugPrint("✅ Controller created for: $videoId");
      } else {
        debugPrint("❌ Invalid YouTube URL: $url");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    if (result == false) {
      return _buildNoNetwork();
    }

    return RefreshIndicator(
      onRefresh: () async => getData(),
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            "Villa Projects",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            // Optional refresh button in app bar
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.black),
              onPressed: () => getData(),
            ),
          ],
        ),
        body: villaProjects != null ? _buildContent() : _buildLoader(),
        bottomNavigationBar: BottomNavigationBarScreen(token: widget.token),
      ),
    );
  }

  /// ---------------- MAIN CONTENT ----------------
  Widget _buildContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            /// IMAGES CAROUSEL
            GestureDetector(
              onTapDown: (_) => _timer?.cancel(),
              onTapUp: (_) => _setupImageSlider(),
              child: SizedBox(
                height: 200,
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      onPageChanged: (page) {
                        setState(() {
                          _currentPage = page;
                        });
                      },
                      itemCount: villaProjects!.data!.images!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: villaProjects!.data!.images![index]
                                  .toString(),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              placeholder: (_, __) =>
                                  Center(child: Image.asset(Assets.logo)),
                              errorWidget: (_, __, ___) =>
                                  const Center(child: Icon(Icons.error)),
                            ),
                          ),
                        );
                      },
                    ),

                    // Page indicators
                    if (villaProjects!.data!.images!.length > 1)
                      Positioned(
                        bottom: 10,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            villaProjects!.data!.images!.length,
                            (index) => Container(
                              width: 8,
                              height: 8,
                              margin: EdgeInsets.symmetric(horizontal: 3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _currentPage == index
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// HEADING
            Text(
              villaProjects!.data!.heading ?? "Villa Project",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),

            const SizedBox(height: 10),

            /// DESCRIPTION
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: ExpandableText(
                villaProjects!.data!.overviewDescription?.isNotEmpty == true
                    ? villaProjects!.data!.overviewDescription!
                    : "No description available for this project.",
                expandText: "Read more",
                collapseText: "Read less",
                maxLines: 4,
                linkColor: Colors.blue,
                style: TextStyle(fontSize: 14, color: Colors.grey[800]),
              ),
            ),

            const SizedBox(height: 25),

            /// VIDEOS SECTION HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Project Videos",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Text(
                  "${youtubeControllers.length} videos",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            /// YOUTUBE VIDEOS - SIMPLIFIED VERSION
            if (youtubeControllers.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: youtubeControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Video ${index + 1}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        // Minimal player widget
                        Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: YoutubePlayer(
                              controller: youtubeControllers[index],
                              showVideoProgressIndicator: true,
                              onReady: () {
                                debugPrint("Player READY");
                              },
                            )),
                      ],
                    ),
                  );
                },
              )
            else
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  children: [
                    Icon(Icons.videocam_off, size: 50, color: Colors.grey[400]),
                    const SizedBox(height: 15),
                    Text(
                      "No videos available",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            // Project summary
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.photo_library, color: Colors.blue[700]),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${villaProjects!.data!.images!.length} Photos",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[800],
                          ),
                        ),
                        Text(
                          "${youtubeControllers.length} Videos",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.blue[700]),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// ---------------- LOADER ----------------
  Widget _buildLoader() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 20),
          Text(
            "Loading Villa Projects...",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- NO NETWORK SCREEN ----------------
  Widget _buildNoNetwork() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "Villa Projects",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Assets.noNetwork, width: 250),
              const SizedBox(height: 30),
              const Text(
                "No Internet Connection",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please check your connection and try again",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () => getData(),
                icon: const Icon(Icons.refresh),
                label: const Text("Try Again"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
