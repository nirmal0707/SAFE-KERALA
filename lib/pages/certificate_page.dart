//import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

//import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart' as fw;
import 'package:printing/printing.dart';
import 'package:safekerala/models/data_model.dart';

class Certificate extends StatefulWidget {
  bool isCompleted;
  DataModel cfM;

  Certificate({this.isCompleted, this.cfM});

  @override
  _CertificateState createState() => _CertificateState();
}

class _CertificateState extends State<Certificate> {
  String signUpdate = '';
  String todayDate = '';

  generatePdf() async {
    final font = await rootBundle.load("assets/OpenSans-Regular.ttf");
    final ttf = fw.Font.ttf(font);
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Header(
            level: 2,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: <pw.Widget>[
                pw.Text('Department of Health Services , Kerala',
                    textScaleFactor: 2),
              ],
            ),
          ),
          pw.Header(
            level: 2,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: <pw.Widget>[
                pw.Text('Quarantine Cerificate', textScaleFactor: 2),
              ],
            ),
          ),
          pw.Padding(padding: const pw.EdgeInsets.all(20)),
          pw.Paragraph(
              text:
                  'I, Dr. .................................... hereby certify that Sri/Smt/Ms. ${widget.cfM.name} residing at ${widget.cfM.houseName}, ${widget.cfM.ward}, ${widget.cfM.panchayath} and holdingpassport no ${widget.cfM.passportID} has been on homequarantine against 2019-nCorona from $signUpdate till $todayDate under ThePublic Health Act rules and regulations /guidelines of the Department of Health and FamilyWelfare, which are in force in the State of Kerala for the prevention and containment of 2019-nCorona virus infection, as, he/she ----'),
          pw.Padding(padding: const pw.EdgeInsets.all(5)),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Paragraph(
                  text:
                      'a) had arrived from an affected country as notified by Government/'),
              pw.Paragraph(
                  text:
                      'b) was a close contact of a confirmed case of 2019-nCorona virus infection/'),
              pw.Paragraph(
                  text:
                      'c) was a close contact of a suspect case of 2019-nCorona virus infection.'),
              pw.Paragraph(
                  text: '(clearly strike out clause which is not applicable)'),
            ],
          ),
          pw.Padding(padding: const pw.EdgeInsets.all(50)),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: <pw.Widget>[
              pw.Paragraph(text: 'Date'),
              pw.Paragraph(text: 'Office Seal'),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: <pw.Widget>[
                  pw.Paragraph(text: 'Name Designation and'),
                  pw.Paragraph(text: 'signature of Medical Officer'),
                ],
              )
            ],
          ),
          pw.Padding(padding: const pw.EdgeInsets.all(75)),
          pw.Header(
            level: 2,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: <pw.Widget>[
                pw.Text('Department of Health Services , Kerala',
                    textScaleFactor: 2),
              ],
            ),
          ),
          pw.Header(
            level: 2,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
              children: <pw.Widget>[
                pw.Text('2019-nCorona Quarantine Release Certificate',
                    textScaleFactor: 2),
              ],
            ),
          ),
          pw.Padding(padding: const pw.EdgeInsets.all(20)),
          pw.Paragraph(
              text:
                  'I Dr ............... after verification of the certificate and examination of the person who hasaffixed signature below,, certify that Sri/ Smt/ Ms. ${widget.cfM.name} residing at ${widget.cfM.houseName}, ${widget.cfM.ward}, ${widget.cfM.panchayath} and holding passport no ${widget.cfM.passportID} had been placed on homequarantine against 2019-nCorona from $signUpdate till $todayDate under ThePublic Health Act rules and regulations /guidelines of the Department of Health and FamilyWelfare, which are in force in the State of Kerala for the prevention and containment of2019-nCorona virus infection, is now declared as released from home quarantine and fitto resume duties/work/school'),
          pw.Padding(padding: const pw.EdgeInsets.all(50)),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: <pw.Widget>[
              pw.Paragraph(text: 'Date'),
              pw.Paragraph(text: 'Office Seal'),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: <pw.Widget>[
                  pw.Paragraph(text: 'Name Designation and'),
                  pw.Paragraph(text: 'signature of Medical Officer'),
                ],
              )
            ],
          ),
          pw.Padding(padding: const pw.EdgeInsets.all(25)),
          pw.Paragraph(
              text:
                  '...................................................................'),
          pw.Paragraph(text: 'Signature of the Person who was placed'),
          pw.Paragraph(text: 'under Quarantine/Home isolation'),
        ],
      ),
    );
