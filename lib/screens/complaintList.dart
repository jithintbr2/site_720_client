// ignore_for_file: must_be_immutable

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:site720_client/model/ComplaintListsModel.dart';
import 'package:site720_client/screens/addComplaint.dart';
import 'package:site720_client/screens/complaintViewPage.dart';
import 'package:site720_client/screens/dashboard.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/assets.dart';
import 'package:intl/intl.dart';

class ComplaintListPage extends StatefulWidget {
  String? token;
  ComplaintListPage(this.token, {super.key});

  @override
  _ComplaintListPageState createState() => _ComplaintListPageState();
}

class _ComplaintListPageState extends State<ComplaintListPage> {
  ComplaintListResponse? complaintList;
  bool? result = true;
  bool isLoading = false;

  final Color primaryColor = const Color.fromARGB(255, 179, 131, 143);
  final Color secondaryColor = const Color(0xFF0DB87E);
  final Color backgroundColor = const Color(0xFFF5F7FA);
  final Color cardColor = Colors.white;
  final Color textPrimary = const Color(0xFF1A1A1A);
  final Color textSecondary = const Color(0xFF666666);
  final Color dividerColor = const Color(0xFFEEEEEE);

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    final connectivityResult = await Connectivity().checkConnectivity();

    if (mounted) {
      setState(() {
        result = connectivityResult.contains(ConnectivityResult.mobile) ||
            connectivityResult.contains(ConnectivityResult.wifi);
      });
    }

    if (result == true) {
      complaintList = await HttpService.getComplaintList(widget.token!);
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _openViewPage(ComplaintData data) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ComplaintViewPage(data),
      ),
    );
  }

  void _deleteComplaint(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange[800]),
            const SizedBox(width: 10),
            const Text(
              "Delete Complaint",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text(
          "Are you sure you want to delete this complaint? This action cannot be undone.",
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "CANCEL",
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.pop(context);

              bool deleted =
                  await HttpService.deleteComplaint(widget.token!, id);

              if (deleted) {
                getData();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Complaint deleted successfully!"),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Failed to delete complaint."),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            child: const Text(
              "DELETE",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;
    IconData icon;

    switch (status.toLowerCase()) {
      case 'resolved':
        chipColor = Colors.green.withOpacity(0.1);
        textColor = Colors.green;
        icon = Icons.check_circle;
        break;
      case 'in progress':
        chipColor = Colors.orange.withOpacity(0.1);
        textColor = Colors.orange[800]!;
        icon = Icons.autorenew;
        break;
      case 'pending':
        chipColor = Colors.blue.withOpacity(0.1);
        textColor = Colors.blue;
        icon = Icons.schedule;
        break;
      default:
        chipColor = primaryColor.withOpacity(0.1);
        textColor = primaryColor;
        icon = Icons.error_outline;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(
            status,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    try {
      final inputFormat = DateFormat('yyyy-MM-dd');
      final outputFormat = DateFormat('MMM dd, yyyy');
      return outputFormat.format(inputFormat.parse(date));
    } catch (e) {
      return date;
    }
  }

  Widget _buildComplaintCard(ComplaintData item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openViewPage(item),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header: Title + Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'COMPLAINT',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.description ?? 'No description',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: textPrimary,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(item.statusName ?? 'Pending'),
                  ],
                ),

                const SizedBox(height: 20),

                /// Customer Info Section
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      /// Customer Name
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person_outline,
                              size: 18,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Customer',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  item.customerName ?? 'Unknown',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      const Divider(height: 1),

                      /// Contact & Date
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Phone
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.phone_outlined,
                                  size: 18,
                                  color: textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Contact',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.contactNumber ?? 'N/A',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          /// Date
                          Expanded(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  size: 18,
                                  color: textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Date',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _formatDate(item.incidentDate),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    /// View Button
                    _buildActionButton(
                      icon: Icons.remove_red_eye_outlined,
                      label: 'View',
                      color: primaryColor,
                      onPressed: () => _openViewPage(item),
                    ),

                    const SizedBox(width: 8),

                    _buildActionButton(
                      icon: Icons.edit_outlined,
                      label: 'Edit',
                      color: Colors.orange,
                      onPressed: () async {
                        var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddComplaint(
                              widget.token!,
                              complaintId: item.id != null
                                  ? int.tryParse(item.id!)
                                  : null,
                            ),
                          ),
                        );

                        if (result == true) {
                          getData(); // 🔥 Refresh updated list
                        }
                      },
                    ),

                    const SizedBox(width: 8),

                    _buildActionButton(
                      icon: Icons.delete_outline,
                      label: 'Delete',
                      color: Colors.red,
                      onPressed: () => _deleteComplaint(item.id!),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        elevation: 0,
      ),
      icon: Icon(icon, size: 16),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return result == true
        ? WillPopScope(
            onWillPop: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Dashboard(token: widget.token!),
                ),
              );
              return false;
            },
            child: Scaffold(
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /// Back Button + Title
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: backgroundColor,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: Icon(Icons.arrow_back,
                                      color: primaryColor),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Dashboard(token: widget.token!),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Complaints',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800,
                                      color: textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Manage all customer complaints',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          /// Refresh Button
                          Container(
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.refresh_rounded,
                                color: primaryColor,
                              ),
                              onPressed: getData,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Body Content
                    Expanded(
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : complaintList != null
                              ? complaintList!.data!.isNotEmpty
                                  ? RefreshIndicator(
                                      backgroundColor: cardColor,
                                      color: primaryColor,
                                      onRefresh: getData,
                                      child: ListView.builder(
                                        padding: const EdgeInsets.all(20),
                                        itemCount: complaintList!.data!.length,
                                        itemBuilder: (context, i) {
                                          return _buildComplaintCard(
                                              complaintList!.data![i]);
                                        },
                                      ),
                                    )
                                  : _noDataWidget()
                              : const Center(
                                  child: CircularProgressIndicator(),
                                ),
                    ),
                  ],
                ),
              ),

              /// Floating Action Button
              floatingActionButton: FloatingActionButton.extended(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                onPressed: () async {
                  var result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddComplaint(widget.token!),
                    ),
                  );

                  if (result == true) {
                    getData();
                  }
                },
                icon: const Icon(Icons.add, size: 22),
                label: const Text(
                  'New Complaint',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          )
        : _noNetworkWidget();
  }

  Widget _noDataWidget() {
    return RefreshIndicator(
      backgroundColor: cardColor,
      color: primaryColor,
      onRefresh: getData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.inbox_outlined,
                    size: 80,
                    color: primaryColor.withOpacity(0.3),
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  'No Complaints Yet',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: textPrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'When you add complaints, they will appear here',
                  style: TextStyle(
                    fontSize: 15,
                    color: textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddComplaint(widget.token!),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text(
                    'Create First Complaint',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _noNetworkWidget() {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.wifi_off_rounded,
                  size: 80,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'No Internet Connection',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: textPrimary,
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Please check your internet connection and try again',
                  style: TextStyle(
                    fontSize: 15,
                    color: textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: getData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                icon: const Icon(Icons.refresh_rounded),
                label: const Text(
                  'Retry Connection',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
