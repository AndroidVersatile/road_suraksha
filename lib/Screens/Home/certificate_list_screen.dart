import 'dart:io';
import 'dart:ui';
import 'package:gauvigyaan/routing/app_pages.dart';
import 'package:gauvigyaan/routing/app_routing.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gauvigyaan/theme/app_theme.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../constants/assets.dart';
import '../../providers/home_provider.dart';
import '../../widgets/button.dart';

class CertificateListScreen extends StatefulWidget {
  const CertificateListScreen({super.key});

  @override
  State<CertificateListScreen> createState() => _CertificateListScreenState();
}

class _CertificateListScreenState extends State<CertificateListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate'),
      ),
      body: Container(
        padding: AppTheme.boxPadding,
        child: Column(
          children: [
            ListTile(
              tileColor: Colors.grey.shade200,
              title: const Text('Live Paper Certificate'),
              trailing: const Icon(Icons.remove_red_eye_rounded),
              onTap: () {
                context.push(AppPages.liveCertificateList);
              },
            ),
            AppTheme.verticalSpacing(),
          ],
        ),
      ),
    );
  }
}

class ViewLiveCertificateScreen extends StatefulWidget {
  const ViewLiveCertificateScreen({super.key});

  @override
  State<ViewLiveCertificateScreen> createState() =>
      _ViewLiveCertificateScreenState();
}

class _ViewLiveCertificateScreenState extends State<ViewLiveCertificateScreen> {
  bool loading = false;

