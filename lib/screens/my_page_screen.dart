import 'package:englishapp/utils/colors.dart';
import 'package:englishapp/utils/hive_method.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({Key? key}) : super(key: key);

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  var learned = 0;
  var isLoading = true;
  String lang = "en";

  @override
  initState() {
    super.initState();
    getLanguage();
    getNum();
  }

  getLanguage() async {
    String tmp = await HiveMethods().getLanguage();
    setState(() {
      lang = tmp;
    });
  }

  getNum() async {
    setState(() {
      isLoading = true;
    });
    List li = await HiveMethods().getLearnedNum();

    setState(() {
      learned = li[0] + li[1];
      isLoading = false;
    });
  }

  void _showModalPicker(BuildContext context) {
    var w = MediaQuery.of(context).size.width * 0.01;
    var h = MediaQuery.of(context).size.height * 0.01;
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: h * 36,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  "Language",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(
                height: h * 30,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CupertinoPicker(
                    itemExtent: 40,
                    children: _items.map(_pickerItem).toList(),
                    onSelectedItemChanged: _onSelectedItemChanged,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  final List<String> _items = [
    'Japanese',
    'Spanish',
    'French',
    'Arabic',
    'English',
  ];

  final List langList = [
    "ja",
    "es",
    "fr",
    "ar",
    "en",
  ];

  Widget _pickerItem(String str) {
    return Text(
      str,
      style: const TextStyle(fontSize: 32),
    );
  }

  void _onSelectedItemChanged(int index) async {
    await HiveMethods().setLocale(langList[index]);
    setState(() {
      lang = langList[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width * 0.01;
    var h = MediaQuery.of(context).size.height * 0.01;
    final _urlLaunchWithStringButton = UrlLaunchWithStringButton();

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("My Page"),
      //   foregroundColor: Colors.black,
      //   elevation: 0,
      //   backgroundColor: Colors.white,
      //   iconTheme: const IconThemeData(color: Colors.black),
      // ),
      body: isLoading
          ? Container()
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 120,
                  ),
                  Text(lang == "ja" ? "学んだ単語 :" : "You have learned : ",
                      style:
                          const TextStyle(fontSize: 20, color: Colors.black)),
                  SizedBox(
                    height: h * 1,
                  ),
                  Text("$learned words",
                      style:
                          const TextStyle(fontSize: 40, color: Colors.black)),
                  // SizedBox(
                  //   height: h * 2,
                  // ),
                  // Text(lang == "ja" ? "すごい!!" : "Great!!!",
                  //     style: TextStyle(fontSize: 32, color: primaryColor)),
                  // const SizedBox(
                  //   height: 40,
                  // ),
                  // ExpansionTile(
                  //   title: Row(
                  //     children: [
                  //       const Icon(Icons.settings),
                  //       const SizedBox(
                  //         width: 12,
                  //       ),
                  //       const Text(
                  //         "Setting",
                  //         style: TextStyle(fontSize: 20),
                  //       ),
                  //     ],
                  //   ),
                  //   children: [
                  //     ListTile(
                  //       title: Row(
                  //         children: [
                  //           const SizedBox(
                  //             width: 12,
                  //           ),
                  //           const Icon(Icons.person),
                  //           const SizedBox(
                  //             width: 12,
                  //           ),
                  //           const Text('Nickname'),
                  //           const Spacer(),
                  //           Text(nickname),
                  //           const SizedBox(
                  //             width: 12,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     ListTile(
                  //       title: Row(
                  //         children: [
                  //           const SizedBox(
                  //             width: 12,
                  //           ),
                  //           const Icon(Icons.language),
                  //           const SizedBox(
                  //             width: 12,
                  //           ),
                  //           const Text("language"),
                  //           const Spacer(),
                  //           Text(language),
                  //           const SizedBox(
                  //             width: 12,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     ListTile(
                  //       title: Row(
                  //         children: [
                  //           const SizedBox(
                  //             width: 12,
                  //           ),
                  //           const Icon(Icons.volume_up),
                  //           const SizedBox(
                  //             width: 12,
                  //           ),
                  //           const Text("Pronunciation"),
                  //           const Spacer(),
                  //           Text(pronunciation),
                  //           const SizedBox(
                  //             width: 12,
                  //           ),
                  //         ],
                  //       ),
                  //     )
                  //   ],
                  // ),
                  SizedBox(
                    height: h * 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      lang == "ja"
                          ? "勉強したいタイトル/エピソードがない場合は、ここからリクエストしてね"
                          : "If you don't see the title/episode you want to learn, please request here!",
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12),
                    child: SizedBox(
                      width: double.infinity,
                      height: h * 6,
                      child: TextButton(
                          onPressed: () {
                            _urlLaunchWithStringButton.launchUriWithString(
                              context,
                              "https://docs.google.com/forms/d/e/1FAIpQLSdlG3BcsTmvMm_9b3dGQnnJ07kD3ANbJ6iktbB1BK3UHMtsgQ/viewform",
                            );
                          },
                          child: Text(
                            lang == "ja" ? "リクエストフォーム" : 'Request Form',
                            style: const TextStyle(fontSize: 18),
                          ),
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: primaryColor)),
                    ),
                  ),
                  SizedBox(
                    height: h * 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      _showModalPicker(context);
                    },
                    child: ListTile(
                      title: Row(
                        children: [
                          const Icon(Icons.language_outlined),
                          const SizedBox(
                            width: 12,
                          ),
                          Text('Language Setting($lang)'),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _urlLaunchWithStringButton.launchUriWithString(
                        context,
                        "https://docs.google.com/forms/d/e/1FAIpQLSdlG3BcsTmvMm_9b3dGQnnJ07kD3ANbJ6iktbB1BK3UHMtsgQ/viewform",
                      );
                    },
                    child: ListTile(
                      title: Row(
                        children: [
                          const Icon(Icons.mail_outline),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            lang == "ja" ? "お問い合わせ" : 'Inquiry',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _urlLaunchWithStringButton.launchUriWithString(
                        context,
                        "https://taka4415.github.io/muzu_info/terms.html",
                      );
                    },
                    child: ListTile(
                      title: Row(
                        children: [
                          const Icon(Icons.notes_outlined),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(lang == "ja" ? "利用規約" : 'Terms'),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _urlLaunchWithStringButton.launchUriWithString(
                        context,
                        "https://taka4415.github.io/muzu_info/privacy_policy.html",
                      );
                    },
                    child: ListTile(
                      title: Row(
                        children: [
                          const Icon(Icons.notes_outlined),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(lang == "ja" ? "プライバシーポリシー" : 'Privacy policy'),
                        ],
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  //   child: Row(
                  //     children: [
                  //       const Icon(Icons.mail_outline),
                  //       const SizedBox(
                  //         width: 12,
                  //       ),
                  //       const Text(
                  //         'Inquiry',
                  //         style: TextStyle(fontSize: 20),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // Text(
                  //   'Terms',
                  //   style: TextStyle(fontSize: 18),
                  // ),
                  // Text(
                  //   'Privacy policy',
                  //   style: TextStyle(fontSize: 18),
                  // ),
                  const SizedBox(
                    height: 24,
                  ),
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
}

class UrlLaunchWithStringButton {
  final alertSnackBar = SnackBar(
    content: const Text('このURLは開けませんでした'),
    action: SnackBarAction(
      label: '戻る',
      onPressed: () {},
    ),
  );

  Future launchUriWithString(BuildContext context, String url) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      alertSnackBar;
      ScaffoldMessenger.of(context).showSnackBar(alertSnackBar);
    }
  }
}
