import 'package:englishapp/routes/ItemScreenArg.dart';
import 'package:englishapp/screens/word_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:englishapp/utils/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:englishapp/main.dart';

class StartScreen extends StatefulWidget {
  final snap;
  const StartScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with RouteAware {
  int totalWords = 0;
  int unAnsNum = 0;
  int learnNum = 0;
  int memedNum = 0;
  List listMemed = [];
  Box boxTitleWords = Hive.box('title_words');
  Box boxMyanswer = Hive.box('myanswer');
  Map<String, Map<String, Object>> review = {
    "apple": {"date": "2023-03-01 20:10:13.485095", "time": 1},
    "orange": {"date": "2023-02-01 20:10:13.485095", "time": 1},
    "mango": {"date": "2023-02-07 20:10:13.485095", "time": 1},
    "banana": {"date": "2023-03-05 20:10:13.485095", "time": 1},
    "grape": {"date": "2023-03-03 20:10:13.485095", "time": 1},
  };

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
      unAnsNum = liAns.length;
      learnNum = liLea.length;
      memedNum = liMem.length;
      totalWords = wordlist.length;
      listMemed = liMem;
    });
  }

  @override
  void initState() {
    super.initState();
    calAnswerState();
  }

  @override
  Widget build(BuildContext context) {
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
                style: const TextStyle(color: Colors.black, fontSize: 24),
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    width: double.infinity,
                    child: Text(
                      'total : $totalWords words',
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'unanswered',
                              style: TextStyle(fontSize: 24),
                            ),
                            const Spacer(),
                            Text(
                              '$unAnsNum words',
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(
                              width: 24,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "learning",
                              style: TextStyle(fontSize: 24),
                            ),
                            const Spacer(),
                            Text(
                              '$learnNum words',
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(
                              width: 24,
                            )
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "memorized",
                              style: TextStyle(fontSize: 24),
                            ),
                            const Spacer(),
                            Text(
                              '$memedNum words',
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(
                              width: 24,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/memorize',
                                    arguments:
                                        ItemScreenArguments(snap: widget.snap));
                              },
                              child: const Text(
                                'memorize',
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
                                widget.snap['words'] = listMemed;
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        WordListScreen(snap: widget.snap),
                                  ),
                                );
                              },
                              child: const Text(
                                "Memorized list",
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
            )
          ],
        ),
      ),
    );
  }
}
