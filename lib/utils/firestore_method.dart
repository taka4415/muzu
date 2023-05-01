import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Box boxWords = Hive.box('words');
  Box boxTitles = Hive.box('titles');
  Box boxTitleWords = Hive.box('title_words');
  Box boxMyanswer = Hive.box('myanswer');
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<String> getWords({required String id}) async {
    var version = await getVersion();
    final v = boxTitles.get(id).toString();
    if (v != version.toString()) {
      final snap = await _firestore
          .collection('vocab')
          // .collection('words')
          .where('title', arrayContains: id)
          .get();
      List list = [];
      for (var i in snap.docs) {
        String word = i.data()['word'];
        if (boxWords.containsKey(word)) {
          boxWords.delete(word);
        }
        boxWords.put(word, i.data());
        if (!boxMyanswer.containsKey(word)) {
          boxMyanswer.put(word, 0);
        }
        list.add(word);
      }
      list.shuffle();
      boxTitleWords.put(id, list);
      boxTitles.put(id, version);
      // print("word downloaded");
    } else {
      // print("already downloaded");
    }
    return "success";
  }

  getVersion() async {
    final snap = await _firestore.collection('version').doc('vocab').get();
    var tmp = snap.data();
    return tmp!['version'];
  }

  reportBug(
      {required String word,
      required String lang,
      required int gameRule}) async {
    await _firestore.collection("report").add({
      "word": word,
      "language": lang,
      "rule": gameRule,
      "timestamp": FieldValue.serverTimestamp()
    });
  }
}

// https://zenn.dev/naoya_maeda/articles/b67f53af377395