import 'package:flutter/material.dart';
import 'package:site720_client/settings/common.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/service/service.dart';

class PinEntryScreen extends StatefulWidget {
  final Function(bool success, String? message) onComplete;

  const PinEntryScreen({super.key, required this.onComplete});

  @override
  State<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  List<String> pinDigits = List.filled(4, '');
  int currentIndex = 0;
  bool isLoading = false;
  bool showError = false;
  String errorMessage = '';

  final Color primaryColor = const Color(0xFFC24B68);
  final Color backgroundColor = const Color(0xFFF5F7FA);
  final Color cardColor = Colors.white;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pinFocusNode.requestFocus();
    });
  }

  void _onDigitPressed(String digit) {
    if (currentIndex < 4) {
      setState(() {
        pinDigits[currentIndex] = digit;
        _pinController.text = pinDigits.join();
        currentIndex++;
        showError = false;
        errorMessage = '';
      });

      if (currentIndex == 4) {
        _validatePin();
      }
    }
  }

  void _onBackspacePressed() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        pinDigits[currentIndex] = '';
        _pinController.text = pinDigits.join();
        showError = false;
        errorMessage = '';
      });
    }
  }

 Future<void> _validatePin() async {
  String enteredPin = pinDigits.join();
  if (enteredPin.length != 4 || int.tryParse(enteredPin) == null) {
    if (!mounted) return;
    setState(() {
      showError = true;
      errorMessage = 'Please enter a valid 4-digit PIN';
    });
    return;
  }

  if (!mounted) return;
  setState(() {
    isLoading = true;
    showError = false;
    errorMessage = '';
  });

  try {
    Map<String, dynamic> result = await HttpService.verifyPin(enteredPin);

    if (!mounted) return;

    if (result['success'] == true) {
      await Common.setSharedPref('pin_verified', 'true');
      await Common.setSharedPref('user_pin', enteredPin);
      setState(() {
        isLoading = false;
      });
      widget.onComplete(true, result['message']);
      
    } else {
      setState(() {
        isLoading = false;
        showError = true;
        errorMessage = result['message'] ?? 'Invalid PIN';
        _clearPin();
      });
    }
  } catch (e) {
    if (!mounted) return;
    setState(() {
      isLoading = false;
      showError = true;
      errorMessage = 'Network error. Please try again.';
      _clearPin();
    });
  }
}

  // void _resendPin() async {
  //   try {
  //     // Call API to resend PIN
  //     bool success = await HttpService.resendPin();

  //     if (success) {
  //       Common.toastMessaage('New PIN sent to your registered email/mobile', Colors.green);
  //     } else {
  //       Common.toastMessaage('Failed to resend PIN. Try again later.', Colors.red);
  //     }
  //   } catch (e) {
  //     Common.toastMessaage('Error: ${e.toString()}', Colors.red);
  //   }
  // }

  void _clearPin() {
    setState(() {
      pinDigits = List.filled(4, '');
      currentIndex = 0;
      _pinController.clear();
      showError = false;
      errorMessage = '';
    });
    _pinFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 40, top: 20),
                      child: Image.asset(
                        Assets.logo,
                        height: 120,
                        width: 120,
                      ),
                    ),

                    Text(
                      'Enter Your PIN',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: primaryColor,
                      ),
                    ),

                   // const SizedBox(height: 8),

                    Text(
                      'Please enter the 4-digit PIN provided to you',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    Opacity(
                      opacity: 0,
                      child: TextField(
                        controller: _pinController,
                        focusNode: _pinFocusNode,
                        keyboardType: TextInputType.none,
                        maxLength: 4,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          counterText: '',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: index < currentIndex
                                    ? primaryColor
                                    : Colors.grey[300]!,
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                index < currentIndex ? '●' : '',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),

                    if (showError)
                      Container(
                        margin: const EdgeInsets.only(top: 16, bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline,
                                color: Colors.red, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                errorMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (isLoading)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Verifying PIN...',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),

                  //  const SizedBox(height: 40),
                    Container(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [1, 2, 3].map((number) {
                              return _buildNumberButton(number.toString());
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [4, 5, 6].map((number) {
                              return _buildNumberButton(number.toString());
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [7, 8, 9].map((number) {
                              return _buildNumberButton(number.toString());
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildActionButton(
                                icon: Icons.clear_outlined,
                                onPressed: _clearPin,
                                color: Colors.orange,
                              ),
                              _buildNumberButton('0'),
                              _buildActionButton(
                                icon: Icons.backspace_outlined,
                                onPressed: _onBackspacePressed,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                    if (currentIndex == 4 && !isLoading)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _validatePin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'VERIFY PIN',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     TextButton(
                    //       onPressed: _resendPin,
                    //       child: Text(
                    //         'Resend PIN',
                    //         style: TextStyle(
                    //           fontSize: 15,
                    //           color: primaryColor,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 20),
                    //     Text(
                    //       '|',
                    //       style: TextStyle(
                    //         color: Colors.grey[400],
                    //       ),
                    //     ),
                    //     const SizedBox(width: 20),
                    //     TextButton(
                    //       onPressed: () {
                    //         // Show support contact info
                    //         _showSupportInfo();
                    //       },
                    //       child: Text(
                    //         'Contact Support',
                    //         style: TextStyle(
                    //           fontSize: 15,
                    //           color: primaryColor,
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberButton(String number) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onDigitPressed(number),
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: cardColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    IconData? icon,
    VoidCallback? onPressed,
    required Color color,
    bool isLoading = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color:
                onPressed != null ? color.withOpacity(0.1) : Colors.grey[100],
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color,
                    ),
                  )
                : Icon(
                    icon,
                    size: 28,
                    color: onPressed != null ? color : Colors.grey[400],
                  ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    _pinFocusNode.dispose();
    super.dispose();
  }
}
