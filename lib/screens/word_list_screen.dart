import 'package:englishapp/utils/hive_method.dart';
import 'package:englishapp/widgets/word_tile.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class WordListScreen extends StatefulWidget {
  final snap;
  const WordListScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<WordListScreen> createState() => _WordListScreenState();
}

class _WordListScreenState extends State<WordListScreen> {
  Box boxTitleWords = Hive.box('title_words');
  List wordlist = [];
  String lang = "en";

  @override
  void initState() {
    super.initState();
    wordlist = widget.snap['words'];
    getLanguage();
  }

  getLanguage() async {
    String tmp = await HiveMethods().getLanguage();
    setState(() {
      lang = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        toolbarHeight: 60,
        automaticallyImplyLeading: false,
        title: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
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
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.only(right: 12),
              width: double.infinity,
              child: Text(
                lang == "ja" ? "学習済み" : 'memorized',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              alignment: Alignment.centerRight,
            ),
            ListView.builder(
              padding: const EdgeInsets.only(top: 0, left: 12, right: 12),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: wordlist.length,
              itemBuilder: (context, index) {
                return WordTile(
                  word: wordlist[index],
                );
                // return _listTile(wordList[index], _screenSize);
              },
            ),
          ],
        ),
      ),
    );
  }
}
