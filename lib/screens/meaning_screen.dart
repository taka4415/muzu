import 'package:flutter/material.dart';
import 'package:englishapp/utils/colors.dart';
import 'package:englishapp/widgets/word_card.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MeaningScreen extends StatefulWidget {
  final word;
  const MeaningScreen({Key? key, required this.word}) : super(key: key);

  @override
  State<MeaningScreen> createState() => _MeaningScreenState();
}

class _MeaningScreenState extends State<MeaningScreen> {
  var meanings = [];
  Box boxMyanswer = Hive.box('myanswer');
  Box boxWords = Hive.box('words');
  FlutterTts tts = FlutterTts();

  _speak(String word) async {
    tts.speak(word);
  }

  @override
  void initState() {
    meanings = boxWords.get(widget.word)['meaning'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var word = widget.word;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(24),
          child: Column(children: [
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.infinity,
              alignment: Alignment.centerRight,
              child: const Text(
                "memorized",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon(
                  //   Icons.search_rounded,
                  //   size: 40,
                  //   color: Colors.grey,
                  // ),
                  GestureDetector(
                    onTap: () async {
                      await tts.setIosAudioCategory(
                          IosTextToSpeechAudioCategory.playback, [
                        IosTextToSpeechAudioCategoryOptions.defaultToSpeaker
                      ]);
                      _speak(word);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          word,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 40),
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
                  boxMyanswer.get(word).toString() == "2"
                      ? GestureDetector(
                          onTap: () {
                            setState(() {
                              boxMyanswer.put(word, 1);
                            });
                          },
                          child: const Icon(
                            Icons.check_box,
                            size: 40,
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
                            size: 40,
                            color: primaryColor,
                          ),
                        ),
                  // Spacer(),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(8),
                itemCount: meanings.length, //List(List名).length
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: WordCard(
                      meaning: meanings[index],
                    ),
                  );
                }),
            const SizedBox(
              height: 24,
            )
          ]),
        ),
      ),
    );
  }
}
