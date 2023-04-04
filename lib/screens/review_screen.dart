import 'package:englishapp/screens/learning_screen.dart';
import 'package:englishapp/utils/hive_method.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:englishapp/utils/colors.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:englishapp/main.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

FlutterTts tts = FlutterTts();

class _ReviewScreenState extends State<ReviewScreen> with RouteAware {
  List reviewList = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    getMyReview();
  }

  @override
  void initState() {
    super.initState();
    getMyReview();
    sendPageView();
  }

  Future getMyReview() async {
    var li = await HiveMethods().getReview();
    setState(() {
      reviewList = li;
    });
  }

  void sendPageView() {
    FirebaseAnalytics.instance.logEvent(
      name: 'screen_view',
      parameters: {
        'firebase_screen': 'review',
        'firebase_screen_class': "ReviewScreen",
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Review"),
      //   foregroundColor: Colors.black,
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   iconTheme: const IconThemeData(color: Colors.black),
      // ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Review",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
          const SizedBox(
            height: 4,
          ),
          const Text(
              'You can review words that you learned at an appropriate time',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
          const SizedBox(
            height: 120,
          ),
          Text("${reviewList.length} words ",
              style:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.w500)),
          const SizedBox(
            height: 8,
          ),
          const Text("is waiting for your review",
              style: TextStyle(fontSize: 16)),
          const SizedBox(
            height: 32,
          ),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton(
                onPressed: () {
                  // var word = "apple";

                  var item = {};
                  item['title'] = "Review";
                  item['index'] = "";
                  item["video_title"] = "";
                  item["review"] = true;
                  if (reviewList.isNotEmpty) {
                    if (reviewList.length > 10) {
                      reviewList = reviewList.take(10).toList();
                    }
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LearningScreen(
                        snap: item,
                        wordlist: reviewList,
                        isQuizMode: false,
                      ),
                    ));
                  }
                },
                child: const Text(
                  'start',
                  style: TextStyle(fontSize: 20),
                ),
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: primaryColor)),
          )
        ]),
      ),
    );
  }
}
