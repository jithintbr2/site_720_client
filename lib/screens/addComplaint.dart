import 'package:flutter/material.dart';
import 'package:site720_client/model/addComplaintModel.dart';
import 'package:site720_client/screens/complaintList.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/common.dart';

class AddComplaint extends StatefulWidget {
  String token;
  AddComplaint(this.token);

  @override
  _AddComplaintState createState() => _AddComplaintState();
}

class _AddComplaintState extends State<AddComplaint> {
  TextEditingController complaint = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottomOpacity: 0.0,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Add Complaint',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
              width: double.infinity,
              height: 80,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: TextFormField(
                        maxLines: 5,
                        controller: complaint,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Enter Your Complaint",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, bottom: 10, top: 10, right: 20),
            child: InkWell(
              onTap: () async {
                if (complaint.text.isEmpty) {
                  Common.toastMessaage('Enter the complaint', Colors.red);
                } else {
                  Common.showProgressDialog(context, "Loading..");
                  AddComplaintModel object = await HttpService.addComplaint(
                      widget.token, complaint.text);
                  if (object.status == true) {
                    Common.toastMessaage(object.message, Colors.green);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) =>
                                ComplaintListPage(widget.token)),
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
          )
        ],
      ),
    );
  }
}
