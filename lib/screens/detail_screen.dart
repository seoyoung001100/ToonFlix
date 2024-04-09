import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonflix/models/webtoon_detail_model.dart';
import 'package:toonflix/models/webtoon_episode_model.dart';
import 'package:toonflix/services/api_service.dart';
import 'package:toonflix/widgets/episode_widget.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:url_launcher/url_launcher_string.dart';

// StatefulWidget로 바꾼 이유는 initState 메서드가 필요했기 때문이다
// 그래야 getToonById과 getLatestEpisodesById를 사용할 수 있다
// !!!유저가 클릭한 ID!!! 값을 받아야 해서 initState를 사용할 필요가 있었다
class DatailScreen extends StatefulWidget {
  final String title, thumb, id;

  const DatailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DatailScreen> createState() => _DatailScreenState();
}

class _DatailScreenState extends State<DatailScreen> {
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  /* 
    이런 경우에는 Late modifier가 굉장히 유용하다
       초기화 하고 싶은 property(여기서는 webtoon, episodes) 가 있지만 contructor에서는 불가능 한 경우
       initState() funtion에서 초기화 하는 것.
       initState가 항상 build보다 먼저 호출이 되기 때문이다. / 그리고 단 한 번만 호출이 된다.

   */

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');

    // likedToons라는 이름의 String List가 있는지 살펴보고, 만약 있다면 웹툰의 ID를 가지고 있는지 확인
    //String List가 ID를 가지고 있는지 확인 한 뒤에 가지고 있다면 isLike에 true 값을 준다 (그렇지 않다면 false 값을 그대로 가진다.)
    if (likedToons != null) {
      // 리스트가 생겼을 때를 말함
      if (likedToons.contains(widget.id) == true) {
        setState(() {
          isLiked = true;
        });
      }
    } else {
      // 이름과 초기값이 들어간다.
      // Future이기 때문에 반드시 await를 붙여줘야 한다.
      // 사용자가 처음으로 앱을 실행하는 케이스, 처음 실행하면 likedToons이 존재하지 않기 때문이다.
      await prefs.setStringList('likedToons', []);
    }
  }

  @override
  void initState() {
    super.initState();
    //initState() 에서는 widget.id에 접근 할 수 있다.
    // 그냥 id 라고 적는게 아니라 widget.id라고 저는 이유는 별개의 class에서 작업을 하고 있기 때문이다
    // State를 extends 하는 class에 있는데 데이터는 StatefulWidget인 DatailScreen에서 받아오고 있기 때문이다
    // home screen이랑 다르게 초기화 시킨다.( 사용자가 클릭한 ID가 필요했기 때문에)
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);

    initPrefs();
  }

  /* 
    1. 사용자가 버튼을 누르면 리스트를 가져온다.
    2. 만약 사용자가 이미 webtoon에 좋아요를 눌렀다면 해당 webtoon을 List에서 제거해 줄 것이다.
    3. 좋아요를 누르지 않았던 webtoon이라면 List에 해당 webtoon을 추가해준다.
    4. List에 추가를 했건, 삭제를 했건 핸드폰 저장소에 다시금 List를 저장해준다.
  */
  onHeartTap() async {
    final likedToons = prefs.getStringList('likedToons');
    if (likedToons != null) {
      if (isLiked) {
        likedToons.remove(widget.id);
      } else {
        likedToons.add(widget.id);
      }
      await prefs.setStringList('likedToons', likedToons);
      setState(() {
        isLiked = !isLiked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: onHeartTap,
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_outline,
            ),
          )
        ],
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 50,
            vertical: 50,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
                    child: Container(
                      width: 250,
                      // 이 부분이 없으면 borderRadius가 적용이 안 된다.
                      // clipBehavior때문에 일어나는 현상인데 '자식의 부모 영역 침범을 제어하는 방법'이다
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 7,
                            offset: const Offset(5, 5),
                            color: Colors.black.withOpacity(0.5),
                          )
                        ],
                      ),
                      child: Image.network(
                        widget.thumb,
                        // 이 문단이 없으면 403 에러가 뜬다(user-agent 변경방법)
                        headers: const {
                          "User-Agent":
                              "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: webtoon,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  }
                  return const Text('...');
                },
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: episodes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var episode in snapshot.data!)
                          Episode(
                            episode: episode,
                            webtoonId: widget.id,
                          ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
