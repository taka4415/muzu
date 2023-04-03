import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiMethod {
  Future getVideoInfo(movieId, type) async {
    String apiKey = "673247aedf86b5fd507c9a737c4f79b9";
    String path = '/3/movie/' + movieId;
    if (type != "movie") {
      path = '/3/tv/' + movieId;
    }
    final url = Uri.https('api.themoviedb.org', path, {"api_key": apiKey});

    final http.Response res = await http.get(
      url,
    );
    Map<String, dynamic> map = jsonDecode(res.body);
    print(map);
    return map;
  }
}
