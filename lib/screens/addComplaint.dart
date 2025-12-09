// ignore_for_file: must_be_immutable
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:site720_client/model/apiResponseModel.dart';
import 'package:site720_client/model/complaintTypeModel.dart';
import 'package:site720_client/model/complaintReportedByModel.dart';
import 'package:site720_client/model/complaintNatureModel.dart';
import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/common.dart';

class AddComplaint extends StatefulWidget {
  String token;
  final int? complaintId;

  AddComplaint(this.token, {this.complaintId, super.key});

  @override
  _AddComplaintState createState() => _AddComplaintState();
}

class _AddComplaintState extends State<AddComplaint> {
  final TextEditingController complaintDesc = TextEditingController();

  List<ComplaintType> complaintTypes = [];
  List<ComplaintReportedBy> reportedByList = [];
  List<ComplaintNature> natureList = [];

  String? selectedComplaintType;
  String? selectedReportedBy;
  String? selectedNature;

  DateTime incidentDate = DateTime.now();
  File? selectedImage;

  bool isEditMode = false;
  String? existingImageUrl;

  @override
  void initState() {
    super.initState();
    isEditMode = widget.complaintId != null;
    loadDropdowns();

    if (isEditMode) {
      loadComplaintDetails();
    }
  }

  Future<void> loadComplaintDetails() async {
    try {
      final res = await HttpService.getComplaintById(
        widget.token,
        widget.complaintId!,
      );

      if (res != null && res.status == true && res.data != null) {
        final data = res.data!;

        setState(() {
          selectedComplaintType = data.complaintType;
          selectedReportedBy = data.reportedBy;
          selectedNature = data.complaintNature;
          complaintDesc.text = data.description ?? '';
          incidentDate = DateTime.parse(data.incidentDate!);
          existingImageUrl = data.mediaUrl;
        });
      }
    } catch (e) {
      Common.toastMessaage("Failed to load complaint", Colors.red);
    }
  }

  Future<void> loadDropdowns() async {
    final typeRes = await HttpService.getComplaintType(widget.token);
    final reportedRes = await HttpService.getComplaintReportedBy(widget.token);
    final natureRes = await HttpService.getComplaintNature(widget.token);

    setState(() {
      complaintTypes = typeRes.data;
      reportedByList = reportedRes.data;
      natureList = natureRes.data;

      // Defaults only for ADD mode
      if (!isEditMode) {
        selectedReportedBy = reportedByList
            .firstWhere((e) => e.name == "Customer",
                orElse: () => reportedByList.first)
            .id;

        selectedNature = natureList
            .firstWhere((e) => e.name == "New", orElse: () => natureList.first)
            .id;
      }
    });
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => selectedImage = File(picked.path));
    }
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: incidentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => incidentDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0.5,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text(
          isEditMode ? 'Edit Complaint' : 'Add Complaint',
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildComplaintType(),
            _buildReportedBy(),
            _buildIncidentDate(),
            _buildDescription(),
            _buildNature(),
            _buildImagePicker(),
            const SizedBox(height: 20),
            _buildSubmitBtn(),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintType() {
    return _sectionCard(
      title: "Complaint Type *",
      child: Column(
        children: complaintTypes.map((e) {
          return _radioTile(
            title: e.name,
            value: e.id,
            groupValue: selectedComplaintType,
            onChanged: (val) => setState(() => selectedComplaintType = val),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildReportedBy() {
    return _sectionCard(
      title: "Complaint Reported By",
      child: Column(
        children: reportedByList.map((e) {
          return _radioTile(
            title: e.name,
            value: e.id,
            groupValue: selectedReportedBy,
            onChanged: (val) => setState(() => selectedReportedBy = val),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildIncidentDate() {
    return _sectionCard(
      title: "Incident Date",
      child: InkWell(
        onTap: pickDate,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: _inputDecoration(),
          child: Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 18),
              const SizedBox(width: 10),
              Text(DateFormat('dd-MM-yyyy').format(incidentDate)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return _sectionCard(
      title: "Complaint Description *",
      child: TextFormField(
        controller: complaintDesc,
        maxLines: 4,
        decoration: _textFieldDecoration("Enter detailed complaint..."),
      ),
    );
  }

  Widget _buildNature() {
    return _sectionCard(
      title: "Nature of Complaint",
      child: Column(
        children: natureList.map((e) {
          return _radioTile(
            title: e.name,
            value: e.id,
            groupValue: selectedNature,
            onChanged: (val) => setState(() => selectedNature = val),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildImagePicker() {
    return _sectionCard(
      title: "Upload Image",
      child: GestureDetector(
        onTap: pickImage,
        child: Container(
          width: double.infinity,
          height: 140,
          decoration: _inputDecoration(),
          child: selectedImage != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(selectedImage!, fit: BoxFit.cover),
                )
              : (existingImageUrl != null && existingImageUrl!.isNotEmpty)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child:
                          Image.network(existingImageUrl!, fit: BoxFit.cover),
                    )
                  : const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload_outlined, size: 40),
                        SizedBox(height: 8),
                        Text("Tap to upload image"),
                      ],
                    ),
        ),
      ),
    );
  }

  Widget _buildSubmitBtn() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onPressed: submitComplaint,
        child: Text(
          isEditMode ? "UPDATE COMPLAINT" : "SUBMIT COMPLAINT",
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Future<void> submitComplaint() async {
    if (selectedComplaintType == null ||
        selectedReportedBy == null ||
        selectedNature == null ||
        complaintDesc.text.isEmpty) {
      Common.toastMessaage("Please fill all required fields", Colors.red);
      return;
    }

    Common.showProgressDialog(context, "Please wait...");

    try {
      final res = isEditMode
          ? await HttpService.updateComplaint(
              token: widget.token,
              complaintId: widget.complaintId!, // ✅ corrected key name
              complaintType: selectedComplaintType!,
              reportedBy: selectedReportedBy!,
              incidentDate: DateFormat('yyyy-MM-dd').format(incidentDate),
              description: complaintDesc.text,
              nature: selectedNature!,
              image: selectedImage,
            )
          : await HttpService.addComplaint(
              token: widget.token,
              complaintType: selectedComplaintType!,
              reportedBy: selectedReportedBy!,
              incidentDate: DateFormat('yyyy-MM-dd').format(incidentDate),
              description: complaintDesc.text,
              nature: selectedNature!,
              image: selectedImage,
            );

      Navigator.pop(context); 

      if (res is ApiResponse && res.status == true) {
        Common.toastMessaage(res.message, Colors.green);
        Navigator.pop(context);
      } else if (res is ApiResponse) {
        Common.toastMessaage(
          res.message,
          Colors.red,
        );
      } else {
        Common.toastMessaage("Something went wrong", Colors.red);
      }
    } catch (e) {
      Navigator.pop(context);
      Common.toastMessaage("Error: ${e.toString()}", Colors.red);
    }
  }

  BoxDecoration _inputDecoration() => BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      );

  InputDecoration _textFieldDecoration(String hint) => InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      );

  Widget _radioTile({
    required String title,
    required String value,
    required String? groupValue,
    required Function(String) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: RadioListTile(
        title: Text(title, style: const TextStyle(fontSize: 14)),
        value: value,
        groupValue: groupValue,
        dense: true,
        activeColor: Colors.black,
        onChanged: (val) => onChanged(val!),
      ),
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
