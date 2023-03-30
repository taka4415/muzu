import 'package:englishapp/utils/colors.dart';
import 'package:englishapp/utils/hive_method.dart';
import 'package:englishapp/widgets/word_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ResultScreen extends StatefulWidget {
  final snap;
  final wordlist;

  const ResultScreen({Key? key, required this.snap, required this.wordlist})
      : super(key: key);

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  String language = "en-US";
  FlutterTts tts = FlutterTts();

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

  @override
  void initState() {
    super.initState();
    calAnswerState();
  }

  @override
  Widget build(BuildContext context) {
    var _barWidth = MediaQuery.of(context).size.width - 48;

    return Scaffold(
      body: SingleChildScrollView(
        // color: Colors.white,
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    widget.snap['video_title'],
                    style: const TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  Text(
                    "${widget.snap['index']}. ${widget.snap['title']}",
                    style: const TextStyle(fontSize: 26, color: Colors.black),
                  ),
                  const SizedBox(height: 24),

                  // Text("Today's learning",
                  //     style: TextStyle(fontSize: 22, color: Colors.black)),
                  // Text("10 words",
                  //     style: TextStyle(fontSize: 40, color: Colors.black)),
                  const Text("Great!!!",
                      style: TextStyle(fontSize: 48, color: primaryColor)),
                  widget.snap['review']
                      ? Container()
                      : const SizedBox(
                          height: 60,
                        ),

                  widget.snap['review']
                      ? Container()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${done.toStringAsFixed(1)}% done',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'total:$totalWords words',
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
                              width: _barWidth * listMemed.length / totalWords,
                            ),
                            // Container(
                            //   color: Colors.grey,
                            //   height: 28,
                            //   width: 70,
                            // ),
                            Container(
                              color: Colors.grey[400],
                              height: 28,
                              width: _barWidth * listLearn.length / totalWords,
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
                      : const SizedBox(
                          height: 24,
                        ),
                  widget.snap['review']
                      ? Container()
                      : Row(
                          children: [
                            Container(
                              color: primaryColor,
                              height: 28,
                              width: 28,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            const Text(
                              'memorized',
                              style: TextStyle(fontSize: 22),
                            ),
                            const Spacer(),
                            Text("${listMemed.length} words",
                                style: const TextStyle(fontSize: 22))
                          ],
                        ),
                  widget.snap['review']
                      ? Container()
                      : const SizedBox(
                          height: 18,
                        ),
                  // Row(
                  //   children: [
                  //     Container(
                  //       color: Colors.grey,
                  //       height: 28,
                  //       width: 28,
                  //     ),
                  //     SizedBox(
                  //       width: 12,
                  //     ),
                  //     Text(
                  //       'not sure',
                  //       style: TextStyle(fontSize: 22),
                  //     ),
                  //     Spacer(),
                  //     Text("70 words", style: TextStyle(fontSize: 22))
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 18,
                  // ),
                  widget.snap['review']
                      ? Container()
                      : Row(
                          children: [
                            Container(
                              color: Colors.grey[300],
                              height: 28,
                              width: 28,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            const Text(
                              "learning",
                              style: TextStyle(fontSize: 22),
                            ),
                            const Spacer(),
                            Text("${listLearn.length} words",
                                style: const TextStyle(fontSize: 22))
                          ],
                        ),
                  widget.snap['review']
                      ? Container()
                      : const SizedBox(
                          height: 18,
                        ),
                  widget.snap['review']
                      ? Container()
                      : Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey)),
                              height: 28,
                              width: 28,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            const Text(
                              "unanswered",
                              style: TextStyle(fontSize: 22),
                            ),
                            const Spacer(),
                            Text("${listUnans.length} words",
                                style: const TextStyle(fontSize: 22))
                          ],
                        ),
                ],
              ),
            ),
            const SizedBox(
              height: 80,
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
                      Navigator.popUntil(
                          context, ModalRoute.withName("/memorize"));
                    }
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: primaryColor)),
            ),
            const SizedBox(
              height: 24,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              height: 50,
              child: TextButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text(
                    "Quit",
                    style: TextStyle(fontSize: 20),
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
            const SizedBox(
              height: 40,
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
              child: const Text(
                "memorized",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
    );
  }
}
