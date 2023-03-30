// import 'package:audioplayers/audioplayers.dart';
// import 'package:englishapp/screens/result_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:englishapp/utils/colors.dart';
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:url_launcher/url_launcher.dart';

// class LearningScreen extends StatefulWidget {
//   const LearningScreen({Key? key}) : super(key: key);

//   @override
//   State<LearningScreen> createState() => _LearningScreenState();
// }

// class _LearningScreenState extends State<LearningScreen> {
//   final _player = AudioPlayer();

//   int page = 0;
//   bool showAnswer = false;
//   String language = "en-US";
//   bool firstBuild = true;
//   bool isBlock = false;
//   bool isCorrect = false;
//   FlutterTts tts = FlutterTts();
//   var wordList = [
//     {
//       "word": "pretend",
//       "ja": "演じる",
//       "keeped": "0",
//     },
//     {
//       "word": "word",
//       "ja": "言葉",
//       "keeped": "0",
//     },
//     {
//       "word": "apple",
//       "ja": "りんご",
//       "keeped": "0",
//     },
//     {
//       "word": "orange",
//       "ja": "みかん",
//       "keeped": "0",
//     },
//     {
//       "word": "medicine",
//       "ja": "薬",
//       "keeped": "0",
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     tts.setLanguage(language);
//     String word = wordList[page]['word']!;
//     String ja = wordList[page]['ja']!;
//     String keeped = wordList[page]['keeped']!;
//     if (firstBuild) {
//       Future.delayed(Duration(milliseconds: 450)).then((_) => _speak(word));
//     }
//     setState(() {
//       firstBuild = false;
//     });
//     // tts.setPitch(1.0);
//     // tts.setSpeechRate(0.5);

