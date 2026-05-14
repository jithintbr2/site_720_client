import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../model/client_details/payment_list.dart';
import '../../service/service.dart';
import '../../settings/assets.dart';
import '../../settings/common.dart';
import '../bottomNavigationBarScreen.dart';

class PaymentListScreen extends StatefulWidget {
  const PaymentListScreen({super.key});

  @override
  State<PaymentListScreen> createState() => _PaymentListScreenState();
}

class _PaymentListScreenState extends State<PaymentListScreen> {
  PaymentListModel? paymentList;
  bool hasInternet = true;
  bool isLoading = true;
  String token = "";

  // Premium color palette
  static const Color primaryColor = Color(0xFFB85C7A);
  static const Color secondaryColor = Color(0xFFD8A7B5);
  static const Color accentColor = Color(0xFFF7E8EE);
  static const Color darkText = Color(0xFF2D2D2D);
  static const Color lightText = Color(0xFF7A7A7A);
  static const Color successColor = Color(0xFF16A34A);
  static const Color cardShadow = Color(0x14000000);

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });

    token = await Common.getSharedPref("token");

    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    hasInternet = connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi);

    if (!hasInternet) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    paymentList = await HttpService.getClientPaymentDetails(token);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> printReceipt(int index) async {
    final payment = paymentList!.data[index];

    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'PAYMENT RECEIPT',
                style: pw.TextStyle(
                  fontSize: 26,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 24),
              pw.Table(
                border: pw.TableBorder.all(width: 1),
                children: [
                  _buildTableRow(
                    'Transaction Date',
                    payment.transactionDate,
                  ),
                  _buildTableRow(
                    'Phase',
                    payment.phaseName,
                  ),
                  _buildTableRow(
                    'Collected By',
                    payment.accountHead,
                  ),
                  _buildTableRow(
                    'Description',
                    payment.description,
                  ),
                  _buildTableRow(
                    'Amount',
                    payment.amount,
                  ),
                  _buildTableRow(
                    'Payment Method',
                    payment.paymentMethod,
                  ),
                ],
              ),
              pw.SizedBox(height: 30),
              pw.Text(
                'Thank you for your payment!',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontStyle: pw.FontStyle.italic,
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => doc.save(),
    );
  }

  pw.TableRow _buildTableRow(String title, dynamic value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            title,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(value?.toString() ?? ''),
        ),
      ],
    );
  }

  Color _getPaymentMethodColor(String method) {
    switch (method.toUpperCase()) {
      case 'CASH':
        return const Color(0xFF16A34A);
      case 'BANK':
      case 'CHEQUE':
        return const Color(0xFF2563EB);
      case 'UPI':
        return const Color(0xFF7C3AED);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getPaymentMethodIcon(String method) {
    switch (method.toUpperCase()) {
      case 'CASH':
        return Icons.payments_rounded;
      case 'BANK':
      case 'CHEQUE':
        return Icons.account_balance_rounded;
      case 'UPI':
        return Icons.qr_code_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  String _formatAmount(dynamic amount) {
    return '₹ ${amount.toString()}';
  }

  Future<void> _onRefresh() async {
    await getData();
  }

  @override
 @override
Widget build(BuildContext context) {
  if (!hasInternet && !isLoading) {
    return _buildNoNetworkScreen();
  }

  return Scaffold(
    backgroundColor: const Color(0xFFF8FAFC),

    // AppBar remains fixed at the top
    // (removed: extendBodyBehindAppBar: true)
    appBar: _buildAppBar(),

    body: isLoading
        ? _buildLoadingScreen()
        : paymentList == null || paymentList!.data.isEmpty
            ? _buildEmptyScreen()
            : RefreshIndicator(
                color: primaryColor,
                onRefresh: _onRefresh,
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  slivers: [
                    // SliverToBoxAdapter(
                    //   child: _buildHeaderSection(),
                    // ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return _buildPaymentCard(index);
                          },
                          childCount: paymentList!.data.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

    bottomNavigationBar: BottomNavigationBarScreen(token: token),
  );
}

PreferredSizeWidget _buildAppBar() {
  return AppBar(
    elevation: 0,
    backgroundColor: const Color.fromARGB(255, 224, 173, 190),
    surfaceTintColor: const Color.fromARGB(255, 224, 173, 190),
    shadowColor: Colors.black.withOpacity(0.15),
    iconTheme: const IconThemeData(color: Colors.white),
    title: const Text(
      'Payment Details',
      style: TextStyle(
        color: Colors.white,
        fontSize: 22,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
    ),
    centerTitle: false,
  );
}

Widget _buildHeaderSection() {
  final totalPayments = paymentList!.data.length;
  double totalAmount = 0;
  for (var item in paymentList!.data) {
    totalAmount += double.tryParse(item.amount.toString()) ?? 0;
  }
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),

    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          primaryColor,
          secondaryColor,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(34),
        bottomRight: Radius.circular(34),
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0x33000000),
          blurRadius: 24,
          offset: Offset(0, 12),
        ),
      ],
    ),
    // child: Row(
    //   children: [
    //     Expanded(
    //       child: _buildStatCard(
    //         icon: Icons.receipt_long_rounded,
    //         title: 'Payments',
    //         value: totalPayments.toString(),
    //       ),
    //     ),
    //     const SizedBox(width: 12),
    //     Expanded(
    //       child: _buildStatCard(
    //         icon: Icons.account_balance_wallet_rounded,
    //         title: 'Total',
    //         value: '₹ ${totalAmount.toStringAsFixed(0)}',
    //       ),
    //     ),
    //   ],
    // ),
  );
}

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 28,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(int index) {
    final payment = paymentList!.data[index];
    final methodColor = _getPaymentMethodColor(payment.paymentMethod);

    return Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: cardShadow,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    color: methodColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    _getPaymentMethodIcon(payment.paymentMethod),
                    color: methodColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment.phaseName.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: darkText,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        payment.transactionDate.toString(),
                        style: const TextStyle(
                          color: lightText,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: methodColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    payment.paymentMethod.toUpperCase(),
                    style: TextStyle(
                      color: methodColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 18),

            // _buildInfoRow(
            //   Icons.person_outline_rounded,
            //   'Collected By',
            //   payment.accountHead.toString(),
            // ),
            const SizedBox(height: 10),
            _buildInfoRow(
              Icons.notes_rounded,
              'Description',
              payment.description.toString(),
            ),
            //  const SizedBox(height: 10),

            // _buildInfoRow(
            //   Icons.attach_money_rounded,
            //   'Paid Amount',
            //   payment.paidAmount.toString(),
            // ),
            //  const SizedBox(height: 10),

            // _buildInfoRow(
            //   Icons.attach_money_rounded,
            //   'Scheduled Amount',
            //   payment.scheduledAmount.toString(),
            // ),

            const SizedBox(height: 18),
            const Divider(height: 1),
            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Amount',
                        style: TextStyle(
                          color: lightText,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatAmount(payment.amount),
                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Material(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(16),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => printReceipt(index),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.print_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'Print',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 18,
          color: primaryColor,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(
                    color: darkText,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: const TextStyle(
                    color: lightText,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(
      child: CircularProgressIndicator(
        color: primaryColor,
      ),
    );
  }

  Widget _buildEmptyScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.receipt_long_outlined,
              size: 90,
              color: Color(0xFFCBD5E1),
            ),
            SizedBox(height: 16),
            Text(
              'No Payments Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your payment records will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: lightText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoNetworkScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.noNetwork,
                width: 260,
                height: 260,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                'No Network Connection',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please check your internet connection and try again.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: lightText,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: getData,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}