import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';

class PdfViewPage extends StatefulWidget {

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {

  PDFDocument document;

  Future<PDFDocument> loadDocument(f) async {
    return PDFDocument.fromFile(File(f));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Document"),
      ),
      body: Center(
        child: FutureBuilder<PDFDocument>(
          future: loadDocument('/data/user/0/com.example.book_app/app_flutter/mybook.pdf'),
          builder: (context, snapshot) {
            if (snapshot.hasData){
              print(snapshot.data);
              return PDFViewer(document: snapshot.data);
            }

            return Center(child: CircularProgressIndicator());
          }
        )),
      );
  }
}