  // ✅ Complete PDF Download Logic with ALL details
  Future<void> pdfDownload({
    required String name,
    required String rank,
    required String certificateMsg,
    required String rtsDate,
    required String districtName,
    required String blockName,
  }) async {
    if (!mounted) return;

    setState(() => loading = true);

    // UI ko ek frame dena
    await Future.delayed(const Duration(milliseconds: 100));

    try {
      final pdf = pw.Document();
      final imageData = await rootBundle.load(Assets.certificate);
      final bgImage = pw.MemoryImage(imageData.buffer.asUint8List());

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (_) => pw.Stack(
            children: [
              pw.Image(bgImage),

              // ✅ Name
              pw.Positioned(
                top: 190,
                left: 155,
                child: pw.Text(
                  name,
                  style: pw.TextStyle(
                    fontSize: 15,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              // ✅ District Name
              pw.Positioned(
                top: 210,
                left: 186,
                child: pw.Text(
                  districtName,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              // ✅ Block Name
              pw.Positioned(
                top: 210,
                left: 65,
                child: pw.Text(
                  blockName,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              // ✅ Rank (Grade)
              pw.Positioned(
                top: 258,
                left: 165,
                child: pw.Text(
                  rank,
                  style: pw.TextStyle(
                    fontSize: 15,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),

              // ✅ Certificate Message (if any)
              if (certificateMsg.isNotEmpty)
                pw.Positioned(
                  top: 280,
                  left: 80,
                  right: 80,
                  child: pw.Text(
                    certificateMsg,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.normal,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),

              // ✅ Date
              pw.Positioned(
                top: 372,
                left: 76,
                child: pw.Text(
                  rtsDate,
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File("${output.path}/certificate.pdf");
      await file.writeAsBytes(await pdf.save());

      if (!mounted) return;

      await Share.shareXFiles([XFile(file.path)], text: 'Certificate');
    } catch (e) {
      debugPrint('PDF ERROR: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => loading = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().getCertificateList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeProvider>(context);
    var certificate = provider.certificateModel;

    // If no data, show no-data screen
    if (certificate.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Certificate')),
        body: Center(child: Image.asset(Assets.noData)),
      );
    }

    // ✅ Get data
    String districtName = provider.userModel?.districtName ?? 'N/A';
    String blockName = provider.userModel?.blockName ?? 'N/A';

    // ✅ Calculate Rank & Certificate Message
    String certificateMsg = '';
    String rank = '';
    double a = double.tryParse(certificate.first.persantage) ?? 0;

    if (a < 60) {
      certificateMsg = "Pay attention to road safety rules";
      rank = "D";
    } else if (a >= 60 && a <= 75) {
      certificateMsg = "Good effort! Keep improving";
      rank = "C";
    } else if (a >= 76 && a <= 90) {
      certificateMsg = "Well done! Great performance";
      rank = "B";
    } else if (a > 90) {
      certificateMsg = "Excellent! Outstanding achievement";
      rank = "A";
    }

    // ✅ Format Date
    String formattedDate = '';
    try {
      if (provider.userModel?.rts != null &&
          provider.userModel!.rts.isNotEmpty) {
        DateTime rtsDateTime =
            DateFormat('dd-MM-yyyy HH:mm:ss').parse(provider.userModel!.rts);
        formattedDate = DateFormat('dd-MM-yyyy').format(rtsDateTime);
      }
    } catch (e) {
      formattedDate = provider.userModel?.rts ?? '';
    }

    // ✅ UI
    return Scaffold(
      appBar: AppBar(title: const Text('Certificate')),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF850000)),
            ),
            height: context.screenHeight,
            width: context.screenWidth,
            padding: AppTheme.screenPadding,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  SizedBox(height: 12,),
                  Image.asset(
                    Assets.certificate,
                    height: 600,
                    width: context.screenWidth,
                    fit: BoxFit.contain,
                  ),

                  // ✅ Name (Preview)
                  Positioned(
                    top: 284,
                    left: 100,
                    child: Text(
                      '${provider.userModel?.studentName ?? 'N/A'}',
                      style: context.textTheme.labelLarge?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                      ),
                    ),
                  ),

                  // ✅ District (Preview)
                  Positioned(
                    top: 300,
                    left: 132,
                    child: Text(
                      districtName,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w700,
                        fontSize: 8,
                      ),
                    ),
                  ),

                  // ✅ Block (Preview)
                  Positioned(
                    top: 300,
                    left: 38,
                    child: Text(
                      blockName,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w700,
                        fontSize: 8,
                      ),
                    ),
                  ),

                  // ✅ Rank (Preview)
                  Positioned(
                    top: 335,
                    left: 120,
                    child: Text(
                      rank,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w700,
                        fontSize: 7,
                      ),
                    ),
                  ),

                  // // ✅ Certificate Message (Preview)
                  // Positioned(
                  //   top: 330,
                  //   left: 64,
                  //   right: 40,
                  //   child: Text(
                  //     certificateMsg,
                  //     style: context.textTheme.labelSmall?.copyWith(
                  //       color: Colors.orange,
                  //       fontSize: 6,
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),

                  // ✅ Date (Preview)
                  Positioned(
                    top: 402,
                    left: 44,
                    child: Text(
                      formattedDate,
                      style: context.textTheme.labelLarge?.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (loading)
            Positioned.fill(
              child: Container(
                alignment: Alignment.center,
                color: Colors.grey.withOpacity(0.4),
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Creating PDF...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomSheet: !loading
          ? Row(
              children: [
                Expanded(
                  child: CustomElevatedIconBtn(
                    icon: Icons.download,
                    color: context.colorScheme.primary,
                    onPressed: () {
                      pdfDownload(
                        name: provider.userModel?.studentName ?? 'N/A',
                        rank: rank,
                        certificateMsg: certificateMsg,
                        rtsDate: formattedDate,
                        districtName: districtName,
                        blockName: blockName,
                      );
                    },
                    text: 'Download Certificate',
                    iconColor: Colors.green,
                  ),
                ),
              ],
            )
          : null,
    );
  }
}

class ViewDemoCertificateList extends StatefulWidget {
  const ViewDemoCertificateList({super.key});

  @override
  State<ViewDemoCertificateList> createState() =>
      _ViewDemoCertificateListState();
}

class _ViewDemoCertificateListState extends State<ViewDemoCertificateList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context.read<HomeProvider>().getDemoCertificateList();
      },
    );
  }

  bool loading = false;

  pdfDownload({
    required BuildContext contxt,
    required String name,
    required String address,
    required String percentage,
  }) async {
    loading = true;
    setState(() {});
    final pdf = pw.Document();
    var image = await rootBundle.load(Assets.certificate);
    final imageBytes = image.buffer.asUint8List();
    pw.Image image1 = pw.Image(pw.MemoryImage(imageBytes));
    pdf.addPage(
      pw.Page(
        margin: pw.EdgeInsets.zero,
        pageFormat: PdfPageFormat.a4,
        orientation: pw.PageOrientation.portrait,
        build: (pw.Context context) => pw.Center(
          child: pw.Container(
            alignment: pw.Alignment.center,
            height: contxt.screenHeight,
            child: pw.Stack(children: [
              image1,
              pw.Positioned(
                  top: contxt.screenHeight - (contxt.screenHeight * 0.56),
                  left: contxt.screenWidth - (contxt.screenWidth * 0.74),
                  child: pw.Text(
                    name,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 15,
                    ),
                  )),
              pw.Positioned(
                  top: contxt.screenHeight - (contxt.screenHeight * 0.52),
                  left: contxt.screenWidth - (contxt.screenWidth * 0.74),
                  child: pw.Text(
                    address,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 15,
                    ),
                  )),
              pw.Positioned(
                  top: contxt.screenHeight - (contxt.screenHeight * 0.39),
                  right: contxt.screenWidth - (contxt.screenWidth * 0.58),
                  child: pw.Text(
                    percentage,
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 15,
                    ),
                  )),
            ]),
          ),
        ),
      ),
    );
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/certificate.pdf");

    await file.writeAsBytes(await pdf.save());
    print(file.path);
    loading = false;
    setState(() {});
    Share.shareXFiles([XFile(file.path)]);
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeProvider>(context);
    var certificate = provider.demoCertificateModel;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Certificate'),
      ),
      body: certificate.isEmpty
          ? Center(
              child: Image.asset(Assets.noData),
            )
          : Stack(children: [
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.green)),
                height: context.screenHeight,
                width: context.screenWidth,
                padding: AppTheme.screenPadding,
                child: Stack(children: [
                  Image.asset(
                    Assets.certificate,
                    height: 600,
                    width: context.screenWidth,
                    fit: BoxFit.fill,
                  ),
                  Positioned(
                      top: 300,
                      left: 70,
                      child: Text(
                        '${provider.userModel?.studentName}',
                        style: context.textTheme.labelLarge?.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      )),
                  Positioned(
                      top: 320,
                      left: 60,
                      child: Text(
                        '${provider.userModel?.address}',
                        style: context.textTheme.labelLarge?.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      )),
                  Positioned(
                      top: 415,
                      right: 110,
                      child: Text(
                        certificate.first.persantage,
                        style: context.textTheme.labelLarge?.copyWith(
                          color: Colors.orange,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                        ),
                      )),
                ]),
              ),
              if (loading)
                Positioned(
                    child: Container(
                        height: context.screenHeight,
                        width: context.screenWidth,
                        alignment: Alignment.center,
                        color: Colors.grey.withOpacity(0.4),
                        child: const CircularProgressIndicator())),
            ]),
      bottomSheet: !loading
          ? certificate.isEmpty
              ? null
              : Row(
                  children: [
                    Expanded(
                      child: CustomElevatedIconBtn(
                        icon: Icons.download,
                        color: context.colorScheme.primary,
                        onPressed: () {
                          pdfDownload(
                            contxt: context,
                            name: provider.userModel!.studentName,
                            address: provider.userModel!.address,
                            percentage: certificate.first.persantage,
                          );
                        },
                        text: 'Download Certificate',
                        iconColor: Colors.green,
                      ),
                    ),
                  ],
                )
          : null,
    );
  }
}