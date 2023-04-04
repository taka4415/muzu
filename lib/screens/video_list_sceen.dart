import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englishapp/routes/ItemScreenArg.dart';
import 'package:englishapp/utils/colors.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class VideoListScreen extends StatefulWidget {
  const VideoListScreen({Key? key}) : super(key: key);

  @override
  State<VideoListScreen> createState() => _VideoListScreenState();
}

class _VideoListScreenState extends State<VideoListScreen> {
  var snapshot;
  var videoList;
  var isLoading = true;
  var videoKind = "all";
  var searchText = "";
  final TextEditingController _searchController = TextEditingController();
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  @override
  void initState() {
    _searchController.clear();
    getVideoList();
    super.initState();
    _searchController.addListener(() {
      _controllerText();
    });
    sendPageView();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void getVideoList() async {
    setState(() {
      isLoading = true;
    });
    var li = await FirebaseFirestore.instance
        .collection('titles')
        .orderBy('date', descending: true)
        .where('valid', isEqualTo: 1)
        .get();
    setState(() {
      snapshot = li.docs;
      videoList = li.docs;
      isLoading = false;
    });
  }

  void sendPageView() {
    FirebaseAnalytics.instance.logEvent(
      name: 'screen_view',
      parameters: {
        'firebase_screen': "top",
        'firebase_screen_class': "VideoListScreen",
      },
    );
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

  // void _controllerText(String e) {
  //   setState(() {
  //     searchText = e;
  //   });
  //   var li = [];
  //   if (searchText == "") {
  //     li = snapshot;
  //   } else {
  //     for (var i in snapshot) {
  //       if (i.data()['search'].contains(searchText)) {
  //         li.add(i);
  //       }
  //     }
  //   }
  //   setState(() {
  //     videoList = li;
  //   });
  // }
  void _controllerText() {
    var li = [];
    if (_searchController.text.isEmpty) {
      li = snapshot;
    } else {
      for (var i in snapshot) {
        if (i.data()['search'].contains(_searchController.text)) {
          li.add(i);
        }
      }
    }
    setState(() {
      videoList = li;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _screenSize = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: AppBar(
      //     // toolbarHeight: 120,
      //     elevation: 1,
      //     backgroundColor: Colors.white,
      //     title: Row(
      //       children: const [
      //         Text(
      //           "Muzu",
      //           style: TextStyle(color: Colors.black),
      //         ),
      //         Spacer(),
      //         // GestureDetector(
      //         //   onTap: () => Navigator.of(context).push(
      //         //     MaterialPageRoute(
      //         //       builder: (context) => const MyPageScreen(),
      //         //     ),
      //         //   ),
      //         //   child: const Icon(
      //         //     Icons.person,
      //         //     color: secondaryColor,
      //         //   ),
      //         // ),
      //       ],
      //     )),
      appBar: AppBar(
        //     // toolbarHeight: 120,
        elevation: 1,
        backgroundColor: Colors.white,
        title: TextFormField(
          controller: _searchController,
          // onChanged: _controllerText,
          decoration: InputDecoration(
            // contentPadding: EdgeInsets.symmetric(vertical: 8.0),
            hintText: 'search movies & tv shows',
            contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
            fillColor: Colors.grey[100],
            filled: true,
            isDense: true,
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: primaryColor,
            ))
          : SingleChildScrollView(
              physics: const ScrollPhysics(),
              child: Column(
                children: [
                  Form(
                    child: Column(
                      children: [
                        // TextFormField(
                        //   controller: _searchController,
                        //   // onChanged: _controllerText,
                        //   decoration: InputDecoration(
                        //     // contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                        //     hintText: 'search',
                        //     contentPadding:
                        //         const EdgeInsets.symmetric(vertical: 0.0),
                        //     fillColor: Colors.grey[100],
                        //     filled: true,
                        //     isDense: true,
                        //     prefixIcon: const Icon(
                        //       Icons.search,
                        //       color: Colors.grey,
                        //     ),
                        //     border: OutlineInputBorder(
                        //       borderRadius: BorderRadius.circular(8),
                        //       borderSide: BorderSide.none,
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: _screenSize.width * 0.50,
                                child: DropdownButton(
                                  isExpanded: true,
                                  value: videoKind,
                                  items: const [
                                    DropdownMenuItem(
                                      child: Text('TV show & Movie'),
                                      value: "all",
                                    ),
                                    DropdownMenuItem(
                                      child: Text('TV show'),
                                      value: "show",
                                    ),
                                    DropdownMenuItem(
                                      child: Text('Movie'),
                                      value: "movie",
                                    )
                                  ],
                                  onChanged: (String? value) {
                                    setState(() {
                                      videoKind = value!;
                                    });
                                    selectVideoKind();
                                  },
                                ),
                              ),
                              // Container(
                              //   width: _screenSize.width * 0.40,
                              //   child: DropdownButton(
                              //       isExpanded: true,
                              //       value: 1,
                              //       items: const [
                              //         DropdownMenuItem(
                              //           child: Text('category'),
                              //           value: 1,
                              //         ),
                              //         DropdownMenuItem(
                              //           child: Text('TV show'),
                              //           value: 2,
                              //         ),
                              //         DropdownMenuItem(
                              //           child: Text('Movie'),
                              //           value: 3,
                              //         )
                              //       ],
                              //       onChanged: (int? value) {}),
                              // ),
                              const Spacer()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child:
                        // child: FutureBuilder(
                        //     future: FirebaseFirestore.instance
                        //         .collection('titles')
                        //         .orderBy('date', descending: true)
                        //         .get(),
                        //     builder: (context, snapshot) {
                        // if (snapshot.connectionState == ConnectionState.waiting) {
                        //   return const Center(
                        //     child: CircularProgressIndicator(
                        //       color: primaryColor,
                        //     ),
                        //   );
                        // }
                        GridView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      // itemCount: 9,
                      itemCount: videoList.length,
                      itemBuilder: (context, index) {
                        // if (snapshot.connectionState ==
                        //     ConnectionState.waiting) {
                        //   return const Center(
                        //     child: CircularProgressIndicator(
                        //       color: primaryColor,
                        //     ),
                        //   );
                        // }
                        return _videoItem(snapshot: videoList[index]);
                      },
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.58,
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(6.0),
                  //   child: StaggeredGrid.count(
                  //     axisDirection: AxisDirection.down,
                  //     crossAxisCount: 3,
                  //     children: list,
                  //   ),
                  // ),

                  Padding(
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
    // var imageUrl = 'assets/images/sample.jpg';
    Locale locale = Localizations.localeOf(context);
    String languageCode = locale.languageCode;
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: GestureDetector(
        onTap: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => VideoItemScreen(),
          //   ),
          // ),
          analytics.logEvent(
              name: "tap_video_item",
              parameters: <String, Object>{"title": snapshot['title']});
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
                              languageCode == "ja"
                                  ? Text(
                                      snapshot['jpn'],
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      )
                    // : Image.network("https://image.tmdb.org/t/p/w300/" +
                    //     snapshot['img'] +
                    //     ".jpg"),
                    : CachedNetworkImage(
                        imageUrl: "https://image.tmdb.org/t/p/w300/" +
                            snapshot['img'] +
                            ".jpg"),
              ),
            ),
            // Row(
            //   children: [
            //     Text(
            //       snapshot['year'],
            //       style: const TextStyle(fontSize: 12),
            //     ),
            //     const Spacer(),
            //     Text(
            //       snapshot['type'] == "movie" ? "" : "",
            //       style: const TextStyle(fontSize: 12),
            //     ),
            //   ],
            // ),
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
