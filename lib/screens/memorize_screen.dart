import 'package:englishapp/screens/learning_screen.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:englishapp/utils/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:englishapp/main.dart';

class MemorizeScreen extends StatefulWidget {
  final snap;
  const MemorizeScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<MemorizeScreen> createState() => _MemorizeScreenState();
}

class _MemorizeScreenState extends State<MemorizeScreen> with RouteAware {
  // int totalWords = 0;
  List titleWordList = [];
  List listUnans = [];
  List listLearn = [];
  List listMemed = [];
  var unAnsweredChecked = true;
  // var dontKnowChecked = true;
  var learningChecked = true;
  var memorizedChecked = false;

  Box boxTitleWords = Hive.box('title_words');
  Box boxMyanswer = Hive.box('myanswer');

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
    calAnswerState();
  }

  void sendPageView() {
    FirebaseAnalytics.instance.logEvent(
      name: 'screen_view',
      parameters: {
        'firebase_screen': widget.snap['title'],
        'firebase_screen_class': "MemorizeScreen",
      },
    );
  }

  Future<void> calAnswerState() async {
    List liAns = [];
    List liLea = [];
    List liMem = [];

    List wordlist = await boxTitleWords.get(widget.snap['id']);
    for (String word in wordlist) {
      int ans = boxMyanswer.get(word);
      if (ans == 0) {
        liAns.add(word);
      }
      if (ans == 1) {
        liLea.add(word);
      }
      if (ans == 2) {
        liMem.add(word);
      }
    }
    setState(() {
      listUnans = liAns;
      listLearn = liLea;
      listMemed = liMem;
      titleWordList = wordlist;
    });
  }

  @override
  void initState() {
    super.initState();
    calAnswerState();
    sendPageView();
  }

  @override
  Widget build(BuildContext context) {
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.snap['video_title'],
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text('${widget.snap['index']}. ${widget.snap['title']}',
                  style: const TextStyle(color: Colors.black))
            ],
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 60,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   '1. Voulez-Vous Coucher Avec Moi?',
                  //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  // ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    width: double.infinity,
                    child: Text(
                      'total : ${titleWordList.length} words',
                      style: const TextStyle(fontSize: 18),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 18.0),
                    child: Text(
                      'Set question from :',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                activeColor: primaryColor,
                                value: unAnsweredChecked,
                                onChanged: (value) {
                                  setState(() {
                                    unAnsweredChecked =
                                        value!; // チェックボックスに渡す値を更新する
                                  });
                                }),
                            const Text(
                              'unanswered',
                              style: TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            Text(
                              '${listUnans.length} words',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              width: 24,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                activeColor: primaryColor,
                                value: learningChecked,
                                onChanged: (value) {
                                  setState(() {
                                    learningChecked =
                                        value!; // チェックボックスに渡す値を更新する
                                  });
                                }),
                            const Text(
                              "learning",
                              style: TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            Text(
                              '${listLearn.length} words',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              width: 24,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                                activeColor: primaryColor,
                                value: memorizedChecked,
                                onChanged: (value) {
                                  setState(() {
                                    memorizedChecked =
                                        value!; // チェックボックスに渡す値を更新する
                                  });
                                }),
                            const Text(
                              "memorized",
                              style: TextStyle(fontSize: 20),
                            ),
                            const Spacer(),
                            Text(
                              '${listMemed.length} words',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              width: 24,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: TextButton(
                              onPressed: () async {
                                analytics.logEvent(
                                    name: "tap_start",
                                    parameters: <String, Object>{
                                      "title": widget.snap['video_title'],
                                      "index": widget.snap['index'],
                                      "episode": widget.snap['title']
                                    });
                                List snapwordlist = List.from(titleWordList);
                                if (!unAnsweredChecked) {
                                  for (var i in listUnans) {
                                    snapwordlist.remove(i);
                                  }
                                }
                                if (!learningChecked) {
                                  for (var i in listLearn) {
                                    snapwordlist.remove(i);
                                  }
                                }
                                if (!memorizedChecked) {
                                  for (var i in listMemed) {
                                    snapwordlist.remove(i);
                                  }
                                }
                                if (snapwordlist.isNotEmpty) {
                                  if (snapwordlist.length > 10) {
                                    snapwordlist =
                                        snapwordlist.take(10).toList();
                                  }
                                  for (var i in snapwordlist) {
                                    titleWordList.remove(i);
                                    titleWordList.add(i);
                                  }
                                  await boxTitleWords.put(
                                      widget.snap['id'], titleWordList);
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LearningScreen(
                                        snap: widget.snap,
                                        wordlist: snapwordlist),
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
                        // Container(
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(10),
                        //     color: primaryColor,
                        //   ),
                        //   height: 60,
                        //   child: Container(
                        //     width: double.infinity,
                        //     child: const Text('start'),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 120,
            ),
          ],
        ),
      ),
    );
  }
}
