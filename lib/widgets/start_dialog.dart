import 'package:audioplayers/audioplayers.dart';
import 'package:englishapp/screens/word_list_screen.dart';
import 'package:englishapp/utils/colors.dart';
import 'package:englishapp/utils/hive_method.dart';
import 'package:englishapp/widgets/primary_button.dart';
import 'package:englishapp/widgets/secondary_button.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../screens/learning_screen.dart';

class StartDialog extends StatefulWidget {
  int index;
  dynamic item;
  StartDialog({super.key, required this.index, required this.item});

  @override
  State<StartDialog> createState() => _StartDialogState();
}

class _StartDialogState extends State<StartDialog> {
  int gameRule = 0;
  String lang = "en";
  List titleWordList = [];
  List listUnans = [];
  List listLearn = [];
  List listMemed = [];
  var unAnsweredChecked = true;
  var learningChecked = true;
  var memorizedChecked = false;

  Box boxTitleWords = Hive.box('title_words');
  Box boxMyanswer = Hive.box('myanswer');

  Future<void> calAnswerState() async {
    List liAns = [];
    List liLea = [];
    List liMem = [];

    List wordlist = await boxTitleWords.get(widget.item['id']);
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
    getLanguage();
    super.initState();
    calAnswerState();
  }

  getLanguage() async {
    String tmp = await HiveMethods().getLanguage();
    setState(() {
      lang = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _player = AudioPlayer();
    var w = MediaQuery.of(context).size.width * 0.01;
    var h = MediaQuery.of(context).size.height * 0.01;
    return Dialog(
      child: SizedBox(
        height: h * 64,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${widget.index + 1}.",
                      style: const TextStyle(fontSize: 24),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "${widget.item["title"]}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: h * 4,
                ),
                Text(lang == "ja" ? "出題形式" : "Quiz style"),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _player.stop();
                        _player.play(AssetSource("sounds/switch5.mp3"));
                        setState(() {
                          gameRule = (gameRule - 1) % 3;
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            '▲',
                            style: TextStyle(fontSize: 24, color: primaryColor),
                          ),
                        ),
                      ),
                    ),
                    gameRule == 0
                        ? Text(
                            lang == "ja"
                                ? '英語 ⇒ 日本語'
                                : lang == "es"
                                    ? "Inglés ⇒ Español"
                                    : lang == "fr"
                                        ? "Anglais ⇒ Français"
                                        : lang == "ar"
                                            ? "إنجليزي ⇦ عربي"
                                            : "English → English",
                            style: const TextStyle(fontSize: 18))
                        : gameRule == 1
                            ? Text(
                                lang == "ja"
                                    ? '日本語 ⇒ 英語'
                                    : lang == "es"
                                        ? "Español ⇒ Inglés"
                                        : lang == "fr"
                                            ? "Français ⇒ Anglais"
                                            : lang == "ar"
                                                ? "عربي ⇦ إنجليزي"
                                                : "English → English",
                                style: const TextStyle(fontSize: 18))
                            : Text(
                                lang == "ja"
                                    ? '英語 ⇒ 英語'
                                    : lang == "es"
                                        ? "Inglés ⇒ Inglés"
                                        : lang == "fr"
                                            ? "Anglais ⇒ Anglais"
                                            : lang == "ar"
                                                ? "إنجليزي ⇦ إنجليزي"
                                                : "English → English",
                                style: const TextStyle(fontSize: 18)),
                    GestureDetector(
                      onTap: () {
                        _player.stop();
                        _player.play(AssetSource("sounds/switch5.mp3"));
                        setState(() {
                          gameRule = (gameRule + 1) % 3;
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Text(
                            '▲',
                            style: TextStyle(fontSize: 24, color: primaryColor),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        activeColor: primaryColor,
                        value: unAnsweredChecked,
                        onChanged: (value) {
                          setState(() {
                            unAnsweredChecked = value!; // チェックボックスに渡す値を更新する
                          });
                        }),
                    lang == "ja"
                        ? const Text(
                            '未学習',
                            style: TextStyle(fontSize: 18),
                          )
                        : const Text(
                            'unanswered',
                            style: TextStyle(fontSize: 20),
                          ),
                    const Spacer(),
                    Text(
                      '${listUnans.length} words',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        activeColor: primaryColor,
                        value: learningChecked,
                        onChanged: (value) {
                          setState(() {
                            learningChecked = value!; // チェックボックスに渡す値を更新する
                          });
                        }),
                    lang == "ja"
                        ? const Text(
                            '学習中',
                            style: TextStyle(fontSize: 18),
                          )
                        : const Text(
                            "learning",
                            style: TextStyle(fontSize: 20),
                          ),
                    const Spacer(),
                    Text(
                      '${listLearn.length} words',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                        activeColor: primaryColor,
                        value: memorizedChecked,
                        onChanged: (value) {
                          setState(() {
                            memorizedChecked = value!; // チェックボックスに渡す値を更新する
                          });
                        }),
                    lang == "ja"
                        ? const Text(
                            '学習済み',
                            style: TextStyle(fontSize: 18),
                          )
                        : const Text(
                            "memorized",
                            style: TextStyle(fontSize: 20),
                          ),
                    const Spacer(),
                    Text(
                      '${listMemed.length} words',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(
                  height: h * 1,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                          text: lang == "ja" ? "クイズを始める" : "Start",
                          function: () async {
                            FirebaseAnalytics.instance.logEvent(
                                name: "tap_start",
                                parameters: <String, Object>{
                                  "title": widget.item['video_id'],
                                  "lesson_index": widget.item['index'],
                                  "episode": widget.item['id'],
                                  "content_type": widget.item['type']
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
                                snapwordlist = snapwordlist.take(10).toList();
                              }
                              for (var i in snapwordlist) {
                                titleWordList.remove(i);
                                titleWordList.add(i);
                              }
                              await boxTitleWords.put(
                                  widget.item['id'], titleWordList);
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => LearningScreen(
                                    snap: widget.item,
                                    gameRule: lang == "en" ? 2 : gameRule,
                                    wordlist: snapwordlist,
                                    isQuizMode: true),
                              ));
                            }
                          })),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: double.infinity,
                      child: SecondaryButton(
                          text: lang == "ja" ? "単語リスト" : "Word List",
                          function: () {
                            widget.item['words'] = titleWordList;
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    WordListScreen(snap: widget.item)));
                          })),
                )
              ]),
        ),
      ),
    );
  }
}