//    final output = await getTemporaryDirectory();
//    final file = File("${output.path}/example.pdf");
////    final file = File("example.pdf");
//    await file.writeAsBytes(pdf.save());
    Printing.sharePdf(bytes: pdf.save(), filename: 'certificate.pdf');
  }

  setDate() {
    var date = DateTime.parse(widget.cfM.date);

    setState(() {
      todayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
      signUpdate = DateFormat("dd-MM-yyyy").format(date);
    });
  }

  @override
  void initState() {
    super.initState();
    setDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('View Certificate'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.file_download,
              size: 30,
            ),
            onPressed: () {
              generatePdf();
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      body: ListView(
        primary: false,
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.teal,
            ),
            child: Container(
              padding: EdgeInsets.only(top: 10, left: 50),
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(top: 10, left: 20, bottom: 20, right: 20),
                  width: double.infinity,
                  child: Text(
                    "Print this form and get verified after completing your quarantine.\nYou can download the pdf by clicking the download icon in the top right corner.",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 5),
                  width: double.infinity,
                  child: Text(
                    "Department of Health Services , Kerala",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: double.infinity,
                  child: Text(
                    "Quarantine Cerificate",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  child: Text(
                    'I, Dr. .......................... hereby certify that Sri/Smt/Ms. ${widget.cfM.name} residing at ${widget.cfM.houseName}, ${widget.cfM.ward}, ${widget.cfM.panchayath} and holdingpassport no ${widget.cfM.passportID} has been on homequarantine against 2019-nCorona from $signUpdate till $todayDate under ThePublic Health Act rules and regulations /guidelines of the Department of Health and FamilyWelfare, which are in force in the State of Kerala for the prevention and containment of 2019-nCorona virus infection, as, he/she ----',
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  width: double.infinity,
                  child: Text(
                      'a) had arrived from an affected country as notified by Government/\nb) was a close contact of a confirmed case of 2019-nCorona virus infection/\nc) was a close contact of a suspect case of 2019-nCorona virus infection.\n\n(clearly strike out clause which is not applicable)'),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('Date'),
                      Text('Office Seal'),
                      Text(
                          'Name Designation\nand signature of\nMedical Officer'),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Container(
                  margin: EdgeInsets.only(top: 20, bottom: 5),
                  width: double.infinity,
                  child: Text(
                    "Department of Health Services , Kerala",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  width: double.infinity,
                  child: Text(
                    "2019-nCorona Quarantine Release Certificate",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  child: Text(
                    'I Dr ............... after verification of the certificate and examination of the person who hasaffixed signature below, certify that Sri/ Smt/ Ms. ${widget.cfM.name} residing at ${widget.cfM.houseName}, ${widget.cfM.ward}, ${widget.cfM.panchayath} and holding passport no ${widget.cfM.passportID} had been placed on homequarantine against 2019-nCorona from $signUpdate till $todayDate under ThePublic Health Act rules and regulations /guidelines of the Department of Health and FamilyWelfare, which are in force in the State of Kerala for the prevention and containment of2019-nCorona virus infection, is now declared as released from home quarantine and fitto resume duties/work/school',
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text('Date'),
                      Text('Office Seal'),
                      Text(
                          'Name Designation\nand signature of\nMedical Officer'),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 15),
                  width: double.infinity,
                  child: Text(
                      '...................................................................\nSignature of the Person who was placed\nunder Quarantine/Home isolation'),
                ),
//                  Container(
//                    margin: EdgeInsets.symmetric(horizontal: 20),
//                    width: double.infinity,
//                    child: Text(
//                      "Name: ${widget.cfM.name}\n\nDistrict: ${widget.cfM.district}\n\nMobile Number: ${widget.cfM.email}\n\nQuarantine Status: ${widget.isCompleted ? "completed" : "not completed"}",
////                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
////                  textAlign: TextAlign.center,
//                    ),
//                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//      pw.Page(
//        pageFormat: PdfPageFormat.a4,
//        build: (pw.Context context) {
//          return pw.Column(children: [
//            pw.Text("E_Certificate",
//                style: pw.TextStyle(
//                    font: ttf, fontSize: 20, fontWeight: pw.FontWeight.bold),
//                textAlign: pw.TextAlign.center),
//            pw.Text(
//              "Name: ${widget.cfM.name}\n\nDistrict: ${widget.cfM.district}\n\nMobile Number: ${widget.cfM.email}\n\nQuarantine Status: ${widget.isCompleted ? "completed" : "not completed"}",
//              style: pw.TextStyle(font: ttf),
//            ),
//          ]);
////          return pw.Center(
////            child: pw.Text("Name:", style: pw.TextStyle(font: ttf)),
////          ); // Center
//        },
//      ),
