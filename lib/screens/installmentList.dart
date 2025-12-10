import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:site720_client/model/emiListModel.dart';
import 'package:site720_client/service/service.dart';

class InstallmentScreen extends StatefulWidget {
  final String projectId;
  final String? token; 

  const InstallmentScreen(this.projectId, {super.key, this.token});

  @override
  State<InstallmentScreen> createState() => _InstallmentScreenState();
}

class _InstallmentScreenState extends State<InstallmentScreen> {
  EmiListResponse? emiList;
  bool isLoading = false;
  double totalPaid = 0;
  double totalPending = 0;
  double totalAmount = 0;
  int paidCount = 0;
  int pendingCount = 0;
  int dueCount = 0;

  final Color primaryColor = const Color(0xFFB80D37);
  final Color paidColor = const Color(0xFF0DB87E);
  final Color pendingColor = const Color(0xFFFF6B35);
  final Color dueColor = const Color(0xFFFF4757);
  final Color backgroundColor = const Color(0xFFF5F7FA);
  final Color cardColor = Colors.white;
  final Color textPrimary = const Color(0xFF1A1A1A);
  final Color textSecondary = const Color(0xFF666666);

  @override
  void initState() {
    super.initState();
    _fetchEmiList();
  }

  Future<void> _fetchEmiList() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final token = widget.token ?? await _getToken();
      
      emiList = await HttpService.getEmiList(
        token: token,
        projectId: widget.projectId,
      );

