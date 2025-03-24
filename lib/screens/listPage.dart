import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/model/projectListModel.dart';
import 'package:site720_client/screens/projectDetailsPage.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:shimmer/shimmer.dart';

import '../model/bhkFilterListModel.dart';
import 'bottomNavigationBarScreen.dart';

class ListPage extends StatefulWidget {
  ListPage();

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool? result = true;
  bool? result1 = true;
  ProjectListModel? projectList;
  int currentPage = 1; // Start with the first page.
  int itemsPerPage = 10; // Number of items to load per page.
  List<dynamic> items = [];
  bool isLoading = true;
  bool hasMoreData = false;
  ScrollController _scrollController = ScrollController();
  RangeValues _values = RangeValues(1000000, 5000000);
  RangeValues _valuesSqr = RangeValues(500, 5000);
  String bhk = 'All';
  BhkFilterListModel? bhkFilterList;
  bool noRes = false;

  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    setState(() {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          isLoading = true;
          getData();
        }
      });
    });
  }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  getData() async {
    if (!hasMoreData) {
      setState(() {
        hasMoreData = true;
      });

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
      projectList = await HttpService.projectList(
          currentPage,
          itemsPerPage,
          bhk,
          _values.start.toString(),
          _values.end.toString(),
          _valuesSqr.start.toString(),
          _valuesSqr.end.toString());
      if (projectList != null) {
        setState(() {});
      }
      setState(() {
        items.addAll(projectList!.data!.project as Iterable);
        currentPage++;
        hasMoreData = false;
        if (items.length == 0) {
          noRes = true;
        } else {
          noRes = false;
        }
      });
      bhkFilterList = await HttpService.bhkFilterList();
      setState(() {});
    } else {
      // Handle error
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return result == true
        ? RefreshIndicator(
            onRefresh: () async {
              // getData();
              return null;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              key: _scaffoldKey,
              //drawer: DrawerScreen(token: widget.token, name:name),
              appBar: AppBar(
                backgroundColor: Colors.white,
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(Assets.h4logo),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        // SizedBox(width: 5,),
                        // Text('HOMES4',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                      ],
                    ),
                  ),
                ],
              ),
              body: projectList != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'BHK Category',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                      width: double.infinity,
                                      height: 45,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 2),
                                      decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10),
                                              child: TextFormField(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            scrollable: true,
                                                            title: Text(
                                                                'Category'),
                                                            content: ListView
                                                                .builder(
                                                              shrinkWrap: true,
                                                              itemCount:
                                                                  bhkFilterList!
                                                                      .data!
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      ind) {
                                                                return InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      bhk = bhkFilterList!
                                                                              .data![
                                                                          ind];

                                                                      // maxCount = usedProduct!.data![ind].qty.toString();
                                                                      Navigator.pop(
                                                                          context,
                                                                          true);
                                                                    });
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            15),
                                                                    child: Container(
                                                                        child: Text(
                                                                      bhkFilterList!
                                                                              .data![
                                                                          ind],
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15),
                                                                    )),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  maxLines: 1,
                                                  readOnly: true,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                    suffixIcon: Icon(
                                                      Icons
                                                          .arrow_drop_down_circle_outlined,
                                                      color: Colors.black,
                                                    ),
                                                    hintText: bhk,
                                                    border: InputBorder.none,
                                                  )),
                                            ),
                                          ),
                                        ],
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Square Feet',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          _valuesSqr.start.toInt().toString() +
                                              ' - ' +
                                              _valuesSqr.end
                                                  .toInt()
                                                  .toString()
                                                  .toString() +
                                              ' Sqr.Ft',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  RangeSlider(
                                    values: _valuesSqr,
                                    min: 0,
                                    max: 6000,
                                    divisions: 600,
                                    onChanged: (RangeValues newValues) {
                                      setState(() {
                                        _valuesSqr = newValues;
                                      });
                                    },
                                    // labels: RangeLabels(
                                    //     _values.start.toStringAsFixed(1),
                                    //     _values.end.toStringAsFixed(1)
                                    // ),
                                    // divisions: 10, // Optional, adds tick marks and labels
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Prize',
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          convertToLakh(_values.start.toInt())
                                                  .toString() +
                                              ' - ' +
                                              convertToLakh(_values.end.toInt())
                                                  .toString()
                                                  .toString(),
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  RangeSlider(
                                    values: _values,
                                    min: 0,
                                    max: 10000000,
                                    divisions: 200,
                                    onChanged: (RangeValues newValues) {
                                      setState(() {
                                        _values = newValues;
                                      });
                                    },
                                    // labels: RangeLabels(
                                    //     _values.start.toStringAsFixed(1),
                                    //     _values.end.toStringAsFixed(1)
                                    // ),
                                    // divisions: 10, // Optional, adds tick marks and labels
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        currentPage =
                                            1; // Start with the first page.
                                        itemsPerPage = 10;
                                        items = [];
                                        getData();
                                      },
                                      child: Ink(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [
                                            Colors.black,
                                            Colors.black
                                          ]),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Container(
                                          width: 120,
                                          height: 30,
                                          alignment: Alignment.center,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Filter',
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Total Result  :  ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  projectList!.data!.count.toString(),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            noRes == false
                                ? ListView.builder(
                                    itemCount:
                                        items.length + (hasMoreData ? 1 : 0),
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index == items.length) {
                                        // Display the data.

                                        return _buildLoaderListItem();
                                      }
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: Stack(children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProjectDetailsPage(
                                                            items[index]
                                                                .id
                                                                .toString())),
                                              );
                                            },
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    1,
                                                height: 220,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: CachedNetworkImage(
                                                      height: MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          .3,
                                                      imageUrl: items[index]
                                                          .projectImage
                                                          .toString(),
                                                      fit: BoxFit.cover,
                                                      placeholder: (_, __) => Center(
                                                          child:
                                                              CircularProgressIndicator()),
                                                      errorWidget:
                                                          (_, __, ___) => Center(
                                                              child: Icon(
                                                                  Icons.error,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor))),
                                                )),
                                          ),
                                          Positioned(
                                            left: 15,
                                            bottom: 15,
                                            right: 15,
                                            child: Container(
                                              width: 300,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10, right: 10),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      items[index]
                                                          .name
                                                          .toString(),
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF3f3f3f),
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      height: 3,
                                                    ),
                                                    Text(
                                                      items[index]
                                                          .remarks
                                                          .toString(),
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFF717171),
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        ]),
                                      );
                                    },
                                    // controller: _scrollController,
                                  )
                                : SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 1,
                                    height: MediaQuery.of(context).size.height *
                                        0.4,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: 180,
                                          height: 180,
                                          child: Image.asset(
                                            Assets.noResult,
                                          ),
                                        ),
                                        const Text(
                                          'Result Not Found',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text(
                                          'Whoops... this information is \n not available for a moment',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
              bottomNavigationBar: BottomNavigationBarScreen(),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            body: Container(
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
                      //getData();
                    },
                    child: Container(
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

  Widget _buildLoaderListItem() {
    return Shimmer.fromColors(
        enabled: true,
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 1,
                      height: 220,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 12.0,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  String convertToLakh(int number) {
    if (number >= 100000) {
      double number1 = number / 100000;
      String roundedNumberAsString = number1.toStringAsFixed(1);
      return '$roundedNumberAsString Lakh';
    } else {
      return number.toString();
    }
  }
}
