import 'package:flutter/material.dart';
import 'package:toonflix/screens/detail_screen.dart';

class Webtoon extends StatelessWidget {
  final String title, thumb, id;

  const Webtoon({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator로 Route를 push를 해준다
        // 이걸 사용하면 애니메이션 효과를 이용하여 다른 페이지로 이동했다고 느끼게 한다
        //실은 또 다른 위젯을 랜더링한 것 뿐!!
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DatailScreen(
              title: title,
              thumb: thumb,
              id: id,
            ),
            fullscreenDialog: true,
          ),
        );
      },
      child: Column(
        children: [
          Hero(
            tag: id,
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
                thumb,
                // 이 문단이 없으면 403 에러가 뜬다(user-agent 변경방법)
                headers: const {
                  "User-Agent":
                      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
            ),
          ),
        ],
      ),
    );
  }
}
