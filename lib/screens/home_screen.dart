import 'package:book_app/consttants.dart';
import 'package:book_app/screens/pdf_view_page.dart';
import 'package:book_app/widgets/book_rating.dart';
import 'package:book_app/widgets/reading_card_list.dart';
import 'package:book_app/widgets/two_side_rounded_button.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_text/pdf_text.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final url = "http://www.africau.edu/images/default/sample.pdf";
  var progressString = "Download";
  bool yes = false;
  File f ;
  bool audio = false;
  String string = 'Play';
  String path;

  Future<String> downloadFile(String url) async {
    Dio dio = Dio();
    var i = "";

    try {
      var dir = await getApplicationDocumentsDirectory();
      path = "${ dir.path }/mybook.pdf";

      await dio.download(url, "${dir.path}/mybook.pdf",
          onReceiveProgress: (rec, total) {
            print("Rec: $rec , Total: $total");

            setState(() {
              progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
            });
          });
    } catch (e) {
      print(e);
    }

    setState(() {
      progressString = "Downloaded";
    });
    print("Download completed");
    return i;
  }

  Future<String> getNotes() async {
      PDFDoc v = await PDFDoc.fromFile(File(path));
        v.text.then((c){
          print(v.text);
        });
        return v.text;

  }
  bool isPlaying = false;


//  @override
//  void dispose() {
//    FlutterTts().stop();
//    super.dispose();
//  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/main_page_bg.png"),
                alignment: Alignment.topCenter,
                fit: BoxFit.fitWidth,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: size.height * .1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.display1,
                      children: [
                        TextSpan(text: "Explore Books \n"),
                        TextSpan(
                            text: "See All...",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[400]
                            ))
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      ReadingListCard(
                        image: "assets/images/book-2.png",
                        title: "Top Ten Business Hacks",
                        auth: "Herman Joel",
                        rating: 4.8,
                        text: progressString,
                        pressRead: () {
                          downloadFile(url).then((r) {
                            yes = true;
                          });
                        },
                      ),
                      ReadingListCard(
                        image: "assets/images/book-1.png",
                        title: "Crushing & Influence",
                        auth: "Gary Venchuk",
                        rating: 4.9,
                        price: "1,000"
                      ),
                      SizedBox(width: 30),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.display1,
                          children: [
                            TextSpan(text: "Downloaded\n",
                            style: TextStyle(
                              color: Colors.black
                            )),
                            TextSpan(
                              text: "See All...",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                color: Colors.green[200]
                              ),
                            ),
                          ],
                        ),
                      ),
                      bestOfTheDayCard(size, context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container bestOfTheDayCard(Size size, BuildContext context) {

    Future<String> getString(File file) async {
      PDFDoc doc = await PDFDoc.fromFile(file);
      return doc.text;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      width: double.infinity,
      height: 205,
      child: Stack(
        children: <Widget>[
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 24,
                top: 24,
                right: size.width * .35,
              ),
              height: 185,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFFEAEAEA).withOpacity(.45),
                borderRadius: BorderRadius.circular(29),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "New York Time Best For 11th March 2020",
                    style: TextStyle(
                      fontSize: 9,
                      color: kLightBlackColor,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Top Ten \nBusiness Hacks",
                    style: Theme.of(context).textTheme.title,
                  ),
                  Text(
                    "Herman Joel",
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      BookRating(score: 4.8),
                      SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          width: size.width * .3,
                          child: TwoSideRoundedButton(
                                text: string,
                                radius: 24,
                                press: () {
                                    if (isPlaying == true){
                                      FlutterTts().stop();
                                      isPlaying = false;
                                      setState(() {
                                        string = 'Play';
                                      });
                                    }
                                    else if (isPlaying == false) {
                                      setState(() {
                                        string = 'loading';
                                      });
                                      isPlaying = true;
                                      Future.delayed(Duration(seconds: 5), (){
                                        FlutterTts().speak('A Simple PDF File. This is a small demonstration .pdf file -  just for use in the Virtual Mechanics tutorials. More text. And more  text. And more text. And more text. And more text.  And more text. And more text. And more text. And more text. And moretext. And more text. Boring, zzzzz. And more text. And more text. And more text. And more text. And more text. And more text. And more text.And more text. And more text.And more text. And more text. And more text. And more text. And moretext. And more text. And more text. Even more. Continued on page 2 ...').whenComplete((){
                                          setState(() {
                                            string = 'Play';
                                          });
                                        });
                                        setState(() {
                                          string = 'stop';
                                        });
                                      });
                                    }
                                },
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Image.asset(
              "assets/images/book-2.png",
              width: size.width * .37,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SizedBox(
              height: 40,
              width: size.width * .3,
              child: TwoSideRoundedButton(
                text: "Read",
                radius: 24,
                press: () {
                  if (url != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PdfViewPage())
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
