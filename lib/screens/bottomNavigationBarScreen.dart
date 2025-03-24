// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:site720_client/screens/complaintList.dart';
import '../settings/common.dart';
import 'contactusPage.dart';

class BottomNavigationBarScreen extends StatelessWidget {
  String? token;
  BottomNavigationBarScreen({this.token, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, bottom: 20, top: 10, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ContactUsPage(token: token)),
              );
            },
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.black, Colors.black]),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.42,
                height: 40,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Contact Us',
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
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              if (token != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ComplaintListPage(token)),
                );
              } else {
                Common.toastMessaage("Login to watch complaints", Colors.red);
              }
            },
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.black, Colors.black]),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.42,
                height: 40,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Complaint',
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
        ],
      ),
    );
  }
}
