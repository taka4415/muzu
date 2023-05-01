import 'package:audioplayers/audioplayers.dart';
import 'package:englishapp/utils/colors.dart';
import 'package:englishapp/utils/hive_method.dart';
import 'package:englishapp/widgets/word_tile.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ResultScreen extends StatefulWidget {
  final snap;
  final wordlist;
  final rightAnswer;

  const ResultScreen(
      {Key? key,
      required this.snap,
      required this.wordlist,
      required this.rightAnswer})
      : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final _player = AudioPlayer();
  String language = "en-US";
  FlutterTts tts = FlutterTts();
  String lang = "en";
  int totalWords = 300;
  double done = 0;
  List listUnans = ["apple"];
  List listLearn = ["orange"];
  List listMemed = ["banana"];

  Box boxTitleWords = Hive.box('title_words');
  Box boxMyanswer = Hive.box('myanswer');

  Future<void> calAnswerState() async {
    List liAns = [];
    List liLea = [];
    List liMem = [];
    List wordli = [];
    if (widget.snap['review'] == true) {
      wordli = await HiveMethods().getReview();
    } else {
      wordli = await boxTitleWords.get(widget.snap['id']);
      for (String word in wordli) {
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
    }

    setState(() {
      listUnans = liAns;
      listLearn = liLea;
      listMemed = liMem;
      totalWords = wordli.length;
      double a = listMemed.length / totalWords * 1000;
      if (listMemed.isEmpty) {
        done = 0;
      } else {
        done = a.floor() * 0.1;
      }
    });
  }

  getLanguage() async {
    String tmp = await HiveMethods().getLanguage();
    setState(() {
      lang = tmp;
    });
  }

  @override
  void initState() {
    super.initState();
    calAnswerState();
    getLanguage();
    sendPageView();
    _player.play(AssetSource("sounds/result.mp3"));
  }

  void sendPageView() {
    FirebaseAnalytics.instance.logEvent(
      name: 'screen_view',
      parameters: {
        'firebase_screen': widget.snap['title'],
        'firebase_screen_class': "ResultScreen",
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var _barWidth = MediaQuery.of(context).size.width - 48;
    var w = MediaQuery.of(context).size.width * 0.01;
    var h = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      body: SingleChildScrollView(
        // color: Colors.white,
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: h * 2,
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Text(
                      widget.snap['videoInfo']['title'] ??
                          widget.snap['videoInfo']['name'] ??
                          widget.snap['video_title'],
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    Text(
                      "${widget.snap['index']}. ${widget.snap['title']}",
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    SizedBox(height: h * 6),

                    // Text("Today's learning",
                    //     style: TextStyle(fontSize: 22, color: Colors.black)),
                    // Text("10 words",
                    //     style: TextStyle(fontSize: 40, color: Colors.black)),
                    // const Text("Great!!!",
                    //     style: TextStyle(fontSize: 40, color: primaryColor)),
                    Text(
                      lang == "ja" ? "正解数" : "Score",
                      style: const TextStyle(fontSize: 24),
                    ),
                    Row(
                      textBaseline: TextBaseline.alphabetic,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      children: [
                        Text(
                          widget.rightAnswer.toString(),
                          style: const TextStyle(fontSize: 60),
                        ),
                        Text(
                          "/${widget.wordlist.length.toString()}",
                          style: const TextStyle(fontSize: 24),
                        )
                      ],
                    ),
                    Text(
                      widget.rightAnswer == widget.wordlist.length
                          ? "Perfect!!!"
                          : widget.rightAnswer / widget.wordlist.length > 0.8
                              ? "Great!!!"
                              : "Nice!!!",
                      style: const TextStyle(fontSize: 28, color: primaryColor),
                    ),
                    widget.snap['review']
                        ? Container()
                        : SizedBox(
                            height: h * 2,
                          ),

                    widget.snap['review']
                        ? Container()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lang == "ja"
                                    ? '${done.toStringAsFixed(1)}% 完了'
                                    : '${done.toStringAsFixed(1)}% done',
                                style: const TextStyle(fontSize: 16),
                              ),
                              Text(
                                lang == "ja"
                                    ? "合計:$totalWords words"
                                    : 'total:$totalWords words',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                    widget.snap['review']
                        ? Container()
                        : Row(
                            children: [
                              Container(
                                color: primaryColor,
                                height: 28,
                                width:
                                    _barWidth * listMemed.length / totalWords,
                              ),
                              // Container(
                              //   color: Colors.grey,
                              //   height: 28,
                              //   width: 70,
                              // ),
                              Container(
                                color: Colors.grey[400],
                                height: 28,
                                width:
                                    _barWidth * listLearn.length / totalWords,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)),
                                height: 28,
                                width: _barWidth *
                                    (totalWords -
                                        listMemed.length -
                                        listLearn.length) /
                                    totalWords,
                              ),
                            ],
                          ),
                    widget.snap['review']
                        ? Container()
                        : SizedBox(
                            height: h * 2,
                          ),
                    widget.snap['review']
                        ? Container()
                        : Row(
                            children: [
                              Container(
                                color: primaryColor,
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                lang == "ja" ? "学習済み" : 'memorized',
                                style: const TextStyle(fontSize: 20),
                              ),
                              const Spacer(),
                              Text("${listMemed.length} words",
                                  style: const TextStyle(fontSize: 20))
                            ],
                          ),
                    widget.snap['review']
                        ? Container()
                        : SizedBox(
                            height: h * 2,
                          ),

                    widget.snap['review']
                        ? Container()
                        : Row(
                            children: [
                              Container(
                                color: Colors.grey[300],
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                lang == "ja" ? "学習中" : "learning",
                                style: const TextStyle(fontSize: 20),
                              ),
                              const Spacer(),
                              Text("${listLearn.length} words",
                                  style: const TextStyle(fontSize: 20))
                            ],
                          ),
                    widget.snap['review']
                        ? Container()
                        : SizedBox(
                            height: h * 2,
                          ),
                    widget.snap['review']
                        ? Container()
                        : Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey)),
                                height: 24,
                                width: 24,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                lang == "ja" ? "未学習" : "unanswered",
                                style: const TextStyle(fontSize: 20),
                              ),
                              const Spacer(),
                              Text("${listUnans.length} words",
                                  style: const TextStyle(fontSize: 20))
                            ],
                          ),
                  ],
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                height: 50,
                child: TextButton(
                    onPressed: () {
                      if (widget.snap['review']) {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      } else {
                        // Navigator.popUntil(
                        //     context, ModalRoute.withName("/item"));
                        int count = 0;
                        Navigator.popUntil(context, (_) => count++ >= 3);
                      }
                    },
                    child: Text(
                      lang == "ja" ? "続ける" : 'Continue',
                      style: const TextStyle(fontSize: 20),
                    ),
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: primaryColor)),
              ),
              SizedBox(
                height: h * 2,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                height: 50,
                child: TextButton(
                    onPressed: () {
                      // Navigator.popUntil(context, (route) => route.isFirst);
                      int count = 0;
                      Navigator.popUntil(context, (_) => count++ >= 4);
                    },
                    child: Text(
                      lang == "ja" ? "やめる" : "Quit",
                      style: const TextStyle(fontSize: 20),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    )),
              ),
              SizedBox(
                height: h * 4,
              ),
              // Container(
              //   padding: EdgeInsets.all(8),
              //   child: const Text(
              //     'Result',
              //     style: TextStyle(fontSize: 28),
              //   ),
              // ),
              Container(
                padding: const EdgeInsets.only(right: 12),
                width: double.infinity,
                child: Text(
                  lang == "ja" ? "学習済み" : 'memorized',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w400),
                ),
                alignment: Alignment.centerRight,
              ),
              // Container(
              //   width: double.infinity,
              //   color: Colors.grey[200],
              //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              //   child: Text("Don't know!", style: TextStyle(fontSize: 20)),
              // ),
              ListView.builder(
                padding: const EdgeInsets.only(top: 0, left: 12, right: 12),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.wordlist.length,
                itemBuilder: (context, index) {
                  return WordTile(
                    word: widget.wordlist[index],
                  );
                  // return _listTile(wordList[index], _screenSize);
                },
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
