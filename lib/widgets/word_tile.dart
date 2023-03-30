import 'package:englishapp/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WordTile extends StatefulWidget {
  final word;

  const WordTile({Key? key, required this.word}) : super(key: key);

  @override
  State<WordTile> createState() => _WordTileState();
}

class _WordTileState extends State<WordTile> {
  FlutterTts tts = FlutterTts();
  _speak(String word) async {
    tts.speak(word);
  }

  @override
  Widget build(BuildContext context) {
    const iosChannel = MethodChannel('ios');
    Box boxMyanswer = Hive.box('myanswer');
    return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(width: 0.6, color: Colors.grey))),
        child: ListTile(
            onTap: () async {},
            visualDensity: const VisualDensity(vertical: 2),
            title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "${widget.word}",
                            style: const TextStyle(fontSize: 24),
                          ),
                          GestureDetector(
                            onTap: () {
                              _speak(widget.word);
                            },
                            child: const Icon(
                              Icons.volume_up,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      // Text(
                      //   "${widget.items["ja"]}",
                      // ),
                      // Text("aaa aaa aaa aaa"),
                      const SizedBox(
                        height: 4,
                      ),
                      // Row(
                      //   children: [
                      //     Container(
                      //       color: Color.fromARGB(255, 204, 204, 204),
                      //       padding: EdgeInsets.symmetric(
                      //           horizontal: 8, vertical: 1),
                      //       child: Text(
                      //         "類語",
                      //         style: TextStyle(
                      //           fontSize: 12,
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 8,
                      //     ),
                      //     Text(
                      //       'dissemble,act',
                      //       style: TextStyle(fontSize: 14),
                      //     )
                      //   ],
                      // ),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                  const Spacer(),
                  // Icon(
                  //   Icons.search,
                  //   color: Colors.grey,
                  //   size: 32,
                  // ),
                  GestureDetector(
                    onTap: () async {
                      final arguments = {'name': widget.word};
                      iosChannel.invokeMethod('modalDictionary', arguments);
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         MeaningScreen(word: widget.word),
                      //     fullscreenDialog: true,
                      //   ),
                      // );
                    },
                    child: const Icon(
                      Icons.search,
                      color: Color.fromARGB(255, 210, 210, 210),
                      size: 32,
                    ),
                  ),
                  const SizedBox(
                    width: 24,
                  ),
                  boxMyanswer.get(widget.word).toString() == "2"
                      ? GestureDetector(
                          onTap: () async {
                            setState(() {
                              boxMyanswer.put(widget.word, 1);
                            });
                          },
                          child: const Icon(
                            Icons.check_box,
                            color: primaryColor,
                            size: 32,
                          ),
                        )
                      : GestureDetector(
                          onTap: () async {
                            setState(() {
                              boxMyanswer.put(widget.word, 2);
                            });
                          },
                          child: const Icon(
                            Icons.check_box_outline_blank,
                            color: primaryColor,
                            size: 32,
                          ),
                        ),
                ])));
  }
}
