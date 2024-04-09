// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toonflix/services/api_service.dart';
import 'package:toonflix/models/webtoon_model.dart';
import 'package:toonflix/widgets/webtoon_widget.dart';
// import 'package:toonflix/services/api_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: const Text(
          "Today's Webtoon!",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      // await를 사용할 필요도 없고 setState도 쓸 필요가 없으며 isLoading을 조작 할 필요도 없다.
      // FutureBuilder : future값을 기다려 주고 데이터가 있는지 없는지 확인도 가능 하다
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot) {
          //snapshot 이름은 자유롭게 바꾸어도 좋다 대신 snapshot.hasData<< 이것도 함께 바꿔주기
          if (snapshot.hasData) {
            // snapshot.hasData이 참이면 아래를 실행 / snapshot이 데이터를 가지고 있을 때만 실행된다
            // separated : 필수 인자를 하나 더 가진다
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(child: makeList(snapshot))
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(), // 로딩 표시
          );
        },
      ),
    );
  }

  // makeList 메서드를 추출한다.
  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
    return ListView.separated(
      scrollDirection: Axis.horizontal, //가로 스크롤
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      itemBuilder: (context, index) {
        print(index);
        var webtoon = snapshot.data![index];
        return Webtoon(
          title: webtoon.title,
          thumb: webtoon.thumb,
          id: webtoon.id,
        );
      },
      // 위젯을 반환한다. 그리고 이 위젯은 리스트 아이템 사이에 렌더 시킨다(아이템을 구분하기 위함)
      separatorBuilder: (context, index) => const SizedBox(width: 40),
    );
  }
}
