import 'package:englishapp/screens/result_screen.dart';
import 'package:englishapp/utils/firestore_method.dart';
import 'package:englishapp/utils/hive_method.dart';
import 'package:flutter/material.dart';
import 'package:englishapp/utils/colors.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

class LearningScreen extends StatefulWidget {
  final gameRule;
  final snap;
  final wordlist;
  final bool isQuizMode;
  const LearningScreen(
      {Key? key,
      required this.snap,
      required this.wordlist,
      required this.isQuizMode,
      required this.gameRule})
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
  List selected = [false, false, false, false, false];
  bool hightAnswer = false;
  bool wordShow = false;
  int voiceNo = 0;
  String lang = "ja";
  int voiceNum = 0;
  int page = 0;
  bool showAnswer = false;
  String language = "en-US";
  bool firstBuild = true;
  FlutterTts tts = FlutterTts();
  int myAnswer = 0;
  String a = "";
  String nativeWord = "";
  bool isLoading = true;
  Box boxMyanswer = Hive.box('myanswer');
  Box boxWords = Hive.box('words');
  List meanings = [
    {"meaning": "", "ja": "", "word": "", "fr": "", "es": "", "ar": ""},
    {"meaning": "", "ja": "", "word": "", "fr": "", "es": "", "ar": ""},
    {"meaning": "", "ja": "", "word": "", "fr": "", "es": "", "ar": ""},
    {"meaning": "", "ja": "", "word": "", "fr": "", "es": "", "ar": ""},
    {"meaning": "", "ja": "", "word": "", "fr": "", "es": "", "ar": ""},
  ];
  String answerMeaning = "";
  int rightAnswer = 0;

  // void sendPageView() {
  //   FirebaseAnalytics.instance.logScreenView(
  //     screenName: 'learning',
  //     screenClass: '/learning',
  //   );
  // }

  @override
  void initState() {
    super.initState();
    getLanguage();
    changeVoice();
    // sendPageView();
  }

