import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:site720_client/model/ComplaintListsModel.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ComplaintViewPage extends StatelessWidget {
  final ComplaintData data;

  const ComplaintViewPage(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFFB80D37);
    final Color backgroundColor = const Color(0xFFF5F7FA);
    final Color cardColor = Colors.white;
    final Color textPrimary = const Color(0xFF1A1A1A);
    final Color textSecondary = const Color(0xFF666666);
    
    // Format date
    String formattedDate = _formatDate(data.incidentDate);
    
    // Get status color
    Color statusColor = _getStatusColor(data.statusName);
    
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            /// Custom Header
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              decoration: BoxDecoration(
                color: cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Back Button & Title
                  Row(
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Complaint Details',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: textPrimary,
                              ),
                            ),
                           
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: statusColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              data.statusName ?? 'Pending',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  /// Complaint Description Card
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: primaryColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'COMPLAINT',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: textSecondary,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          data.description ?? 'No description provided',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: textPrimary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Details Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Customer Information Card
                    _buildDetailCard(
                      icon: Icons.person_outline,
                      title: 'Customer Information',
                      children: [
                        _buildDetailRow(
                          label: 'Full Name',
                          value: data.customerName ?? 'Not specified',
                          icon: Icons.badge_outlined,
                        ),
                        _buildDetailRow(
                          label: 'Contact Number',
                          value: data.contactNumber ?? 'Not provided',
                          icon: Icons.phone_outlined,
                        ),
                        _buildDetailRow(
                          label: 'Incident Date',
                          value: formattedDate,
                          icon: Icons.calendar_today_outlined,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    /// Additional Information Card
                    _buildDetailCard(
                      icon: Icons.info_outline,
                      title: 'Additional Information',
                      children: [
                        _buildDetailRow(
                          label: 'Complaint Type',
                          value: data.complaintTypeName ?? 'General',
                          icon: Icons.category_outlined,
                        ),
                        _buildDetailRow(
                          label: 'Reported By',
                          value: data.reportedByName ?? 'Customer',
                          icon: Icons.report_outlined,
                        ),
                        _buildDetailRow(
                          label: 'Nature',
                          value: data.complaintNatureName ?? 'Not specified',
                          icon: Icons.nature_outlined,
                        ),
                      ],
                    ),

                    /// Media Section
                    if (data.mediaUrl != null && data.mediaUrl!.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _buildDetailCard(
                            icon: Icons.photo_outlined,
                            title: 'Attached Media',
                            children: [
                              const SizedBox(height: 8),
                              _buildMediaPreview(data.mediaUrl!, context),
                            ],
                          ),
                        ],
                      ),

                    /// Timeline/Notes Section
                    // const SizedBox(height: 20),
                    // _buildDetailCard(
                    //   icon: Icons.history_outlined,
                    //   title: 'Activity Timeline',
                    //   children: [
                    //     _buildTimelineItem(
                    //       title: 'Complaint Created',
                    //       time: 'Today, 10:30 AM',
                    //       icon: Icons.add_circle_outline,
                    //       color: Colors.blue,
                    //     ),
                    //     _buildTimelineItem(
                    //       title: 'Assigned to Support',
                    //       time: 'Today, 11:15 AM',
                    //       icon: Icons.person_add_outlined,
                    //       color: Colors.orange,
                    //     ),
                    //     _buildTimelineItem(
                    //       title: 'In Progress',
                    //       time: 'Today, 2:45 PM',
                    //       icon: Icons.autorenew_outlined,
                    //       color: Colors.purple,
                    //     ),
                    //   ],
                    // ),

                    /// Action Buttons
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        // Expanded(
                        //   child: ElevatedButton.icon(
                        //     onPressed: () {
                        //       // Edit functionality
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: cardColor,
                        //       foregroundColor: textPrimary,
                        //       padding: const EdgeInsets.symmetric(
                        //           vertical: 16),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12),
                        //         side: BorderSide(
                        //           color: textSecondary.withOpacity(0.2),
                        //         ),
                        //       ),
                        //       elevation: 0,
                        //     ),
                        //     icon: Icon(
                        //       Icons.edit_outlined,
                        //       color: primaryColor,
                        //     ),
                        //     label: Text(
                        //       'Edit Complaint',
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.w600,
                        //         color: textPrimary,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(width: 12),
                        // Expanded(
                        //   child: ElevatedButton.icon(
                        //     onPressed: () {
                        //       // Share functionality
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: primaryColor,
                        //       foregroundColor: Colors.white,
                        //       padding: const EdgeInsets.symmetric(
                        //           vertical: 16),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12),
                        //       ),
                        //       elevation: 0,
                        //     ),
                        //     icon: const Icon(Icons.share_outlined),
                        //     label: const Text(
                        //       'Share',
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.w600,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB80D37).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: const Color(0xFFB80D37),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: const Color(0xFF666666),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF1A1A1A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPreview(String imageUrl, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              backgroundColor: Colors.black,
              body: Center(
                child: PhotoView(
                  imageProvider: NetworkImage(imageUrl),
                  backgroundDecoration: const BoxDecoration(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.grey[100],
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => Center(
                  child: CircularProgressIndicator(
                    color: const Color(0xFFB80D37),
                  ),
                ),
                errorWidget: (context, url, error) => Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 50,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.zoom_in_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required String title,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              icon,
              size: 18,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    if (status == null) return const Color(0xFFB80D37);
    
    switch (status.toLowerCase()) {
      case 'resolved':
        return Colors.green;
      case 'in progress':
        return Colors.orange;
      case 'pending':
        return Colors.blue;
      case 'closed':
        return Colors.grey;
      default:
        return const Color(0xFFB80D37);
    }
  }

  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return 'Not specified';
    
    try {
      final inputFormat = DateFormat('yyyy-MM-dd');
      final outputFormat = DateFormat('MMMM dd, yyyy');
      return outputFormat.format(inputFormat.parse(date));
    } catch (e) {
      return date;
    }
  }
}