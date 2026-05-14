import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:site720_client/model/client_details/schedule_payment_model.dart';
import 'package:site720_client/screens/bottomNavigationBarScreen.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:site720_client/settings/common.dart';

class SchedulePayment extends StatefulWidget {
  const SchedulePayment({super.key});

  @override
  State<SchedulePayment> createState() => _SchedulePaymentState();
}

class _SchedulePaymentState extends State<SchedulePayment> {
  SchedulePaymentModel? paymentList;
  bool hasInternet = true;
  bool isLoading = true;
  String token = "";

  // Premium Colors
  static const Color primaryColor = Color(0xFFB85C7A);
  static const Color secondaryColor = Color(0xFFD8A7B5);
  static const Color darkText = Color(0xFF2D2D2D);
  static const Color lightText = Color(0xFF7A7A7A);
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
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      return;
    }

    paymentList = await HttpService.getClientScheduledPayment(token);

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await getData();
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return const Color.fromARGB(255, 199, 55, 30);
      case 'close':
        return const Color(0xFF16A34A);
      case 'partially paid':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Color _getBalanceColor(dynamic balance) {
    final value = double.tryParse(balance.toString()) ?? 0;
    return value > 0 ? const Color(0xFFDC2626) : const Color(0xFF16A34A);
  }

  // String _formatCurrency(dynamic value) {
  //   return '₹ ${value.toString()}';
  // }
  String _formatCurrency(dynamic value) {
  final number = double.tryParse(value.toString()) ?? 0;
  final formatter = NumberFormat('#,##,##0.##', 'en_IN'); 
  return '₹ ${formatter.format(number)}';
}

  @override
 @override
Widget build(BuildContext context) {
  if (!hasInternet && !isLoading) {
    return _buildNoNetworkScreen();
  }

  return Scaffold(
    backgroundColor: const Color(0xFFF8FAFC),
    appBar: _buildAppBar(),
    body: isLoading
        ? _buildLoadingScreen()
        : paymentList == null || paymentList!.data.isEmpty
            ? _buildEmptyScreen()
            : RefreshIndicator(
                color: const Color.fromARGB(255, 223, 173, 189),
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
                            return _buildScheduleCard(index);
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
    surfaceTintColor: const Color.fromARGB(255, 231, 179, 197),
    shadowColor: Colors.black.withOpacity(0.15),
    iconTheme: const IconThemeData(color: Colors.white),
    title: const Text(
      'Payments Scheduled',
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
  final totalSchedules = paymentList!.data.length;

  double totalBalance = 0;
  for (var item in paymentList!.data) {
    totalBalance +=
        double.tryParse(item.balanceAmount.toString()) ?? 0;
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
    child: Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.event_note_rounded,
            title: 'Schedules',
            value: totalSchedules.toString(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.account_balance_wallet_rounded,
            title: 'Balance Due',
            value: '₹ ${totalBalance.toStringAsFixed(0)}',
          ),
        ),
      ],
    ),
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

  void _showScheduleDetails(dynamic item) {
  final statusColor = _getStatusColor(item.status.toString());

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.phaseNo.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: darkText,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              // _buildDetailRow('Description', item.description.toString()),
              // _buildDetailRow('Percentage', '${item.percentage}%'),
              _buildDetailRow(
                'Extra Work Amount',
                _formatCurrency(item.extraWorkAmount),
              ),
              _buildDetailRow(
                'Deduction Amount',
                _formatCurrency(item.deductionAmount),
              ),
              // _buildDetailRow(
              //   'Paid Amount',
              //   _formatCurrency(item.paidAmount),
              // ),
              // _buildDetailRow(
              //   'Balance Amount',
              //   _formatCurrency(item.balanceAmount),
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 10),
              //   child: Row(
              //     children: [
              //       const Expanded(
              //         child: Text(
              //           'Status',
              //           style: TextStyle(
              //             fontSize: 14,
              //             fontWeight: FontWeight.w600,
              //             color: lightText,
              //           ),
              //         ),
              //       ),
              //       Container(
              //         padding: const EdgeInsets.symmetric(
              //           horizontal: 12,
              //           vertical: 6,
              //         ),
              //         decoration: BoxDecoration(
              //           color: statusColor.withOpacity(0.12),
              //           borderRadius: BorderRadius.circular(20),
              //         ),
              //         child: Text(
              //           item.status.toString().toUpperCase(),
              //           style: TextStyle(
              //             color: statusColor,
              //             fontWeight: FontWeight.w700,
              //             fontSize: 12,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}


Widget _buildDetailRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: lightText,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: darkText,
            ),
          ),
        ),
      ],
    ),
  );
}

  Widget _buildScheduleCard(int index) {
    final item = paymentList!.data[index];
    final statusColor = _getStatusColor(item.status.toString());

    return GestureDetector(
         onTap: () => _showScheduleDetails(item),
      child: Container(
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
              // Header
              Row(
                children: [
                  Container(
                    height: 56,
                    width: 56,
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.calendar_month_rounded,
                      color: primaryColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.phaseNo.toString(),
                          style: const TextStyle(
                            color: darkText,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.description.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: lightText,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                         const SizedBox(height: 4),
                        Text(
                          'Percentage :${item.percentage.toString()}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      item.status.toString(),
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
      
              const SizedBox(height: 20),
              const Divider(height: 1),
              const SizedBox(height: 18),
      
              // Amount Cards
              Row(
                children: [
                  Expanded(
                    child: _buildAmountCard(
                      title: 'Estimated',
                      value: _formatCurrency(item.estCost),
                      icon: Icons.request_quote_rounded,
                      color: const Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildAmountCard(
                      title: 'Paid',
                      value: _formatCurrency(item.paidAmount),
                      icon: Icons.check_circle_rounded,
                      color: const Color(0xFF16A34A),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildAmountCard(
                      title: 'Balance',
                      value: _formatCurrency(item.balanceAmount),
                      icon: Icons.pending_actions_rounded,
                      color: _getBalanceColor(item.balanceAmount),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(0.15),
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: lightText,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
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
              Icons.event_note_outlined,
              size: 90,
              color: Color(0xFFCBD5E1),
            ),
            SizedBox(height: 16),
            Text(
              'No Scheduled Payments',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: darkText,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your upcoming payment schedule will appear here.',
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
                label: const Text('Try Again'),
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
