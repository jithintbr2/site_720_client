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
  ContactUsPage({super.key, this.token});

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController place = TextEditingController();
  TextEditingController message = TextEditingController();
  bool isVisible = true;
  late bool isLoading = false;
  String service = 'Choose Service';
  String serviceId = '';
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  ServiceListModel? serviceList;
  bool? result = true;
  bool? result1 = true;

  @override
  void initState() {
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
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return result == true
        ? Scaffold(
            backgroundColor: Colors.white,
            body: serviceList != null
                ? Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white,
                          const Color.fromARGB(255, 105, 38, 56)
                              .withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        // Header with gradient
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                const Color.fromARGB(255, 105, 38, 56),
                                const Color.fromARGB(255, 85, 28, 46),
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 105, 38, 56)
                                    .withOpacity(0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 50),
                              // Back button and title
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const Icon(
                                          Icons.arrow_back_ios_new,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    const Text(
                                      'Contact Us',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // const SizedBox(height: 20),
                              // // Illustration
                              // Hero(
                              //   tag: 'contact_illustration',
                              //   child: Container(
                              //     height: 180,
                              //     width: 180,
                              //     decoration: BoxDecoration(
                              //       image: DecorationImage(
                              //         image: AssetImage(Assets.contactus),
                              //         fit: BoxFit.contain,
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                        // Form Fields
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                // Name Field
                                _buildModernTextField(
                                  controller: name,
                                  hintText: 'Full Name',
                                  icon: Icons.person_outline,
                                  keyboardType: TextInputType.text,
                                ),
                                const SizedBox(height: 15),

                                // Phone Field
                                _buildModernTextField(
                                  controller: phone,
                                  hintText: 'Phone Number',
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                ),
                                const SizedBox(height: 15),

                                // Place Field
                                _buildModernTextField(
                                  controller: place,
                                  hintText: 'Your Location',
                                  icon: Icons.location_on_outlined,
                                  keyboardType: TextInputType.text,
                                ),
                                const SizedBox(height: 15),

                                // Service Dropdown Field
                                _buildServiceDropdown(),
                                const SizedBox(height: 15),

                                // Message Field
                                _buildMessageField(),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromARGB(255, 105, 38, 56),
                      ),
                    ),
                  ),
            bottomNavigationBar: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
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
                            MaterialPageRoute(
                                builder: (context) => Dashboard()),
                            (Route<dynamic> route) => false);
                      } else {
                        Common.toastMessaage(object.message, Colors.red);
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 55,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromARGB(255, 105, 38, 56),
                          Color.fromARGB(255, 85, 28, 46),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 105, 38, 56)
                              .withOpacity(0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : _buildNoNetworkScreen();
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Icon(icon, color: const Color.fromARGB(255, 105, 38, 56)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildServiceDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 50,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Select Service',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 105, 38, 56),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: serviceList!.data!.length,
                          itemBuilder: (context, ind) {
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  service = serviceList!.data![ind].serviceTitle
                                      .toString();
                                  serviceId = serviceList!.data![ind].serviceId
                                      .toString();
                                  Navigator.pop(context);
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.build_circle_outlined,
                                      color: const Color.fromARGB(
                                          255, 105, 38, 56),
                                      size: 20,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        serviceList!.data![ind].serviceTitle
                                            .toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    if (service ==
                                        serviceList!.data![ind].serviceTitle)
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 20,
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              Icon(
                Icons.build_outlined,
                color: const Color.fromARGB(255, 105, 38, 56),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  service,
                  style: TextStyle(
                    fontSize: 16,
                    color: service == 'Choose Service'
                        ? Colors.grey.shade500
                        : Colors.black,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: const Color.fromARGB(255, 105, 38, 56),
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: message,
        maxLines: 5,
        keyboardType: TextInputType.multiline,
        style: const TextStyle(fontSize: 16),
        decoration: InputDecoration(
          hintText: 'Your Message',
          hintStyle: TextStyle(color: Colors.grey.shade400),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Icon(
              Icons.message_outlined,
              color: const Color.fromARGB(255, 105, 38, 56),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }

  Widget _buildNoNetworkScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.noNetwork),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Network Connection',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 105, 38, 56),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Please check your internet connection',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () {
                getData();
              },
              child: Container(
                width: 150,
                height: 45,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color.fromARGB(255, 105, 38, 56),
                      Color.fromARGB(255, 85, 28, 46)
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 105, 38, 56)
                          .withOpacity(0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Try Again',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
