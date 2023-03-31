import 'package:englishapp/screens/result_screen.dart';
import 'package:englishapp/utils/hive_method.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:englishapp/utils/colors.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';

class LearningScreen extends StatefulWidget {
  final snap;
  final wordlist;
  const LearningScreen({Key? key, required this.snap, required this.wordlist})
      : super(key: key);

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  static const iosChannel = MethodChannel('ios');
  List voiceNames = [
    "Samantha",
    // "Fred",
    // "Kathy",
    // "Ralph",
  ];
  int voiceNo = 0;
  int voiceNum = 0;
  int page = 0;
  bool showAnswer = false;
  String language = "en-US";
  bool firstBuild = true;
  FlutterTts tts = FlutterTts();

  int myAnswer = 0;
  String a = "";
  bool isLoading = true;
  Box boxMyanswer = Hive.box('myanswer');
  Box boxWords = Hive.box('words');
  List meanings = [];
  void sendPageView() {
    FirebaseAnalytics.instance.logEvent(
      name: 'screen_view',
      parameters: {
        'firebase_screen': widget.snap['title'],
        'firebase_screen_class': "LearningScreen",
      },
    );
  }

  @override
  void initState() {
    super.initState();
    changeVoice();
    getMyAnswer();
    sendPageView();
  }

  changeVoice() async {
    List voices = await tts.getVoices;
    voices = voices.where((map) => map['locale'] == language).toList();
    voices = voices.where((map) => voiceNames.contains(map['name'])).toList();
    // print(voice);
    if (voices.isNotEmpty) {
      tts.setVoice({"locale": language, "name": "Samantha"});
    }
    //Samantha,Ralph,Kathy,Fred
  }

