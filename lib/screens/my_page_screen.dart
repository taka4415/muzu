import 'package:englishapp/utils/colors.dart';
import 'package:englishapp/utils/hive_method.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
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

  @override
  initState() {
    super.initState();
    getNum();
    sendPageView();
  }

  void sendPageView() {
    FirebaseAnalytics.instance.logEvent(
      name: 'screen_view',
      parameters: {
        'firebase_screen': 'mypage',
        'firebase_screen_class': "MyPageScreen",
      },
    );
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

  @override
  Widget build(BuildContext context) {
    var nickname = "Taka";
    var language = "Japanese";
    var pronunciation = "en-US";
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
                  const Text("You have learned : ",
                      style: TextStyle(fontSize: 18, color: Colors.black)),
                  Text("$learned words",
                      style:
                          const TextStyle(fontSize: 28, color: Colors.black)),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text("Great!!!",
                      style: TextStyle(fontSize: 32, color: primaryColor)),
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
                  const SizedBox(
                    height: 60,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      "No TV show or movie that you want to learn? Feel free to request! We will prepare it soon!",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                    ),
                  ),

                  // const Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: 24),
                  //   child: Text(
                  //     "Feel free to request! We will prepare it soon!",
                  //     style: TextStyle(fontSize: 20),
                  //   ),
                  // ),

                  // const SizedBox(
                  //   height: 20,
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12),
                    child: SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: TextButton(
                          onPressed: () {
                            _urlLaunchWithStringButton.launchUriWithString(
                              context,
                              "https://docs.google.com/forms/d/e/1FAIpQLSdlG3BcsTmvMm_9b3dGQnnJ07kD3ANbJ6iktbB1BK3UHMtsgQ/viewform",
                            );
                          },
                          child: const Text(
                            'Request Form',
                            style: TextStyle(fontSize: 18),
                          ),
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: primaryColor)),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
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
                        children: const [
                          Icon(Icons.mail_outline),
                          SizedBox(
                            width: 12,
                          ),
                          Text(
                            'Inquiry',
                            style: TextStyle(fontSize: 16),
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
                    child: const ListTile(
                      title: Text('Terms'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _urlLaunchWithStringButton.launchUriWithString(
                        context,
                        "https://taka4415.github.io/muzu_info/privacy_policy.html",
                      );
                    },
                    child: const ListTile(
                      title: Text('Privacy policy'),
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
                  )
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