      if (emiList != null && emiList!.data.isNotEmpty) {
        _calculateTotals();
      }
    } catch (e) {
      print("Error fetching EMI list: $e");
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<String> _getToken() async {
    // Implement your token retrieval logic
    return "";
  }

  void _calculateTotals() {
    totalPaid = 0;
    totalPending = 0;
    paidCount = 0;
    pendingCount = 0;
    dueCount = 0;

    for (var emi in emiList!.data) {
      double amount = double.tryParse(emi.installmentAmount) ?? 0;
      
      if (emi.status.toLowerCase() == 'paid') {
        totalPaid += amount;
        paidCount++;
      } else {
        totalPending += amount;
        pendingCount++;
        
        // Check if this installment is due
        if (_isDueDate(emi.installmentDate)) {
          dueCount++;
        }
      }
    }

    totalAmount = totalPaid + totalPending;
  }

  String _formatDate(String date) {
    try {
      final inputFormat = DateFormat('dd-MM-yyyy');
      final outputFormat = DateFormat('MMM dd, yyyy');
      return outputFormat.format(inputFormat.parse(date));
    } catch (e) {
      return date;
    }
  }

  String _formatCurrency(double amount) {
    return NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
    ).format(amount);
  }

  Widget _buildSummaryCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Overall Summary
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL AMOUNT',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatCurrency(totalAmount),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          /// Paid vs Pending
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  title: 'PAID',
                  value: _formatCurrency(totalPaid),
                  count: paidCount,
                  color: paidColor,
                  icon: Icons.check_circle_outline,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildStatItem(
                  title: 'PENDING',
                  value: _formatCurrency(totalPending),
                  count: pendingCount,
                  color: pendingColor,
                  icon: Icons.pending_outlined,
                ),
              ),
            ],
          ),
          
          if (dueCount > 0) ...[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: dueColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: dueColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    size: 16,
                    color: dueColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$dueCount installments are due',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: dueColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required String title,
    required String value,
    required int count,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: color,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$count installments',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmiCard(EmiData emi, int index) {
    bool isPaid = emi.status.toLowerCase() == 'paid';
    bool isDue = _isDueDate(emi.installmentDate);
    bool isUpcoming = _isUpcomingDate(emi.installmentDate);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header: Installment Number & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'INSTALLMENT ${index + 1}',
                      style: TextStyle(
                        fontSize: 11,
                        color: textSecondary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(emi.installmentDate),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: textPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isPaid
                        ? paidColor.withOpacity(0.1)
                        : (isDue ? dueColor.withOpacity(0.1) : pendingColor.withOpacity(0.1)),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isPaid
                          ? paidColor.withOpacity(0.3)
                          : (isDue ? dueColor.withOpacity(0.3) : pendingColor.withOpacity(0.3)),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isPaid ? paidColor : (isDue ? dueColor : pendingColor),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        isPaid ? 'PAID' : (isDue ? 'DUE' : 'UPCOMING'),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isPaid ? paidColor : (isDue ? dueColor : pendingColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Amount & Details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AMOUNT',
                            style: TextStyle(
                              fontSize: 11,
                              color: textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatCurrency(
                                double.tryParse(emi.installmentAmount) ?? 0),
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: textPrimary,
                            ),
                          ),
                        ],
                      ),
                      if (isDue && !isPaid)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: dueColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: dueColor.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.warning_amber_outlined,
                                size: 14,
                                color: dueColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'PAYMENT DUE',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: dueColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  
                  if (!isPaid) ...[
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Days remaining:',
                          style: TextStyle(
                            fontSize: 13,
                            color: textSecondary,
                          ),
                        ),
                        Text(
                          _getDaysRemaining(emi.installmentDate),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDue ? dueColor : textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Additional Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (isPaid ? paidColor : pendingColor).withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    isPaid ? Icons.check_circle_outline : Icons.info_outline,
                    size: 16,
                    color: isPaid ? paidColor : pendingColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isPaid 
                          ? 'Payment completed on time'
                          : (isDue 
                              ? 'Payment is overdue. Please settle at earliest.'
                              : 'Payment due on ${_formatDate(emi.installmentDate)}'),
                      style: TextStyle(
                        fontSize: 13,
                        color: isPaid ? paidColor : (isDue ? dueColor : textSecondary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isDueDate(String dateStr) {
    try {
      final dateFormat = DateFormat('dd-MM-yyyy');
      final installmentDate = dateFormat.parse(dateStr);
      final today = DateTime.now();
      
      return installmentDate.isBefore(today);
    } catch (e) {
      return false;
    }
  }

  bool _isUpcomingDate(String dateStr) {
    try {
      final dateFormat = DateFormat('dd-MM-yyyy');
      final installmentDate = dateFormat.parse(dateStr);
      final today = DateTime.now();
      
      return installmentDate.isAfter(today);
    } catch (e) {
      return false;
    }
  }

  String _getDaysRemaining(String dateStr) {
    try {
      final dateFormat = DateFormat('dd-MM-yyyy');
      final installmentDate = dateFormat.parse(dateStr);
      final today = DateTime.now();
      final difference = installmentDate.difference(today).inDays;
      
      if (difference < 0) {
        return '${difference.abs()} days overdue';
      } else if (difference == 0) {
        return 'Due today';
      } else {
        return '$difference days';
      }
    } catch (e) {
      return 'N/A';
    }
  }

  void _showInstallmentDetails(EmiData emi, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),
      builder: (_) => Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 60,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline,
                    color: primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Installment ${index + 1} Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: textPrimary,
                        ),
                      ),
                      Text(
                        _formatDate(emi.installmentDate),
                        style: TextStyle(
                          fontSize: 14,
                          color: textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  _buildDetailRow(
                    label: 'Installment Number',
                    value: '${index + 1}',
                    icon: Icons.numbers_outlined,
                  ),
                  const SizedBox(height: 15),
                  _buildDetailRow(
                    label: 'Amount',
                    value: _formatCurrency(double.tryParse(emi.installmentAmount) ?? 0),
                    icon: Icons.currency_rupee_outlined,
                  ),
                  const SizedBox(height: 15),
                  _buildDetailRow(
                    label: 'Due Date',
                    value: _formatDate(emi.installmentDate),
                    icon: Icons.calendar_today_outlined,
                  ),
                  const SizedBox(height: 15),
                  _buildDetailRow(
                    label: 'Status',
                    value: emi.status.toUpperCase(),
                    icon: emi.status.toLowerCase() == 'paid' 
                        ? Icons.check_circle_outline 
                        : Icons.pending_outlined,
                    valueColor: emi.status.toLowerCase() == 'paid' 
                        ? paidColor 
                        : (_isDueDate(emi.installmentDate) ? dueColor : pendingColor),
                  ),
                  if (emi.status.toLowerCase() != 'paid') ...[
                    const SizedBox(height: 15),
                    _buildDetailRow(
                      label: 'Days Remaining',
                      value: _getDaysRemaining(emi.installmentDate),
                      icon: Icons.timer_outlined,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'CLOSE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required IconData icon,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: textSecondary,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            /// Custom App Bar
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              decoration: BoxDecoration(
                color: cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: primaryColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Installments',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: textPrimary,
                        ),
                      ),
                     
                    ],
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.refresh_rounded, color: primaryColor),
                      onPressed: _fetchEmiList,
                    ),
                  ),
                ],
              ),
            ),

            /// Summary Card
            _buildSummaryCard(),

            /// Installments List
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : emiList != null
                      ? emiList!.data.isNotEmpty
                          ? RefreshIndicator(
                              backgroundColor: cardColor,
                              color: primaryColor,
                              onRefresh: _fetchEmiList,
                              child: ListView.builder(
                                itemCount: emiList!.data.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () => _showInstallmentDetails(
                                      emiList!.data[index], 
                                      index
                                    ),
                                    child: _buildEmiCard(
                                      emiList!.data[index], 
                                      index
                                    ),
                                  );
                                },
                              ),
                            )
                          : Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet_outlined,
                                    size: 80,
                                    color: textSecondary.withOpacity(0.3),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'No Installments Found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Installments will appear here',
                                    style: TextStyle(
                                      color: textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            )
                      : Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(),
                              const SizedBox(height: 20),
                              Text(
                                'Loading installments...',
                                style: TextStyle(
                                  color: textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}