import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englishapp/routes/ItemScreenArg.dart';
import 'package:englishapp/utils/colors.dart';
import 'package:englishapp/utils/hive_method.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class MyStudyScreen extends StatefulWidget {
  MyStudyScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<MyStudyScreen> createState() => _MyStudyScreenState();
}

class _MyStudyScreenState extends State<MyStudyScreen> {
  var snapshot;
  var videoList;
  var isLoading = true;
  var videoKind = "all";
  var searchText = "";
  var isFirst = false;
  var lang = "en";
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    getLanguage();
    _searchController.clear();
    getVideoList();
    super.initState();
    _searchController.addListener(() {
      _controllerText();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void getVideoList() async {
    Map mystudyId = await HiveMethods().getMyStudy();
    setState(() {
      isLoading = true;
    });
    var li = await FirebaseFirestore.instance
        .collection('titles')
        .orderBy('date', descending: true)
        .where('valid', isEqualTo: 1)
        .get();

    var tmp = [];
    for (var i in li.docs) {
      if (mystudyId[i['id']] != null) {
        tmp.add(i);
      }
    }
    // if (tmp.length > 1) {
    tmp.sort((a, b) => -mystudyId[a['id']].compareTo(mystudyId[b['id']]));
    // }
    setState(() {
      snapshot = tmp;
      videoList = tmp;
      isLoading = false;
    });
  }

  void selectVideoKind() {
    var li = [];
    if (videoKind == "show") {
      for (var i in snapshot) {
        if (i.data()['type'] == "show") {
          li.add(i);
        }
      }
    } else if (videoKind == "movie") {
      for (var i in snapshot) {
        if (i.data()['type'] == "movie") {
          li.add(i);
        }
      }
    } else {
      li = snapshot;
    }
    setState(() {
      videoList = li;
    });
    // }
  }

  void _controllerText() {
    var li = [];
    if (_searchController.text.isEmpty) {
      li = snapshot;
    } else {
      for (var i in snapshot) {
        if (i.data()['title'].contains(_searchController.text) ||
            i.data()['title'].toLowerCase().contains(_searchController.text)) {
          li.add(i);
        }
      }
    }
    setState(() {
      videoList = li;
    });
  }

  judgeIsFirst() {}

  getLanguage() async {
    String tmp = await HiveMethods().getLanguage();
    setState(() {
      lang = tmp;
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width * 0.01;
    var h = MediaQuery.of(context).size.height * 0.01;

    Locale locale = Localizations.localeOf(context);
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   //     // toolbarHeight: 120,
      //   elevation: 1,
      //   backgroundColor: Colors.white,
      //   title: TextFormField(
      //     controller: _searchController,
      //     // onChanged: _controllerText,
      //     decoration: InputDecoration(
      //       // contentPadding: EdgeInsets.symmetric(vertical: 8.0),
      //       hintText: 'search movies & tv shows',
      //       contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
      //       fillColor: Colors.grey[100],
      //       filled: true,
      //       isDense: true,
      //       prefixIcon: const Icon(
      //         Icons.search,
      //         color: Colors.grey,
      //       ),
      //       border: OutlineInputBorder(
      //         borderRadius: BorderRadius.circular(8),
      //         borderSide: BorderSide.none,
      //       ),
      //     ),
      //   ),
      // ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: primaryColor,
            ))
          : SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Form(
                  //   child: Column(
                  //     children: [
                  //       const SizedBox(
                  //         height: 12,
                  //       ),
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 24),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //           children: [
                  //             SizedBox(
                  //               width: w * 50,
                  //               child: DropdownButton(
                  //                 isExpanded: true,
                  //                 value: videoKind,
                  //                 items: const [
                  //                   DropdownMenuItem(
                  //                     child: Text('TV show & Movie'),
                  //                     value: "all",
                  //                   ),
                  //                   DropdownMenuItem(
                  //                     child: Text('TV show'),
                  //                     value: "show",
                  //                   ),
                  //                   DropdownMenuItem(
                  //                     child: Text('Movie'),
                  //                     value: "movie",
                  //                   )
                  //                 ],
                  //                 onChanged: (String? value) {
                  //                   setState(() {
                  //                     videoKind = value!;
                  //                   });
                  //                   selectVideoKind();
                  //                 },
                  //               ),
                  //             ),
                  //             const Spacer()
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: h * 4,
                  ),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24.0, vertical: 0),
                    child: Text(
                      'My Learning',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                  ),
                  videoList.length == 0
                      ? Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: SizedBox(
                              height: h * 20,
                              child: const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'There is no video yet',
                                  style: TextStyle(
                                      fontSize: 24, color: Colors.grey),
                                ),
                              )),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            // itemCount: 9,
                            itemCount: videoList.length,
                            itemBuilder: (context, index) {
                              return _videoItem(snapshot: videoList[index]);
                            },
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 0.58,
                            ),
                          ),
                        ),
                  videoList.length == 0
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/tmdb.png',
                                height: 32,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              const Flexible(
                                child: Text(
                                    "This product uses the TMDB API but is not endorsed or certified by TMDB."),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
    );
  }

  Widget _videoItem({required snapshot}) {
    Locale locale = Localizations.localeOf(context);
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: () async {
          await FirebaseAnalytics.instance.logEvent(
              name: "tap_video_item",
              parameters: <String, Object>{
                "title": snapshot['id'],
                "content_type": snapshot['type']
              });
          Navigator.pushNamed(
            context,
            '/item',
            arguments: ItemScreenArguments(snap: snapshot),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6.0),
              child: AspectRatio(
                aspectRatio: 0.68,
                child: snapshot['img'].isEmpty
                    ? Container(
                        // color: Color.fromARGB(255, 200, 200, 200),
                        color: Colors.amber[200],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                snapshot['title'],
                                overflow: TextOverflow.clip,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                    : CachedNetworkImage(
                        imageUrl: "https://image.tmdb.org/t/p/w300/" +
                            snapshot['img'] +
                            ".jpg"),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  snapshot['title'],
                  overflow: TextOverflow.fade,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
