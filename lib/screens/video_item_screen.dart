import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:englishapp/utils/api_method.dart';
import 'package:englishapp/utils/firestore_method.dart';
import 'package:englishapp/utils/hive_method.dart';
import 'package:englishapp/widgets/start_dialog.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class VideoItemScreen extends StatefulWidget {
  final snap;

  const VideoItemScreen({Key? key, required this.snap}) : super(key: key);

  @override
  State<VideoItemScreen> createState() => _VideoItemScreenState();
}

class _VideoItemScreenState extends State<VideoItemScreen> {
  List titleWordList = [];
  List listUnans = [];
  List listLearn = [];
  List listMemed = [];
  var unAnsweredChecked = true;
  // var dontKnowChecked = true;
  var learningChecked = true;
  var memorizedChecked = false;
  var seasons = 1;
  String lang = "en";
  int gameRule = 0;
  Map videoInfo = {
    "overview": "",
    "release_date": "",
    "first_air_date": "",
    "name": ""
  };
  Map<Object?, dynamic> episodes = {
    1: {"title": "part 1"}
  };

  @override
  void initState() {
    getLanguage();
    sortEpisode();
    super.initState();
    if (widget.snap['tmdb'].length > 0) {
      getMovieInfo();
    }
  }

  sortEpisode() {
    var eps = widget.snap['seasons'][seasons.toString()];
    eps =
        SplayTreeMap.from(eps, (a, b) => a.toString().compareTo(b.toString()));
    setState(() {
      episodes = eps;
    });
  }

  void getMovieInfo() async {
    var res = await ApiMethod()
        .getVideoInfo(widget.snap['tmdb'], widget.snap['type']);

    setState(() {
      videoInfo = res;
    });
  }

  getLanguage() async {
    String tmp = await HiveMethods().getLanguage();
    print(tmp);
    setState(() {
      lang = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var imageUrl = 'assets/images/sample.jpg';
    var w = MediaQuery.of(context).size.width * 0.01;
    var h = MediaQuery.of(context).size.height * 0.01;

    Locale locale = Localizations.localeOf(context);
    String languageCode = locale.languageCode;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: w * 40 * 1000 / 680,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: w * 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: AspectRatio(
                        aspectRatio: 0.68,
                        child: widget.snap['img'].isEmpty
                            ? Container(
                                // color: Color.fromARGB(255, 200, 200, 200),
                                color: Colors.amber[200],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        videoInfo['title'] ??
                                            widget.snap['title'],
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      languageCode == "ja"
                                          ? Text(
                                              widget.snap['jpn'],
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              )
                            : CachedNetworkImage(
                                imageUrl: "https://image.tmdb.org/t/p/w300/" +
                                    widget.snap['img'] +
                                    ".jpg"),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    width: w * 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   widget.snap['type'],
                        //   style: const TextStyle(fontSize: 20),
                        // ),
                        SizedBox(
                          height: h * 1,
                        ),
                        widget.snap['type'] == "movie"
                            ? Text(videoInfo['release_date'])
                            : Text(videoInfo['first_air_date']),
                        Text(
                          videoInfo['title'] ??
                              (videoInfo['name'] ?? widget.snap['title']),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),

                        SizedBox(
                          height: h * 1,
                        ),
                        Flexible(
                          child: SingleChildScrollView(
                            child: Text(
                              videoInfo['overview'],
                              style: const TextStyle(fontSize: 16),
                              overflow: TextOverflow.ellipsis,
                              maxLines: (w * 340 * 1000 / 680 / 30).floor(),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 24),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       widget.snap['type'] == "movie"
            //           ? Container()
            //           : DropdownButton(
            //               value: 1,
            //               items: const [
            //                 DropdownMenuItem(
            //                   child: Text('season 1'),
            //                   value: 1,
            //                 ),
            //                 DropdownMenuItem(
            //                   child: Text('season 2'),
            //                   value: 2,
            //                 ),
            //                 DropdownMenuItem(
            //                   child: Text('season 3'),
            //                   value: 3,
            //                 )
            //               ],
            //               onChanged: (int? value) {}),
            //       widget.snap['type'] == "movie"
            //           ? Container()
            //           : Text('${widget.snap['seasons'].length} seasons')
            //     ],
            //   ),
            // ),
            SizedBox(
              height: h * 8,
            ),
            // ignore: prefer_const_constructors
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                lang == "ja" ? "単語リスト" : "Vocaburary List",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                itemCount: widget.snap['seasons'][seasons.toString()].length,
                itemBuilder: (context, index) {
                  return _listTile(episodes.values.elementAt(index), index,
                      widget.snap, gameRule);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listTile(item, index, snap, gameRule) {
    var w = MediaQuery.of(context).size.width * 0.01;
    var h = MediaQuery.of(context).size.height * 0.01;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
          decoration: const BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(width: 0.6, color: Colors.grey))),
          child: ListTile(
              onTap: () async {
                FirebaseAnalytics.instance
                    .logEvent(name: "tap_episode", parameters: <String, Object>{
                  "title": snap['id'],
                  "lesson_index": index,
                  "episode": item["id"],
                  "content_type": snap['type']
                });
                await FirestoreMethods().getWords(id: item['id']);
                // await HiveMethods().setAnswers(words: item["words"]);
                item['video_id'] = snap['id'];
                item['video_title'] = snap['title'];
                item['index'] = index + 1;
                item['review'] = false;
                item['img'] = widget.snap['img'];
                item['videoInfo'] = videoInfo;
                item['type'] = widget.snap['type'];

                showDialog(
                  context: context,
                  builder: (_) {
                    gameRule == 0;
                    return StartDialog(
                      index: index,
                      item: item,
                    );
                  },
                );

                // Navigator.pushNamed(
                //   context,
                //   // '/start',
                //   '/memorize',
                //   arguments: ItemScreenArguments(snap: item),
                // );
              },
              visualDensity: const VisualDensity(vertical: -1),
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${index + 1}.",
                    ),
                    Container(
                      width: w * 50,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "${item["title"]}",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const Spacer(),
                    item['premium'] == '0'
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 2),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.orange),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'free',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.orange[300],
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        : item['premium'].toString() != '1'
                            ? Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: const Icon(
                                  Icons.lock_open,
                                  size: 24,
                                  color: Colors.white,
                                ),
                              )
                            : Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Icon(
                                  Icons.lock,
                                  size: 24,
                                  color: Colors.orange[300],
                                ),
                              )
                  ]))),
    );
  }
}
