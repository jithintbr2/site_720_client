import 'package:flutter/material.dart';
import 'package:site720_client/screens/complaintList.dart';
import '../settings/common.dart';
import 'contactusPage.dart';

class BottomNavigationBarScreen extends StatelessWidget {
  String? token;
  BottomNavigationBarScreen({this.token, super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 25, bottom: 20, top: 10, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildButton(
              context: context,
              text: 'Contact Us',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactUsPage(token: token),
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
            _buildButton(
              context: context,
              text: 'Complaint',
              onTap: () {
                if (token != null && token != "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ComplaintListPage(token),
                    ),
                  );
                } else {
                  Common.toastMessaage("Login to watch complaints", Colors.red);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color.fromARGB(255, 105, 38, 56),
                  const Color.fromARGB(255, 85, 28, 46),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color:
                      const Color.fromARGB(255, 105, 38, 56).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    text == 'Contact Us'
                        ? Icons.contact_mail
                        : Icons.assignment,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavigationBarScreenV2 extends StatelessWidget {
  String? token;
  BottomNavigationBarScreenV2({this.token, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            _buildGradientButton(
              context: context,
              text: 'Contact Us',
              icon: Icons.contact_mail_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactUsPage(token: token),
                  ),
                );
              },
            ),
            const SizedBox(width: 15),
            _buildGradientButton(
              context: context,
              text: 'Complaint',
              icon: Icons.assignment_outlined,
              onTap: () {
                if (token != null && token != "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ComplaintListPage(token),
                    ),
                  );
                } else {
                  Common.toastMessaage("Login to watch complaints", Colors.red);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                const Color.fromARGB(255, 105, 38, 56),
                const Color.fromARGB(255, 130, 48, 70),
                const Color.fromARGB(255, 105, 38, 56),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 105, 38, 56).withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BottomNavigationBarScreenHover extends StatefulWidget {
  String? token;
  BottomNavigationBarScreenHover({this.token, super.key});

  @override
  State<BottomNavigationBarScreenHover> createState() =>
      _BottomNavigationBarScreenHoverState();
}

class _BottomNavigationBarScreenHoverState
    extends State<BottomNavigationBarScreenHover> {
  bool _isHoveringContact = false;
  bool _isHoveringComplaint = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding:
            const EdgeInsets.only(left: 25, bottom: 20, top: 10, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildHoverButton(
              text: 'Contact Us',
              icon: Icons.contact_mail,
              isHovering: _isHoveringContact,
              onHover: (value) {
                setState(() {
                  _isHoveringContact = value;
                });
              },
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactUsPage(token: widget.token),
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
            _buildHoverButton(
              text: 'Complaint',
              icon: Icons.assignment,
              isHovering: _isHoveringComplaint,
              onHover: (value) {
                setState(() {
                  _isHoveringComplaint = value;
                });
              },
              onTap: () {
                if (widget.token != null && widget.token != "") {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ComplaintListPage(widget.token),
                    ),
                  );
                } else {
                  Common.toastMessaage("Login to watch complaints", Colors.red);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHoverButton({
    required String text,
    required IconData icon,
    required bool isHovering,
    required Function(bool) onHover,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: MouseRegion(
        onEnter: (_) => onHover(true),
        onExit: (_) => onHover(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: isHovering ? 54 : 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: isHovering
                  ? [
                      const Color.fromARGB(255, 125, 48, 66),
                      const Color.fromARGB(255, 105, 38, 56),
                    ]
                  : [
                      const Color.fromARGB(255, 105, 38, 56),
                      const Color.fromARGB(255, 85, 28, 46),
                    ],
            ),
            borderRadius: BorderRadius.circular(isHovering ? 15 : 12),
            boxShadow: isHovering
                ? [
                    BoxShadow(
                      color: const Color.fromARGB(255, 105, 38, 56)
                          .withOpacity(0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: const Color.fromARGB(255, 105, 38, 56)
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(isHovering ? 15 : 12),
            child: Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    color: Colors.white,
                    size: isHovering ? 22 : 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    text,
                    style: TextStyle(
                      fontSize: isHovering ? 17 : 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
