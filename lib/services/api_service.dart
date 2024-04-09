import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toonflix/models/webtoon_detail_model.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:toonflix/models/webtoon_model.dart';

class ApiService {
  static const String baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";
  // async(비동기) progrmming
  // 비동기 일 때는 Future << 넣어줘야 한다.
  static Future<List<WebtoonModel>> getTodaysToons() async {
    // Json으로 웹툰을 만들 때마다 webtoonInstances 이 리스트에 추가할 것이다
    List<WebtoonModel> webtoonInstances = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url); // dart가 이부분이 제대로 완료될 때까지 기다린다
    // API 요청이 처리돼서 응답을 반환할 떄까지 기다리는 것
    // 타입이 future이 아니라 response인 이뮤 : 기다렸다가 완료 될 때 response로 주기 때문이다
    if (response.statusCode == 200) {
      final List<dynamic> webtoons = jsonDecode(response.body);
      for (var webtoon in webtoons) {
        //API로 부터 JSON을 넘겨준다
        final instance = WebtoonModel.fromJson(webtoon);
        webtoonInstances.add(instance);
      }
      return webtoonInstances;
    }
    throw Error();
  }

  // ID로 Wedtoon을 한개 받아오는 메서드 (웹툰 정보 에피소드 가져오기)
  static Future<WebtoonDetailModel> getToonById(String id) async {
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }

  // ID 값에 따라서 최신 에피소드 리스트를 받아온다 (최신 에피소드 가져오기)
  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    List<WebtoonEpisodeModel> episodesInstances = [];
    final url = Uri.parse("$baseUrl/$id/episodes"); // 에피소드 리스트를 받아온다
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final episodes = jsonDecode(response.body);
      for (var episode in episodes) {
        episodesInstances.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstances;
    }
    throw Error();
  }
}
