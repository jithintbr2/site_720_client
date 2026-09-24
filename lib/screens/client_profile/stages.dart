import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/model/client_details/stage_list_model.dart';
import 'package:site720_client/screens/bottomNavigationBarScreen.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';
import 'package:site720_client/settings/config.dart';
import 'package:timelines_plus/timelines_plus.dart';

class StageScreen extends StatefulWidget {
  final String projectId;
  const StageScreen(this.projectId, {super.key});

  @override
  State<StageScreen> createState() => _StageScreenState();
}

class _StageScreenState extends State<StageScreen> {
  StageListModel? stages;
  bool? result = true;
  String token = "";
  final Map<int, bool> _isExpandedMap =
      {}; // This will store the expansion state for each stage

  int _page = 1;
  final int _pageSize = 4;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);
    getData();
  }

  Future<void> getData({bool refresh = false}) async {
    if (_isLoading || _isLoadingMore) return;

    if (refresh) {
      _page = 1;
      _hasMore = true;
      _isExpandedMap.clear();
    }

    if (refresh || stages == null) {
      setState(() {
        _isLoading = true;
      });
    }

    token = await Common.getSharedPref("token");

    final connectivityResult = await Connectivity().checkConnectivity();

    final hasInternet =
        connectivityResult.contains(ConnectivityResult.mobile) ||
            connectivityResult.contains(ConnectivityResult.wifi);

    if (!hasInternet) {
      if (!mounted) return;

      setState(() {
        result = false;
        _isLoading = false;
      });

      return;
    }

    try {
      final data = await HttpService.getStageList(
        token,
        widget.projectId,
        page: _page,
        pageSize: _pageSize,
      );

      if (!mounted) return;

      if (data != null) {
        setState(() {
          result = true;

          if (_page == 1) {
            stages = data;
          } else {
            stages!.data.addAll(data.data);
          }

          // If less than page size came back,
          // there are no more pages.
          if (data.data.length < _pageSize) {
            _hasMore = false;
          }
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        result = false;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isLoadingMore = false;
        });
      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      if (!_isLoadingMore && _hasMore) {
        _loadNextPage();
      }
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    final nextPage = _page + 1;

    try {
      final data = await HttpService.getStageList(
        token,
        widget.projectId,
        page: nextPage,
        pageSize: _pageSize,
      );

      if (!mounted) return;

      if (data != null) {
        setState(() {
          _page = nextPage;

          stages!.data.addAll(data.data);

          if (data.data.length < _pageSize) {
            _hasMore = false;
          }
        });
      }
    } catch (e) {
      debugPrint("Stage pagination error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return result == true
        ? RefreshIndicator(
            onRefresh: () async => getData(refresh: true),
            child: Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                backgroundColor: Color.fromARGB(248, 218, 177, 188),
                elevation: 1,
                iconTheme: const IconThemeData(
                    color: Color.fromARGB(255, 255, 255, 255)),
                title: const Text("Stagewise Schedule",
                    style:
                        TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
                // actions: [
                //   Padding(
                //     padding: const EdgeInsets.only(right: 20),
                //     child: Container(
                //       height: 25,
                //       width: 25,
                //       decoration: BoxDecoration(
                //         image: DecorationImage(
                //           image: AssetImage(Assets.h4logo),
                //           fit: BoxFit.fitWidth,
                //         ),
                //       ),
                //     ),
                //   ),
                // ],
              ),
              body: stages != null
                  ? ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 20.0,
                      ),
                      itemCount: stages!.data.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        // Loading indicator at the bottom
                        if (index == stages!.data.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final stage = stages!.data[index];

                        return TimelineTile(
                          nodeAlign: TimelineNodeAlign.start,
                          node: TimelineNode(
                            indicator: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const DotIndicator(
                                  color: Colors.black,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  stage.startDate.isNotEmpty
                                      ? stage.startDate
                                      : '07-04-2025',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            startConnector: index == 0
                                ? null
                                : SolidLineConnector(
                                    color: Config.themeColor,
                                  ),
                            endConnector: index == stages!.data.length - 1
                                ? null
                                : SolidLineConnector(
                                    color: Config.themeColor,
                                  ),
                          ),
                          contents: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color: stage.stageStatus == "pending"
                                  ? Colors.orange.shade50
                                  : stage.stageStatus == "running"
                                      ? Colors.blue.shade100
                                      : stage.stageStatus == "completed"
                                          ? Colors.green.shade100
                                          : Colors.grey.shade100,
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // =========================
                                    // STAGE HEADER
                                    // =========================

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                stage.stageName,
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  color: Config.themeColor,
                                                ),
                                              ),
                                              if (stage.startDate.isNotEmpty)
                                                Text(
                                                  stage.startDate,
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                    color: Config.themeColor,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        Transform.scale(
                                          scale: .8,
                                          child: Switch(
                                            value: false,
                                            onChanged: (bool value) {
                                              setState(() {});
                                            },
                                            activeTrackColor:
                                                Colors.purple.withOpacity(0.2),
                                            inactiveThumbColor: Colors.grey,
                                            inactiveTrackColor:
                                                Colors.grey.withOpacity(0.2),
                                            thumbIcon: WidgetStateProperty
                                                .resolveWith<Icon?>(
                                              (states) {
                                                return states.contains(
                                                        WidgetState.selected)
                                                    ? const Icon(
                                                        Icons.lock_rounded,
                                                        size: 14,
                                                      )
                                                    : const Icon(
                                                        Icons.lock_open,
                                                        size: 14,
                                                      );
                                              },
                                            ),
                                            overlayColor: WidgetStateProperty
                                                .resolveWith<Color>(
                                              (states) {
                                                return states.contains(
                                                        WidgetState.pressed)
                                                    ? Colors.purple
                                                        .withOpacity(0.1)
                                                    : Colors.transparent;
                                              },
                                            ),
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 8),

                                    if (stage.startDate.isNotEmpty)
                                      Text(
                                        "Scheduled Date : ${stage.scheduledDate}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Config.themeColor,
                                        ),
                                      ),

                                    if (stage.endDate.isNotEmpty)
                                      Text(
                                        "End Date : ${stage.endDate}",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Config.themeColor,
                                        ),
                                      ),

                                    Text(
                                      "Status : ${stage.stageStatus}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Config.themeColor,
                                      ),
                                    ),

                                    // =========================
                                    // EXPAND BUTTON
                                    // =========================

                                    if (stage.workDetails.isNotEmpty)
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _isExpandedMap[index] =
                                                  !(_isExpandedMap[index] ??
                                                      false);
                                            });
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.black,
                                              size: 30,
                                            ),
                                          ),
                                        ),
                                      ),

                                    // =========================
                                    // WORK DETAILS
                                    // =========================

                                    if (_isExpandedMap[index] ?? false)
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          children: List.generate(
                                            stage.workDetails.length,
                                            (i) {
                                              final work = stage.workDetails[i];

                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 6,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: 10,
                                                          height: 10,
                                                          decoration:
                                                              BoxDecoration(
                                                            color:
                                                                work.isWorking ==
                                                                        "Yes"
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 4),
                                                        Text(
                                                          work.workDate,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey.shade600,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                        if (i !=
                                                            stage.workDetails
                                                                    .length -
                                                                1)
                                                          Container(
                                                            width: 2,
                                                            height: 50,
                                                            color: Colors
                                                                .blue.shade300,
                                                          ),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 14),
                                                    Expanded(
                                                      child: ListTile(
                                                        contentPadding:
                                                            EdgeInsets.zero,
                                                        title: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              work.isWorking,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color: work.isWorking ==
                                                                        "Yes"
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 4,
                                                            ),
                                                            Text(
                                                              work.laboursNo
                                                                          .isNotEmpty &&
                                                                      work.laboursNo !=
                                                                          "0"
                                                                  ? 'Labour No:${work.laboursNo}'
                                                                  : 'Status:${work.workStatus}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        subtitle: Text(
                                                          work.description,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .grey.shade600,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
              //     : const Center(child: CircularProgressIndicator()),
              // bottomNavigationBar: BottomNavigationBarScreen(
              //   token: token,
              // ),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.noNetwork,
                    width: 250,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No Network Found!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  InkWell(
                    onTap: getData,
                    child: Container(
                      width: 120,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          'Try Again',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
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

void _showStageDialog(BuildContext context, stage) {
  List<String> additionalNames = ["Ansar", "Sruthy", "Pradeesh", "Sarath"];
  List<String> additionalDates = [
    "2025-04-02",
    "2025-04-03",
    "2025-04-05",
    "2025-04-05"
  ];

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          stage.stageName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Start Date: 12-05-2025"),
              Text("End Date: 25-05-2025"),
              const SizedBox(height: 12),
              Text("Additional Information:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: additionalNames.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF876B6F),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8.0),
                      title: Text(
                        additionalNames[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        additionalDates[index],
                        style: TextStyle(
                          color: Colors.grey.shade200,
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Close"),
          ),
        ],
      );
    },
  );
}
