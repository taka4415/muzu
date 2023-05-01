import 'package:englishapp/screens/my_page_screen.dart';
import 'package:englishapp/screens/my_study_screen.dart';
import 'package:englishapp/screens/video_list_sceen.dart';
import 'package:englishapp/utils/colors.dart';
import 'package:flutter/material.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  @override
  void initState() {
    super.initState();
    // _firebaseMessaging
    //     .getToken()
    //     .then((value) => {FirestoreMethods().updateToken(value)});
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null) {
    //     flutterLocalNotificationsPlugin.show(
    //         notification.hashCode,
    //         notification.title,
    //         notification.body,
    //         NotificationDetails(
    //           android: AndroidNotificationDetails(
    //             channel.id,
    //             channel.name,
    //             // channel.description,
    //             icon: 'launch_background',
    //           ),
    //         ));
    //   }
    // });
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    // model.User? user = Provider.of<UserProvider>(context).getUser;
    // if (!TimeMethods().judgeOpen()) {
    //   return const EveningScreen();
    // }
    // if (user == null) {
    //   // loading screen
    //   return const Scaffold(
    //       body: Center(
    //           child: CircularProgressIndicator(
    //     color: lightOrangeColor,
    //   )));
    // }

    List<Widget> homeScreenItems = [
      // FeedScreen(method: navigationTapped, user: user),
      VideoListScreen(),
      MyStudyScreen(),
      // const ReviewScreen(),
      const MyPageScreen(),
      // FeedHomeScreen(method: navigationTapped, user: user),
      // SearchScreen(user: user),
      // AddPostScreen(user: user),
      // NortificationScreen(user: user),
      // ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid, user: user),
    ];

    return Scaffold(
      body: PageView(
        children: homeScreenItems,
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        //  CupertinoTabBar(
        // activeColor: Colors.grey,

        // backgroundColor: mobileBackgroundColor,
        type: BottomNavigationBarType.fixed,
        currentIndex: _page,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: secondaryColor,
            ),
            label: 'home',
            // backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.star,
              color: secondaryColor,
            ),
            label: 'my item',
            // backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: secondaryColor,
            ),
            label: 'my page',
            // backgroundColor: primaryColor,
          ),
          //   BottomNavigationBarItem(
          //     icon: Icon(
          //       Icons.search,
          //       color: _page == 1 ? lightOrangeColor : secondaryColor,
          //     ),
          //     label: L10n.of(context)!.search,
          //     // backgroundColor: primaryColor,
          //   ),
        ],
        selectedItemColor: primaryColor,
        selectedLabelStyle: const TextStyle(color: primaryColor),
        unselectedLabelStyle: const TextStyle(color: secondaryColor),
        onTap: navigationTapped,
      ),
    );
  }
}
