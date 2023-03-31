import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class HiveMethods {
  Box boxMyanswer = Hive.box('myanswer');
  Box boxTitles = Hive.box('titles');
  Box boxReview = Hive.box<Map>('review');
  // Box boxWords = Hive.box('words');

  Future<String> setAnswers({required words}) async {
    for (var word in words) {
      if (!boxMyanswer.containsKey(word)) {
        boxMyanswer.put(word, 0);
      }
    }
    return "success";
  }

  Future<String> setReview(String word, int ans) async {
    DateTime now = DateTime.now();
    DateTime next = now.add(const Duration(hours: 8));
    DateFormat outputFormat = DateFormat('yyyy-MM-dd');
    String first = outputFormat.format(now);
    Map review = {
      "test": {
        "date": now.add(const Duration(days: 360)),
        "time": 8,
        "first": first,
        "ans": 1
      }
    };
    var reviewGet = await boxReview.get('review');
    if (reviewGet != null) {
      review = reviewGet;
    }
    if (!review.containsKey(word)) {
      if (ans == 2) {
        next = now.add(const Duration(days: 60));
        review[word] = {"date": next, "time": 4, "first": first, "ans": 2};
      } else {
        review[word] = {"date": next, "time": 0, "first": first, "ans": 1};
      }
    } else {
      var li = review[word];
      var time = li['time'];
      if (ans == 2) {
        var d = li['date'];
        // print(DateTime.parse(d));
        if (d.difference(now).inHours < 0) {
          time = time + 1;
        } else if (time == 0) {
          time = 1;
        }
        review[word]["ans"] = ans;
      } else {
        time = 0;
      }
      if (time == 0) {
        next = now.add(const Duration(hours: 8));
      } else if (time == 1) {
        next = now.add(const Duration(days: 2));
      } else if (time == 2) {
        next = now.add(const Duration(days: 5));
      } else if (time == 3) {
        next = now.add(const Duration(days: 14));
      } else if (time == 4) {
        next = now.add(const Duration(days: 28));
      } else if (time == 5) {
        next = now.add(const Duration(days: 60));
      } else if (time == 6) {
        next = now.add(const Duration(days: 90));
      } else if (time == 7) {
        next = now.add(const Duration(days: 120));
      } else if (time == 8) {
        next = now.add(const Duration(days: 180));
      } else {
        next = now.add(const Duration(days: 365));
      }
      // review[word] = {"date": next, "time": time};
      review[word]["date"] = next;
      review[word]["time"] = time;
    }
    await boxReview.put("review", review);

    // review.removeWhere((key, value) =>
    //     DateTime.parse((value['date']! as String)).difference(now).inHours > 0);

    return "success";
  }

  Future<List> getReview() async {
    DateTime now = DateTime.now();
    Map review = await boxReview.get('review', defaultValue: {
      "apple": {"date": "2100-03-16 12:35:19.810280", "time": 0}
    });
    // print(review);
    var li = Map.from(review);
    li.removeWhere(
        (key, value) => (value['date']!).difference(now).inHours > 0);
    li.removeWhere((key, value) => value['ans']!.toString() == "1");
    List list = li.keys.toList();
    // print(review);
    return list;
  }

  getLearnedNum() async {
    var learningNum = 0;
    var memedNum = 0;
    Map review = await boxReview.get('review');
    review.forEach((key, value) {
      if (value.containsKey("ans")) {
        if (value['ans'].toString() == "1") {
          learningNum = learningNum + 1;
        }
        if (value['ans'].toString() == "2") {
          memedNum = memedNum + 1;
        }
      }
    });
    // print(learningNum);
    // print(memedNum);
    return [learningNum, memedNum];
  }
}
