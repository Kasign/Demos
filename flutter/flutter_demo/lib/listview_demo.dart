import 'package:flutter/material.dart';
import 'package:flutter_demo/Module/car.dart';


class ListViewDemo extends StatelessWidget {
  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
      margin: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Image.network(datas[index].imageUrl!),
          const SizedBox(height: 10,),
          Text(
            datas[index].name,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w100,
                fontStyle: FontStyle.italic
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: datas.length,
      itemBuilder: _itemBuilder,
    );
  }
}

final List<Car> datas = [
  Car(name: "兰博基尼1", imageUrl: "https://picx.zhimg.com/80/v2-e8d44183b7d142051d6f7a60f91472f8_1440w.webp?source=1def8aca"),
  Car(name: "兰博基尼2", imageUrl: "https://pic1.zhimg.com/80/v2-69c3876c9d7709a36e036f4f673394ea_1440w.webp?source=1def8aca"),
  Car(name: "兰博基尼3", imageUrl: "https://pic1.zhimg.com/80/v2-2023dfaa8acf96e378c88c60e042c3e8_1440w.webp?source=1def8aca"),
  Car(name: "兰博基尼4", imageUrl: "https://picx.zhimg.com/80/v2-cee858543a9ccae27e8f700f339118c5_1440w.webp?source=1def8aca"),
  Car(name: "兰博基尼5", imageUrl: "https://picx.zhimg.com/80/v2-e8d44183b7d142051d6f7a60f91472f8_1440w.webp?source=1def8aca"),
  Car(name: "兰博基尼6", imageUrl: "https://picx.zhimg.com/80/v2-e8d44183b7d142051d6f7a60f91472f8_1440w.webp?source=1def8aca"),
  Car(name: "兰博基尼7", imageUrl: "https://picx.zhimg.com/80/v2-e8d44183b7d142051d6f7a60f91472f8_1440w.webp?source=1def8aca"),
  Car(name: "兰博基尼8", imageUrl: "https://picx.zhimg.com/80/v2-e8d44183b7d142051d6f7a60f91472f8_1440w.webp?source=1def8aca"),
  Car(name: "兰博基尼9", imageUrl: "https://picx.zhimg.com/80/v2-ca17b870c9885d4cf4723cb03359b78c_1440w.webp?source=1def8aca"),
  Car(name: "兰博基尼10", imageUrl: "https://pic1.zhimg.com/80/v2-69c3876c9d7709a36e036f4f673394ea_1440w.webp?source=1def8aca")
];