import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:site720_client/model/getDocDetailsModel.dart';

import 'package:site720_client/service/service.dart';
import 'package:site720_client/settings/common.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DocumentPage extends StatefulWidget {
  final String projectId;
  const DocumentPage({super.key, required this.projectId});

  @override
  State<DocumentPage> createState() => _DocumentPageState();
}

class _DocumentPageState extends State<DocumentPage> {
  GetDocsDetails? docsData;
  bool isLoading = true;
  bool hasNetwork = true;
  String token = "";

  @override
  void initState() {
    super.initState();
    fetchDocs();
  }

  Future<void> fetchDocs() async {
    token = await Common.getSharedPref("token");

    final List<ConnectivityResult> connectivityResult =
        await (Connectivity().checkConnectivity());
    if (!(connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi))) {
      setState(() {
        hasNetwork = false;
        isLoading = false;
      });
      return;
    }

    try {
      final result = await HttpService.getDocsData(token, widget.projectId);
      if (mounted) {
        setState(() {
          docsData = result;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching docs: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Documents"),
        backgroundColor: Color.fromARGB(248, 218, 177, 188),
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : !hasNetwork
              ? const Center(child: Text("No network connection"))
              : docsData == null || docsData!.data.isEmpty
                  ? const Center(child: Text("No documents available"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: docsData!.data.length,
                      itemBuilder: (context, index) {
                        final doc = docsData!.data[index];
                        final isPdf =
                            doc.imgPath.toLowerCase().endsWith(".pdf");

                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 4,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(12),
                            leading: isPdf
                                ? const Icon(Icons.picture_as_pdf,
                                    color: Colors.red, size: 40)
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: CachedNetworkImage(
                                      imageUrl: doc.imgPath,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      placeholder: (c, _) =>
                                          const Icon(Icons.image),
                                      errorWidget: (c, url, _) =>
                                          const Icon(Icons.broken_image),
                                    ),
                                  ),
                            title: Text(
                              "Document ${doc.id}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(
                              isPdf ? "PDF File" : "Image",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            trailing: const Icon(Icons.open_in_new, color: Color(0xFFC24B68)),
                            onTap: () {
                              if (isPdf) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        PdfViewerPage(url: doc.imgPath),
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    child: InteractiveViewer(
                                      panEnabled: true,
                                      minScale: 0.8,
                                      maxScale: 4,
                                      child: CachedNetworkImage(
                                        imageUrl: doc.imgPath,
                                        fit: BoxFit.contain,
                                        placeholder: (c, _) => const Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (c, url, _) =>
                                            const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        );
                      },
                    ),
    );
  }
}

class PdfViewerPage extends StatelessWidget {
  final String url;
  const PdfViewerPage({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Viewer")),
      body: SfPdfViewer.network(url),
    );
  }
}