import 'package:englishapp/responsive/mobile_screen_layout.dart';
import 'package:englishapp/utils/colors.dart';
import 'package:englishapp/utils/hive_method.dart';
import 'package:englishapp/widgets/primary_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  String lang = "en";

  @override
  void initState() {
    getLanguage();
    super.initState();
  }

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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 190, 0),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: h * 10),
        child: Container(
          decoration: BoxDecoration(
            // color: Color.fromARGB(255, 255, 249, 226),
            color: Colors.white,
            // border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey, //色
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(1, 1),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    lang == "ja"
                        ? "海外ドラマ・映画の\n英単語帳"
                        : lang == "es"
                            ? "Libro de vocabulario\nde películas en inglés"
                            : lang == "fr"
                                ? "Livre de vocabulaire\n du film en anglais"
                                : "English Movie\nVocabulary book",
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 87, 34),
                        fontSize: 36,
                        fontFamily: "ZenMaruGothic"
                        // fontWeight: FontWeight.w700,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const Text("-Muzu-",
                      style: TextStyle(
                        color: Color.fromARGB(255, 68, 68, 68),
                        fontSize: 28,
                        // fontWeight: FontWeight.w700,
                      )),
                  SizedBox(
                    height: h * 2,
                  ),
                  Text(
                      lang == "ja"
                          ? "選んだタイトル・エピソードに\n実際に出てくる単語が学べる"
                          : lang == "es"
                              ? "Aprenda las palabras que realmente aparecen en el título/episodio seleccionado"
                              : lang == "fr"
                                  ? "Apprenez les mots qui apparaissent réellement dans le titre/épisode sélectionné"
                                  : lang == "ar"
                                      ? "تعرف على الكلمات التي تظهر بالفعل في العنوان / الحلقة المحددة"
                                      : "Learn the words that actually appear in the selected title/episode",
                      style: const TextStyle(color: blackColor, fontSize: 21)),
                  const Spacer(),
                  Text(
                      lang == "ja"
                          ? "まずは、好きなタイトルを選ぼう！"
                          : lang == "es"
                              ? "Primero, elige tu título favorito"
                              : lang == "fr"
                                  ? "Tout d'abord, choisissez votre titre préféré !"
                                  : lang == "ar"
                                      ? "أولاً ، اختر لقبك المفضل"
                                      : "First, choose your favorite title!",
                      style: const TextStyle(color: blackColor, fontSize: 20)),
                  Text(
                    lang == "ja"
                        ? "※もし学びたいタイトルがなかったら、\nマイページからリクエストしてね!"
                        : lang == "es"
                            ? "※Si no ves el título que quieres aprender, por favor solicítalo desde mi página"
                            : lang == "fr"
                                ? "※Si vous ne voyez pas le titre que vous souhaitez apprendre, veuillez le demander sur ma page"
                                : lang == "ar"
                                    ? "إذا كنت لا ترى العنوان الذي تريد معرفته ، فيرجى طلبه من صفحتي"
                                    : "※If you don't see the title you want to learn, please request it from my page.",
                    style: const TextStyle(color: blackColor, fontSize: 18),
                  ),
                  SizedBox(
                    height: h * 4,
                  ),
                  SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                          text: lang == "ja" ? "始める" : "Start",
                          function: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const MobileScreenLayout(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                      opacity: animation, child: child);
                                },
                              ),
                            );
                          })),
                  SizedBox(
                    height: h * 2,
                  ),
                  GestureDetector(
                    onTap: () {
                      _showModalPicker(context);
                    },
                    child: const Text(
                      "Language Setting",
                      style: TextStyle(fontSize: 20, color: blackColor),
                    ),
                  ),
                  SizedBox(
                    height: h * 1,
                  ),
                ]),
          ),
        ),
      ),
    );
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
}
