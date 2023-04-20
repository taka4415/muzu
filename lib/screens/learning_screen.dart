import 'package:englishapp/screens/result_screen.dart';
import 'package:englishapp/utils/hive_method.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:englishapp/utils/colors.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class LearningScreen extends StatefulWidget {
  final snap;
  final wordlist;
  final bool isQuizMode;
  const LearningScreen(
      {Key? key,
      required this.snap,
      required this.wordlist,
      required this.isQuizMode})
      : super(key: key);

  @override
  State<LearningScreen> createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  final _player = AudioPlayer();
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
  List meanings = [
    {"meaning": ""},
    {"meaning": ""},
    {"meaning": ""},
    {"meaning": ""},
    {"meaning": ""},
  ];
  String answer_meaning = "";

  // void sendPageView() {
  //   FirebaseAnalytics.instance.logScreenView(
  //     screenName: 'learning',
  //     screenClass: '/learning',
  //   );
  // }

  @override
  void initState() {
    super.initState();
    changeVoice();
    getMyAnswer();
    // sendPageView();
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

  getQuiz(word) async {
    var _tmp = await HiveMethods().getQuiz(widget.snap['id'], word);

    setState(() {
      for (var i in _tmp) {
        if (i['word'] == word) {
          setState(() {
            answer_meaning = i['meaning'];
          });
        }
      }
      meanings = _tmp;
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
      setState(() {
        firstBuild = false;
      });
      if (widget.isQuizMode) {
        getQuiz(word);
      }
    }

    // tts.setPitch(1.0);
    // tts.setSpeechRate(0.5);

    // tts.setSpeechRate(0.5);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        title: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  if (showAnswer) {
                    iosChannel.invokeMethod('removeDictionary');
                  }
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Icon(Icons.arrow_back_ios),
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
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
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            width: double.infinity,
                            child: const Icon(
                              Icons.volume_up,
                              size: 60,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${page + 1} / ${widget.wordlist.length}',
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        widget.isQuizMode
                            ? Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    // height: 70,
                                    child: TextButton(
                                        onPressed: () async {
                                          if (meanings[0]['word'] == word) {
                                            await _player
                                                .play(AssetSource(
                                                    'sounds/right_answer.mp3'))
                                                .then((value) => null);
                                            Future.delayed(const Duration(
                                                    milliseconds: 1000))
                                                .then((_) => setState(() {
                                                      iosChannel.invokeMethod(
                                                          'showDictionary');
                                                      boxMyanswer.put(word, 2);
                                                      showAnswer = true;
                                                    }));
                                          } else {
                                            await _player
                                                .play(AssetSource(
                                                    'sounds/wrong_answer.mp3'))
                                                .then((value) => null);
                                            Future.delayed(const Duration(
                                                    milliseconds: 1000))
                                                .then((_) => setState(() {
                                                      iosChannel.invokeMethod(
                                                          'showDictionary');
                                                      boxMyanswer.put(word, 1);
                                                      showAnswer = true;
                                                    }));
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(meanings[0]['meaning'],
                                                style: const TextStyle(
                                                    fontSize: 16),
                                                textAlign: TextAlign.left),
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                            color: Colors.orange, //色
                                            width: 1, //太さ
                                          ),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    // height: 70,
                                    child: TextButton(
                                        onPressed: () async {
                                          if (meanings[1]['word'] == word) {
                                            await _player
                                                .play(AssetSource(
                                                    'sounds/right_answer.mp3'))
                                                .then((value) => null);
                                            Future.delayed(const Duration(
                                                    milliseconds: 1000))
                                                .then((_) => setState(() {
                                                      iosChannel.invokeMethod(
                                                          'showDictionary');
                                                      boxMyanswer.put(word, 2);
                                                      showAnswer = true;
                                                    }));
                                          } else {
                                            await _player
                                                .play(AssetSource(
                                                    'sounds/wrong_answer.mp3'))
                                                .then((value) => null);
                                            Future.delayed(const Duration(
                                                    milliseconds: 1000))
                                                .then((_) => setState(() {
                                                      iosChannel.invokeMethod(
                                                          'showDictionary');
                                                      boxMyanswer.put(word, 1);
                                                      showAnswer = true;
                                                    }));
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(meanings[1]['meaning'],
                                                style: const TextStyle(
                                                    fontSize: 16),
                                                textAlign: TextAlign.left),
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                            color: Colors.orange, //色
                                            width: 1, //太さ
                                          ),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    // height: 70,
                                    child: TextButton(
                                        onPressed: () async {
                                          if (meanings[2]['word'] == word) {
                                            await _player
                                                .play(AssetSource(
                                                    'sounds/right_answer.mp3'))
                                                .then((value) => null);
                                            Future.delayed(const Duration(
                                                    milliseconds: 1000))
                                                .then((_) => setState(() {
                                                      iosChannel.invokeMethod(
                                                          'showDictionary');
                                                      boxMyanswer.put(word, 2);
                                                      showAnswer = true;
                                                    }));
                                          } else {
                                            await _player
                                                .play(AssetSource(
                                                    'sounds/wrong_answer.mp3'))
                                                .then((value) => null);
                                            Future.delayed(const Duration(
                                                    milliseconds: 1000))
                                                .then((_) => setState(() {
                                                      iosChannel.invokeMethod(
                                                          'showDictionary');
                                                      boxMyanswer.put(word, 1);
                                                      showAnswer = true;
                                                    }));
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(meanings[2]['meaning'],
                                                style: const TextStyle(
                                                    fontSize: 16),
                                                textAlign: TextAlign.left),
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                            color: Colors.orange, //色
                                            width: 1, //太さ
                                          ),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    // height: 70,
                                    child: TextButton(
                                        onPressed: () async {
                                          if (meanings[3]['word'] == word) {
                                            await _player
                                                .play(AssetSource(
                                                    'sounds/right_answer.mp3'))
                                                .then((value) => null);
                                            Future.delayed(const Duration(
                                                    milliseconds: 1000))
                                                .then((_) => setState(() {
                                                      iosChannel.invokeMethod(
                                                          'showDictionary');
                                                      boxMyanswer.put(word, 2);
                                                      showAnswer = true;
                                                    }));
                                          } else {
                                            await _player
                                                .play(AssetSource(
                                                    'sounds/wrong_answer.mp3'))
                                                .then((value) => null);
                                            Future.delayed(const Duration(
                                                    milliseconds: 1000))
                                                .then((_) => setState(() {
                                                      iosChannel.invokeMethod(
                                                          'showDictionary');
                                                      boxMyanswer.put(word, 1);
                                                      showAnswer = true;
                                                    }));
                                          }
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(meanings[3]['meaning'],
                                                style: const TextStyle(
                                                    fontSize: 16),
                                                textAlign: TextAlign.left),
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                            color: Colors.orange, //色
                                            width: 1, //太さ
                                          ),
                                        )),
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    // height: 70,
                                    child: TextButton(
                                        onPressed: () async {
                                          if (meanings[4]['word'] == word) {
                                            await _player
                                                .play(AssetSource(
                                                    'sounds/right_answer.mp3'))
                                                .then((value) => null);
                                            Future.delayed(const Duration(
                                                    milliseconds: 1000))
                                                .then((_) => setState(() {
                                                      iosChannel.invokeMethod(
                                                          'showDictionary');
                                                      boxMyanswer.put(word, 2);
                                                      showAnswer = true;
                                                    }));
                                          } else {
                                            await _player
                                                .play(AssetSource(
                                                    'sounds/wrong_answer.mp3'))
                                                .then((value) => null);
                                            Future.delayed(const Duration(
                                                    milliseconds: 1000))
                                                .then((_) => setState(() {
                                                      iosChannel.invokeMethod(
                                                          'showDictionary');
                                                      boxMyanswer.put(word, 1);
                                                      showAnswer = true;
                                                    }));
                                          }
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text("None of the above",
                                                style: TextStyle(fontSize: 16),
                                                textAlign: TextAlign.left),
                                          ),
                                        ),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.black,
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                            color: Colors.orange, //色
                                            width: 1, //太さ
                                          ),
                                        )),
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: 80,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: TextButton(
                                        onPressed: () async {
                                          iosChannel
                                              .invokeMethod('showDictionary');
                                          setState(() {
                                            boxMyanswer.put(word, 2);
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
                                ],
                              ),
                        const SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: TextButton(
                              onPressed: () {
                                iosChannel.invokeMethod('showDictionary');
                                setState(() {
                                  boxMyanswer.put(word, 1);
                                  showAnswer = true;
                                });
                              },
                              child: widget.isQuizMode
                                  ? const Text(
                                      "not sure... skip",
                                      style: TextStyle(fontSize: 20),
                                    )
                                  : const Text(
                                      "not sure",
                                      style: TextStyle(fontSize: 20),
                                    ),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                                backgroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.grey, //色
                                  width: 1, //太さ
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                    child: SizedBox(
                      // height: 180,
                      child: Column(children: [
                        Container(
                          width: double.infinity,
                          alignment: Alignment.centerRight,
                          child: const Text(
                            "memorized",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
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
                                          color: Colors.black, fontSize: 28),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    const Icon(
                                      Icons.volume_up,
                                      size: 28,
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
                          height: 8,
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
                        widget.isQuizMode
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  answer_meaning,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              )
                            : const SizedBox(
                                height: 40,
                              ),
                        const SizedBox(
                          height: 8,
                        ),
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
                        // const SizedBox(
                        //   height: 16,
                        // ),
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
                        // const SizedBox(
                        //   height: 24,
                        // )
                      ]),
                    ),
                  ),
      ),
    );
  }

  _speak(String word) async {
    await tts.setIosAudioCategory(IosTextToSpeechAudioCategory.playback,
        [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker]);
    tts.speak(word);
  }
}
