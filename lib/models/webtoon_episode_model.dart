class WebtoonEpisodeModel {
  final String id, title, rating, date;

  //클래스를 초기화 할 생성자
  WebtoonEpisodeModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        rating = json['rating'],
        date = json['date'];
}
