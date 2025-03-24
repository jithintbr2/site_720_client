// ignore_for_file: must_be_immutable

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/model/complaintListModel.dart';
import 'package:site720_client/screens/addComplaint.dart';
import 'package:site720_client/screens/dashboard.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';

class ComplaintListPage extends StatefulWidget {
  String? token;
  ComplaintListPage(this.token);

  @override
  _ComplaintListPageState createState() => _ComplaintListPageState();
}

class _ComplaintListPageState extends State<ComplaintListPage> {
  ComplaintListModel? complaintList;
  bool? result = true;
  bool? result1 = true;

  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
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
    complaintList = await HttpService.complaintList(widget.token);
    if (complaintList != null) {
      setState(() {
        ;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return result == true
        ? WillPopScope(
            onWillPop: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Dashboard(token: widget.token!)),
              );
              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                bottomOpacity: 0.0,
                elevation: 0.0,
                iconTheme: IconThemeData(
                  color: Colors.black, //change your color here
                ),
                backgroundColor: Colors.white,
                title: Text('Complaint List',
                    style: TextStyle(color: Colors.black)),
              ),
              body: complaintList != null
                  ? SingleChildScrollView(
                      child: complaintList!.data!.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: complaintList!.data!.length,
                              itemBuilder: (context, i) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            complaintList!.data![i].complaint
                                                        .toString() !=
                                                    ''
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors
                                                            .teal.shade100,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    width: 250,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10,
                                                              top: 10,
                                                              bottom: 10),
                                                      child: Text(
                                                        complaintList!
                                                            .data![i].complaint
                                                            .toString(),
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            complaintList!.data![i].reply
                                                        .toString() !=
                                                    ''
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10, top: 10),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors
                                                              .pink.shade100,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      width: 250,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                top: 10,
                                                                bottom: 10),
                                                        child: Text(
                                                          complaintList!
                                                              .data![i].reply
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : Container(
                              width: MediaQuery.of(context).size.width * 1,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 100,
                                  ),
                                  Container(
                                    width: 150,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(Assets.noComplaints),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'No Complaints Found !',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            ))
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddComplaint(widget.token!)),
                  );
                },
                label: const Text(
                  'Add Complaint',
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(
                  Icons.add_box_outlined,
                  color: Colors.white,
                ),
                backgroundColor: Colors.black,
              ),
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
                      getData();
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
}
