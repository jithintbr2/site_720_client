import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import '../model/quotationEnquiryModel.dart';
import '../service/service.dart';
import '../settings/assets.dart';
import '../settings/common.dart';
import 'package:image_picker/image_picker.dart';

import 'dashboard.dart';

class QuotationEnquiryPage extends StatefulWidget {
  String? token;
  QuotationEnquiryPage({this.token});

  @override
  _QuotationEnquiryPageState createState() => _QuotationEnquiryPageState();
}

class _QuotationEnquiryPageState extends State<QuotationEnquiryPage> {
  TextEditingController name = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController message = new TextEditingController();
  bool isVisible = true;
  late bool isLoading = false;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  bool? result = true;
  bool? result1 = true;
  String? _planImageFile;
  String? _dImageFile;
  final ImagePicker _planPicker = ImagePicker();
  final ImagePicker _dPicker = ImagePicker();

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
  }

  @override
  Widget build(BuildContext context) {
    return result == true
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              width: double.infinity,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 10),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  height: 325,
                                  width: 325,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(Assets.quotation),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
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
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: TextFormField(
                                            maxLines: 1,
                                            controller: name,
                                            keyboardType: TextInputType.text,
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
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: TextFormField(
                                            maxLines: 1,
                                            controller: phone,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              hintText: "Phone Number",
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10, bottom: 10),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: _selectPlanFile,
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(10),
                                        dashPattern: const [1, 2],
                                        strokeCap: StrokeCap.round,
                                        color: Colors.black,
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.41,
                                            height: 130,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: _planImageFile == null
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.add_a_photo,
                                                          color: Colors.grey,
                                                          size: 35),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        'Add Plan Image',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  )
                                                : Image.file(
                                                    File(_planImageFile!))),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 14,
                                    ),
                                    GestureDetector(
                                      onTap: _selectDFile,
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(10),
                                        dashPattern: const [1, 2],
                                        strokeCap: StrokeCap.round,
                                        color: Colors.black,
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.41,
                                            height: 130,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: _dImageFile == null
                                                ? Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons.add_a_photo,
                                                          color: Colors.grey,
                                                          size: 35),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        'Add 3D Image',
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  )
                                                : Image.file(
                                                    File(_dImageFile!))),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  width: double.infinity,
                                  height: 80,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 5),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          child: TextFormField(
                                            maxLines: 5,
                                            controller: message,
                                            keyboardType: TextInputType.text,
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
                  } else if (_planImageFile == null) {
                    Common.toastMessaage('Select Plan Image', Colors.red);
                  }
                  // else if (_dImageFile==null) {
                  //   Common.toastMessaage(
                  //       'Select 3D Image', Colors.red);
                  // }
                  else if (message.text.isEmpty) {
                    Common.toastMessaage('Message cannot empty', Colors.red);
                  } else {
                    Common.showProgressDialog(context, "Loading..");
                    QuotationEnquiryModel object =
                        await HttpService.addQuotationForm(
                            name.text,
                            phone.text,
                            _planImageFile,
                            _dImageFile,
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

  void _pickPlanImage() async {
    try {
      Navigator.pop(context);

      final pickedFile = await _planPicker.pickImage(
          source: ImageSource.gallery, imageQuality: 100);
      setState(() {
        _planImageFile = pickedFile!.path;
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  void _pickDImage() async {
    try {
      Navigator.pop(context);

      final pickedFile = await _dPicker.pickImage(
          source: ImageSource.gallery, imageQuality: 100);
      setState(() {
        _dImageFile = pickedFile!.path;
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  void _capturePlanImage() async {
    try {
      Navigator.pop(context);
      final pickedFile =
          await _planPicker.pickImage(source: ImageSource.camera);
      //await _picker.getImage(source: ImageSource.camera, imageQuality: 100);
      setState(() {
        _planImageFile = pickedFile!.path;
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  void _captureDImage() async {
    try {
      Navigator.pop(context);
      final pickedFile = await _dPicker.pickImage(source: ImageSource.camera);
      //await _picker.getImage(source: ImageSource.camera, imageQuality: 100);
      setState(() {
        _dImageFile = pickedFile!.path;
      });
      // ignore: empty_catches
    } catch (e) {}
  }

  _selectPlanFile() {
    showModalBottomSheet(
      context: context,
      builder: ((builder) {
        return Container(
          height: 100.0,
          width: MediaQuery.of(context).size.width * 1,
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            children: <Widget>[
              const Text(
                "Choose Plan photo",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: _capturePlanImage,
                      child: const Column(
                        children: [Icon(Icons.camera), Text('Camera')],
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    InkWell(
                      onTap: _pickPlanImage,
                      child: const Column(
                        children: [
                          Icon(Icons.image),
                          Text('Gallery'),
                        ],
                      ),
                    ),
                  ])
            ],
          ),
        );
      }),
    );
  }

  _selectDFile() {
    showModalBottomSheet(
      context: context,
      builder: ((builder) {
        return Container(
          height: 100.0,
          width: MediaQuery.of(context).size.width * 1,
          margin: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            children: <Widget>[
              const Text(
                "Choose 3D photo",
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    InkWell(
                      onTap: _captureDImage,
                      child: const Column(
                        children: [Icon(Icons.camera), Text('Camera')],
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    InkWell(
                      onTap: _pickDImage,
                      child: const Column(
                        children: [
                          Icon(Icons.image),
                          Text('Gallery'),
                        ],
                      ),
                    ),
                  ])
            ],
          ),
        );
      }),
    );
  }
}
