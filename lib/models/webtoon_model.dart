class WebtoonModel {
  final String title, thumb, id;

  // named constructor
  // 이름이 있는 클래스 constructor(생산자)이다.
  // fromJson < 이게 이름
  // 이 내용들을 초기화 하라~ 하는 말
  // WebtoonModel의 title을 Json의 타이틀로 초기화 시켜준다
  WebtoonModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        thumb = json['thumb'],
        id = json['id'];
}