//     // tts.setSpeechRate(0.5);
//     return Scaffold(
//         appBar: AppBar(
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 "Emily in Paris",
//                 style: TextStyle(fontSize: 22, color: Colors.black),
//               ),
//               Text(
//                 '1. Voulez-Vous Coucher Avec Moi?',
//                 style: TextStyle(fontSize: 16, color: Colors.black),
//               ),
//             ],
//           ),
//           elevation: 0,
//           backgroundColor: Colors.white,
//           iconTheme: const IconThemeData(color: Colors.black),
//         ),
//         body: Stack(
//           children: [
//             !showAnswer
//                 ? Container(
//                     padding: EdgeInsets.all(24),
//                     color: Colors.white,
//                     child: Column(
//                       children: [
//                         SizedBox(
//                           height: 280,
//                           child: Column(
//                             children: [
//                               GestureDetector(
//                                 onTap: () {
//                                   _speak(word);
//                                 },
//                                 child: Container(
//                                   padding:
//                                       const EdgeInsets.symmetric(vertical: 60),
//                                   width: double.infinity,
//                                   child: const Icon(
//                                     Icons.volume_up,
//                                     size: 80,
//                                     color: Colors.grey,
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(
//                                 height: 20,
//                               ),
//                               Text(
//                                 '${page + 1} / ${wordList.length}',
//                                 style: TextStyle(fontSize: 24),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const Spacer(),
//                         AnswerButton('演じる'),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                         AnswerButton('頼る'),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                         AnswerButton('意図する'),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                         AnswerButton('変える'),
//                         const SizedBox(
//                           height: 32,
//                         ),
//                         // Container(
//                         //   width: double.infinity,
//                         //   height: 60,
//                         //   child: TextButton(
//                         //       onPressed: () {
//                         //         setState(() {
//                         //           showAnswer = true;
//                         //           wordList[page]['keeped'] = "1";
//                         //         });
//                         //       },
//                         //       child: const Text(
//                         //         'not sure...',
//                         //         style: TextStyle(fontSize: 28),
//                         //       ),
//                         //       style: TextButton.styleFrom(
//                         //           backgroundColor: Colors.grey,
//                         //           primary: Colors.white)),
//                         // ),
//                         // const SizedBox(
//                         //   height: 16,
//                         // ),
//                         Container(
//                           width: double.infinity,
//                           height: 60,
//                           child: TextButton(
//                               onPressed: () {
//                                 setState(() {
//                                   showAnswer = true;
//                                   wordList[page]['keeped'] = "1";
//                                 });
//                               },
//                               child: const Text(
//                                 "not sure...",
//                                 style: TextStyle(fontSize: 28),
//                               ),
//                               style: TextButton.styleFrom(
//                                 backgroundColor: Colors.white,
//                                 primary: Colors.black,
//                                 side: BorderSide(
//                                   color: Colors.grey, //色
//                                   width: 2, //太さ
//                                 ),
//                               )),
//                         ),
//                         const SizedBox(
//                           height: 60,
//                         ),
//                       ],
//                     ),
//                   )
//                 : Container(
//                     width: double.infinity,
//                     color: Colors.white,
//                     padding: EdgeInsets.all(24),
//                     child: Column(children: [
//                       SizedBox(
//                         height: 280,
//                         child: Column(
//                           children: [
//                             Container(
//                               width: double.infinity,
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Icon(
//                                     Icons.search_rounded,
//                                     size: 40,
//                                     color: Colors.grey,
//                                   ),
//                                   keeped == "1"
//                                       ? GestureDetector(
//                                           onTap: () {
//                                             setState(() {
//                                               wordList[page]['keeped'] = "0";
//                                             });
//                                           },
//                                           child: Icon(
//                                             Icons.check_box,
//                                             size: 40,
//                                             color: primaryColor,
//                                           ),
//                                         )
//                                       : GestureDetector(
//                                           onTap: () {
//                                             setState(() {
//                                               wordList[page]['keeped'] = "1";
//                                             });
//                                           },
//                                           child: Icon(
//                                             Icons.check_box_outline_blank,
//                                             size: 40,
//                                             color: primaryColor,
//                                           ),
//                                         ),
//                                   // Spacer(),
//                                 ],
//                               ),
//                             ),
//                             const Spacer(),
//                             GestureDetector(
//                               onTap: () async {
//                                 _speak(word);
//                               },
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     word,
//                                     style: TextStyle(
//                                         color: Colors.black, fontSize: 40),
//                                   ),
//                                   Icon(
//                                     Icons.volume_up,
//                                     size: 40,
//                                     color: Colors.grey,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: 12,
//                             ),
//                             Text(ja,
//                                 style: TextStyle(
//                                     color: Colors.black, fontSize: 22)),
//                             Spacer(),
//                             Text(
//                               '${page + 1} / ${wordList.length}',
//                               style: TextStyle(fontSize: 24),
//                             ),
//                             // SizedBox(
//                             //   height: 120,
//                             // ),
//                           ],
//                         ),
//                       ),
//                       const Spacer(),
//                       SizedBox(
//                         width: double.infinity,
//                         height: 60,
//                         child: TextButton(
//                             onPressed: () {
//                               setState(() {
//                                 showAnswer = false;

//                                 firstBuild = true;
//                                 page = page + 1;
//                               });
//                             },
//                             child: const Text(
//                               'Next',
//                               style: TextStyle(fontSize: 28),
//                             ),
//                             style: TextButton.styleFrom(
//                                 backgroundColor: primaryColor,
//                                 primary: Colors.white)),
//                       ),
//                       // Spacer(),
//                       const SizedBox(
//                         height: 16,
//                       ),
//                       Container(
//                         width: double.infinity,
//                         height: 60,
//                         child: TextButton(
//                             onPressed: () => Navigator.of(context).push(
//                                   MaterialPageRoute(
//                                     builder: (context) => ResultScreen(),
//                                   ),
//                                 ),
//                             child: const Text(
//                               "Quit",
//                               style: TextStyle(fontSize: 28),
//                             ),
//                             style: TextButton.styleFrom(
//                               backgroundColor: Colors.white,
//                               primary: Colors.black,
//                               side: BorderSide(
//                                 color: Colors.grey, //色
//                                 width: 2, //太さ
//                               ),
//                             )),
//                       ),
//                       const SizedBox(
//                         height: 200,
//                       ),
//                     ]),
//                   ),
//             isBlock
//                 ? Container(
//                     color: Colors.transparent,
//                     child: Container(
//                       height: 400,
//                       child: Center(
//                         child: isCorrect
//                             ? Text(
//                                 '○',
//                                 style: TextStyle(
//                                   fontSize: 180,
//                                   color: Colors.lightGreen,
//                                 ),
//                               )
//                             : Text(
//                                 '×',
//                                 style: TextStyle(
//                                   fontSize: 180,
//                                   color: Colors.red[300],
//                                 ),
//                               ),
//                       ),
//                     ),
//                   )
//                 : Container(
//                     height: 0,
//                   )
//           ],
//         ));
//   }

//   Container AnswerButton(word) {
//     return Container(
//       width: double.infinity,
//       height: 60,
//       child: TextButton(
//           onPressed: () async {
//             setState(() {
//               isBlock = true;
//             });
//             await _player
//                 .play(AssetSource('sounds/right_sound.mp3'))
//                 .then((value) => null);
//             Future.delayed(Duration(milliseconds: 1000))
//                 .then((_) => setState(() {
//                       firstBuild = true;
//                       page = page + 1;
//                     }));
//           },
//           child: Text(
//             word,
//             style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
//           ),
//           style: TextButton.styleFrom(
//             backgroundColor: Colors.white,
//             primary: Colors.black,
//             side: BorderSide(
//               color: primaryColor, //色
//               width: 2, //太さ
//             ),
//           )),
//     );
//   }

//   _speak(String word) async {
//     tts.speak(word);
//   }

//   _launchURL(String word) async {
//     String url = "https://www.google.com/search?q=" + word.toString();
//     final Uri _url = Uri.parse(url);
//     if (await canLaunchUrl(_url)) {
//       await launchUrl(_url);
//     } else {
//       throw 'Could not Launch $url';
//     }
//   }
// }