  Future getMyAnswer() async {
    setState(() {
      isLoading = true;
    });
    // final row = await dbHelper.insertAnswer('time', 1);
    // final row = await dbHelper.queryGetMyAnswer('time');
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    tts.setLanguage(language);

    String word = widget.wordlist[page]!;
    if (firstBuild) {
      final arguments = {'name': word};
      iosChannel.invokeMethod('getDictionary', arguments);
      Future.delayed(const Duration(milliseconds: 450))
          .then((_) => _speak(word));
    }
    setState(() {
      firstBuild = false;
    });
    // tts.setPitch(1.0);
    // tts.setSpeechRate(0.5);

    // tts.setSpeechRate(0.5);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
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
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: isLoading
            ? Container()
            : !showAnswer
                ? Container(
                    padding: const EdgeInsets.all(24),
                    color: Colors.white,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            _speak(word);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 60),
                            width: double.infinity,
                            child: const Icon(
                              Icons.volume_up,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          '${page + 1} / ${widget.wordlist.length}',
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(
                          height: 80,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: TextButton(
                              onPressed: () async {
                                // boxMyanswer.put(word, 2);
                                // if (page + 1 == widget.wordlist.length) {
                                //   await Navigator.of(context)
                                //       .push(MaterialPageRoute(
                                //     builder: (context) => ResultScreen(
                                //         snap: widget.snap,
                                //         wordlist: widget.wordlist),
                                //   ));
                                // } else {
                                //   setState(() {
                                //     firstBuild = true;
                                //     page = page + 1;
                                //   });
                                // }
                                iosChannel.invokeMethod('showDictionary');
                                setState(() {
                                  boxMyanswer.put(word, 2);
                                  // print(boxWords.get(word));
                                  // meanings = boxWords.get(word)["meaning"];
                                  showAnswer = true;
                                });
                              },
                              child: const Text(
                                'I know !',
                                style: TextStyle(fontSize: 20),
                              ),
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: primaryColor)),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: TextButton(
                              onPressed: () {
                                iosChannel.invokeMethod('showDictionary');
                                setState(() {
                                  boxMyanswer.put(word, 1);
                                  // print(boxWords.get(word));
                                  // meanings = boxWords.get(word)["meaning"];
                                  showAnswer = true;
                                });
                              },
                              child: const Text(
                                "not sure...",
                                style: TextStyle(fontSize: 20),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.grey, //色
                                  width: 2, //太さ
                                ),
                              )),
                        ),
                        const SizedBox(
                          height: 200,
                        ),
                      ],
                    ),
                  )
                : Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: const EdgeInsets.all(24),
                    child: SizedBox(
                      height: 180,
                      child: Column(children: [
                        // const SizedBox(
                        //   height: 12,
                        // ),
                        // Text(
                        //   '${page + 1} / ${widget.wordlist.length}',
                        //   style: const TextStyle(fontSize: 24),
                        // ),
                        // const SizedBox(
                        //   height: 24,
                        // ),
                        Container(
                          width: double.infinity,
                          alignment: Alignment.centerRight,
                          child: const Text(
                            "memorized",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // boxMyanswer.get(word).toString() == "2"
                              //     ? GestureDetector(
                              //         onTap: () {
                              //           setState(() {
                              //             boxMyanswer.put(word, 1);
                              //           });
                              //         },
                              //         child: const Icon(
                              //           Icons.star,
                              //           size: 40,
                              //           color: primaryColor,
                              //         ),
                              //       )
                              //     : GestureDetector(
                              //         onTap: () {
                              //           setState(() {
                              //             boxMyanswer.put(word, 2);
                              //           });
                              //         },
                              //         child: const Icon(
                              //           Icons.star_border_outlined,
                              //           size: 40,
                              //           color: primaryColor,
                              //         ),
                              //       ),
                              // Icon(
                              //   Icons.search_rounded,
                              //   size: 40,
                              //   color: Colors.grey,
                              // ),
                              const SizedBox(
                                width: 8,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  _speak(word);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      word,
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 32),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    const Icon(
                                      Icons.volume_up,
                                      size: 36,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              boxMyanswer.get(word).toString() == "2"
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          boxMyanswer.put(word, 1);
                                        });
                                      },
                                      child: const Icon(
                                        Icons.check_box,
                                        size: 32,
                                        color: primaryColor,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          boxMyanswer.put(word, 2);
                                        });
                                      },
                                      child: const Icon(
                                        Icons.check_box_outline_blank,
                                        size: 32,
                                        color: primaryColor,
                                      ),
                                    ),
                              // Spacer(),
                            ],
                          ),
                        ),
                        // const SizedBox(
                        //   height: 40,
                        // ),
                        // Container(
                        //   width: double.infinity,
                        //   height: 60,
                        //   child: TextButton(
                        //       onPressed: () async {
                        //         if (page + 1 == widget.wordlist.length) {
                        //           await Navigator.of(context)
                        //               .push(MaterialPageRoute(
                        //             builder: (context) => ResultScreen(
                        //                 snap: widget.snap,
                        //                 wordlist: widget.wordlist),
                        //           ));
                        //         } else {
                        //           setState(() {
                        //             showAnswer = false;
                        //             setState(() {
                        //               firstBuild = true;
                        //               page = page + 1;
                        //             });
                        //           });
                        //         }
                        //       },
                        //       child: const Text(
                        //         'Next',
                        //         style: TextStyle(fontSize: 28),
                        //       ),
                        //       style: TextButton.styleFrom(
                        //           backgroundColor: primaryColor,
                        //           primary: Colors.white)),
                        // ),
                        const SizedBox(
                          height: 20,
                        ),
                        // ListView.builder(
                        //     shrinkWrap: true,
                        //     physics: const ClampingScrollPhysics(),
                        //     padding: const EdgeInsets.all(8),
                        //     itemCount: meanings.length, //List(List名).length
                        //     itemBuilder: (BuildContext context, int index) {
                        //       return Padding(
                        //         padding: const EdgeInsets.only(bottom: 16),
                        //         child: WordCard(
                        //           meaning: meanings[index],
                        //         ),
                        //       );
                        //     }),
                        // const SizedBox(
                        //   height: 40,
                        // ),

                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: TextButton(
                              onPressed: () async {
                                var ans =
                                    int.parse(boxMyanswer.get(word).toString());
                                await HiveMethods().setReview(word, ans);
                                iosChannel.invokeMethod('removeDictionary');
                                if (page + 1 == widget.wordlist.length) {
                                  await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                    builder: (context) => ResultScreen(
                                        snap: widget.snap,
                                        wordlist: widget.wordlist),
                                  ));
                                } else {
                                  setState(() {
                                    showAnswer = false;
                                    setState(() {
                                      firstBuild = true;
                                      page = page + 1;
                                    });
                                  });
                                }
                              },
                              child: const Text(
                                'Next',
                                style: TextStyle(fontSize: 20),
                              ),
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: primaryColor)),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        // Container(
                        //   width: double.infinity,
                        //   height: 60,
                        //   child: TextButton(
                        //     onPressed: () {
                        //       iosChannel.invokeMethod('removeDictionary');
                        //       Navigator.of(context).push(
                        //         MaterialPageRoute(
                        //           builder: (context) => ResultScreen(
                        //               snap: widget.snap,
                        //               wordlist: widget.wordlist
                        //                   .take(page + 1)
                        //                   .toList()),
                        //         ),
                        //       );
                        //     },
                        //     style: TextButton.styleFrom(
                        //       backgroundColor: Colors.white,
                        //       primary: Colors.black,
                        //       side: const BorderSide(
                        //         color: Colors.grey, //色
                        //         width: 2, //太さ
                        //       ),
                        //     ),
                        //     child: const Text(
                        //       "Quit",
                        //       style: TextStyle(fontSize: 28),
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 24,
                        )
                      ]),
                    ),
                  ),
      ),
    );
  }

  _speak(String word) async {
    // await changeVoice();
    tts.speak(word);
    // voiceNum = voiceNum + 1;
  }

  // Future getBatteryLevel(word) async {
  //   // iOSのメソッドに受けわたす引数
  //   final arguments = {'word': word};
  //   // バッテリーの残量を取得
  //   final String newBateryLevel =
  //       await iosChannel.invokeMethod('getDictionary', arguments);
  //   // 画面を再描画する
  //   setState(() {});
  // }
}
