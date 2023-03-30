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

  @override
  void initState() {
    super.initState();
    wordlist = widget.snap['words'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
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
      body: SingleChildScrollView(
        child: ListView.builder(
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
      ),
    );
  }
}
