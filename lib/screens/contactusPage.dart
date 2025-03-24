import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/model/contactUsModel.dart';
import 'package:site720_client/model/serviceListModel.dart';
import 'package:site720_client/screens/dashboard.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';

class ContactUsPage extends StatefulWidget {
  String? token;
  ContactUsPage({this.token});

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  TextEditingController name = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController place = new TextEditingController();
  TextEditingController message = new TextEditingController();
  bool isVisible = true;
  late bool isLoading = false;
  String service = 'Choose Service';
  String serviceId = '';
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  ServiceListModel? serviceList;
  bool? result = true;
  bool? result1 = true;

  // handleAsync() async {
  //   //await firebase.initialize();
  //   //print('before');
  //   firebaseToken = await FirebaseMessaging.instance.getToken();
  //
  //   print("Firebase token : $firebaseToken");
  // }

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
    serviceList = await HttpService.serviceList();
    if (serviceList != null) {
      setState(() {
        ;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return result == true
        ? Scaffold(
            backgroundColor: Colors.white,
            body: serviceList != null
                ? Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 30),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Container(
                                        height: 300,
                                        width: 300,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(Assets.contactus),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                        width: double.infinity,
                                        height: 45,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 2),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                const BorderRadius.all(
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
                                                  maxLines: 1,
                                                  controller: name,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                    hintText: "Name",
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Container(
                                        width: double.infinity,
                                        height: 45,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 2),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                const BorderRadius.all(
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
                                                  maxLines: 1,
                                                  controller: phone,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  decoration: InputDecoration(
                                                    hintText: "Phone Number",
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Container(
                                        width: double.infinity,
                                        height: 45,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 2),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                const BorderRadius.all(
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
                                                  maxLines: 1,
                                                  controller: place,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                    hintText: "Place",
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Container(
                                        width: double.infinity,
                                        height: 45,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 2),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                const BorderRadius.all(
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
                                                                  'Services'),
                                                              content: ListView
                                                                  .builder(
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount:
                                                                    serviceList!
                                                                        .data!
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        ind) {
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        service = serviceList!
                                                                            .data![ind]
                                                                            .serviceTitle
                                                                            .toString();
                                                                        serviceId = serviceList!
                                                                            .data![ind]
                                                                            .serviceId
                                                                            .toString();
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
                                                                        serviceList!
                                                                            .data![ind]
                                                                            .serviceTitle
                                                                            .toString(),
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
                                                      hintText: service,
                                                      border: InputBorder.none,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        )),
                                    Container(
                                        width: double.infinity,
                                        height: 80,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 5),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 2),
                                        decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius:
                                                const BorderRadius.all(
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
                                                  maxLines: 5,
                                                  controller: message,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                    hintText: "Message",
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              )),
                        )
                      ],
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(
                  left: 20, bottom: 10, top: 10, right: 20),
              child: InkWell(
                onTap: () async {
                  if (name.text.isEmpty) {
                    Common.toastMessaage('Enter Name', Colors.red);
                  } else if (phone.text.isEmpty) {
                    Common.toastMessaage('Enter Phone Number', Colors.red);
                  } else if (place.text.isEmpty) {
                    Common.toastMessaage('Enter Place', Colors.red);
                  } else if (serviceId == '') {
                    Common.toastMessaage('Choose Service', Colors.red);
                  } else {
                    Common.showProgressDialog(context, "Loading..");
                    ContactUsModel object = await HttpService.addContactForm(
                        name.text,
                        phone.text,
                        place.text,
                        serviceId,
                        message.text);
                    if (object.status == true) {
                      Common.toastMessaage(object.message, Colors.green);
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => Dashboard()),
                          (Route<dynamic> route) => false);
                    } else {
                      Common.toastMessaage(object.message, Colors.red);
                      Navigator.pop(context);
                    }
                  }
                },
                child: Ink(
                  decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [Colors.black, Colors.black]),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Container(
                    width: 150,
                    height: 40,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
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