  getLanguage() async {
    String tmp = await HiveMethods().getLanguage();
    setState(() {
      lang = tmp;
    });
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

  getQuiz(word) async {
    var _tmp = await HiveMethods().getQuiz(widget.snap['id'], word);

    setState(() {
      for (var i in _tmp) {
        if (i['word'] == word) {
          setState(() {
            answerMeaning = i['meaning'];
            if (lang == "en") {
              nativeWord = i['word'];
            } else {
              nativeWord = i[lang];
            }
          });
        }
      }
      meanings = _tmp;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    tts.setLanguage(language);
    var w = MediaQuery.of(context).size.width * 0.01;
    var h = MediaQuery.of(context).size.height * 0.01;

    String word = widget.wordlist[page]!;

    if (firstBuild) {
      final arguments = {'name': word};
      iosChannel.invokeMethod('getDictionary', arguments);
      if (widget.gameRule == 0) {
        Future.delayed(const Duration(milliseconds: 450))
            .then((_) => _speak(word));
      } else if (widget.gameRule == 2) {
        Future.delayed(const Duration(milliseconds: 450))
            .then((_) => _speak(answerMeaning));
      }
      if (widget.isQuizMode) {
        getQuiz(word);
      }
      setState(() {
        firstBuild = false;
      });
    }

    // tts.setPitch(1.0);
    // tts.setSpeechRate(0.5);

    // tts.setSpeechRate(0.5);
    var optionText = "meaning";
    if (widget.gameRule == 0 && nativeWord != "en") {
      optionText = lang;
    }
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
                  // Navigator.popUntil(context, (route) => route.isFirst);
                  int count = 0;
                  Navigator.popUntil(context, (_) => count++ >= 2);
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
                    widget.snap['videoInfo']['title'] ??
                        widget.snap['videoInfo']['name'] ??
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
      body: isLoading
          ? Container()
          : !showAnswer
              ? Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 24),
                    child: Column(
                      children: [
                        Text(
                          '${page + 1} / ${widget.wordlist.length}',
                          style: const TextStyle(fontSize: 22),
                        ),
                        SizedBox(
                          height: h * 2,
                        ),
                        widget.gameRule == 0
                            ? Text(
                                wordShow ? word : "",
                                style: const TextStyle(fontSize: 36),
                              )
                            : widget.gameRule == 1
                                ? Text(
                                    nativeWord,
                                    style: const TextStyle(fontSize: 36),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Text(answerMeaning,
                                        style: const TextStyle(fontSize: 24)),
                                  ),
                        widget.gameRule == 0
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        wordShow = !wordShow;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                        wordShow
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off_outlined,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: w * 2,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _speak(word);
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Icon(
                                        Icons.volume_up,
                                        size: 40,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(
                          height: h * 4,
                        ),
                        widget.isQuizMode
                            ? Column(
                                children: <Widget>[
                                  for (var i = 0; i < meanings.length; i++)
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        // height: 70,
                                        child: TextButton(
                                            onPressed: () async {
                                              setState(() {
                                                selected[i] = true;
                                                hightAnswer = true;
                                              });
                                              if (meanings[i]['word'] == word) {
                                                rightAnswer += 1;
                                                await _player
                                                    .play(AssetSource(
                                                        'sounds/right_answer.mp3'))
                                                    .then((value) => null);
                                                Future.delayed(const Duration(
                                                        milliseconds: 1400))
                                                    .then((_) => setState(() {
                                                          iosChannel.invokeMethod(
                                                              'showDictionary');
                                                          boxMyanswer.put(
                                                              word, 2);
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
                                                          boxMyanswer.put(
                                                              word, 1);
                                                          showAnswer = true;
                                                        }));
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        i != 4
                                                            ? widget.gameRule ==
                                                                    0
                                                                ? meanings[i]
                                                                    [optionText]
                                                                : meanings[i]
                                                                    ['word']
                                                            : "Not Above",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: (meanings[i][
                                                                            'word'] ==
                                                                        word) &&
                                                                    hightAnswer
                                                                ? const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    52,
                                                                    152,
                                                                    55)
                                                                : (meanings[i]['word'] !=
                                                                            word) &&
                                                                        hightAnswer &&
                                                                        selected[
                                                                            i]
                                                                    ? Colors.red
                                                                    : Colors
                                                                        .black),
                                                        textAlign:
                                                            TextAlign.left),
                                                    const Spacer(),
                                                    (meanings[i]['word'] ==
                                                                word) &&
                                                            hightAnswer
                                                        ? const Icon(
                                                            Icons
                                                                .circle_outlined,
                                                            color: Colors.green,
                                                          )
                                                        : (meanings[i]['word'] !=
                                                                    word) &&
                                                                hightAnswer &&
                                                                selected[i]
                                                            ? const Icon(
                                                                Icons.clear,
                                                                color:
                                                                    Colors.red,
                                                              )
                                                            : Container(),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.black,
                                              backgroundColor: Colors.white,
                                              side: BorderSide(
                                                color: (meanings[i]['word'] ==
                                                            word) &&
                                                        hightAnswer
                                                    ? Colors.green
                                                    : (meanings[i]['word'] !=
                                                                word) &&
                                                            hightAnswer &&
                                                            selected[i]
                                                        ? Colors.red
                                                        : Colors.orange, //色
                                                width: 1, //太さ
                                              ),
                                            )),
                                      ),
                                    ),
                                ],
                              )
                            : Column(
                                children: [
                                  const SizedBox(
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
                      ],
                    ),
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
                        child: Text(
                          lang == "ja" ? "学習済み" : "memorized",
                          style: const TextStyle(
                            fontSize: 16,
                            // fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
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
                          ],
                        ),
                      ),
                      SizedBox(
                        height: h * 1,
                      ),
                      widget.isQuizMode
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.gameRule == 0
                                          ? nativeWord
                                          : widget.gameRule == 1
                                              ? word
                                              : answerMeaning,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  SizedBox(
                                    width: w * 2,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog<void>(
                                          context: context,
                                          builder: (_) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                AlertDialog(
                                                  title: Text(lang == "ja"
                                                      ? '単語のバグを報告'
                                                      : "Bug Report"),
                                                  content: Text(lang == "ja"
                                                      ? '単語のバグを報告しますか？'
                                                      : "Do you report bug of this word?"),
                                                  actions: <Widget>[
                                                    GestureDetector(
                                                      child: const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 4.0,
                                                                horizontal: 12),
                                                        child: Text('No'),
                                                      ),
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    GestureDetector(
                                                      child: const Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 4.0,
                                                                horizontal: 12),
                                                        child: Text('Yes'),
                                                      ),
                                                      onTap: () async {
                                                        await FirestoreMethods()
                                                            .reportBug(
                                                                word: word,
                                                                lang: lang,
                                                                gameRule: widget
                                                                    .gameRule);
                                                        Navigator.pop(context);
                                                        showDialog<void>(
                                                            context: context,
                                                            builder: (_) {
                                                              return Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  AlertDialog(
                                                                      title: Text(lang ==
                                                                              "ja"
                                                                          ? "送信完了"
                                                                          : "Report submitted"),
                                                                      content: Text(lang ==
                                                                              "ja"
                                                                          ? "ご協力ありがとうございます"
                                                                          : "Thank you for your contribution!"),
                                                                      actions: <
                                                                          Widget>[
                                                                        GestureDetector(
                                                                          child:
                                                                              const Padding(
                                                                            padding:
                                                                                EdgeInsets.symmetric(vertical: 4.0, horizontal: 12),
                                                                            child:
                                                                                Text('Close'),
                                                                          ),
                                                                          onTap:
                                                                              () {
                                                                            Navigator.pop(context);
                                                                          },
                                                                        ),
                                                                      ]),
                                                                ],
                                                              );
                                                            });
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ],
                                            );
                                          });
                                    },
                                    child: const Icon(
                                      Icons.report_gmailerrorred_outlined,
                                      color: Colors.grey,
                                    ),
                                  )
                                ],
                              ),
                            )
                          : const SizedBox(
                              height: 40,
                            ),
                      SizedBox(
                        height: h * 1,
                      ),
                      SizedBox(
                        width: double.infinity,
                        // height: h * 6,
                        child: TextButton(
                            onPressed: () async {
                              var ans =
                                  int.parse(boxMyanswer.get(word).toString());
                              await HiveMethods().setReview(word, ans);
                              iosChannel.invokeMethod('removeDictionary');
                              if (page + 1 == widget.wordlist.length) {
                                HiveMethods()
                                    .setMyStudy(widget.snap['video_id']);
                                await Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => ResultScreen(
                                    snap: widget.snap,
                                    wordlist: widget.wordlist,
                                    rightAnswer: rightAnswer,
                                  ),
                                ));
                              } else {
                                setState(() {
                                  isLoading = true;
                                  selected = [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false
                                  ];
                                  hightAnswer = false;
                                  page = page + 1;
                                  firstBuild = true;
                                  wordShow = false;
                                  showAnswer = false;
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
                    ]),
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
