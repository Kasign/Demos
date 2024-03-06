
class Car {
  late String name;
  late String? imageUrl;
  // 第1种默认构建方式
  // 第2种构建方式
  // Car(String name1, String url) {
  //   name = name1;
  //   imageUrl = url;
  // }

  // 第3种构建方式
  // Car(this.name, this.imageUrl);
  // Car.defaults()

  // 第4种构建方式
  // Car(
  //     this.name,
  //     {
  //       this.imageUrl,
  //     }
  //     );
  // 第5种从map构建
  Car.fromMap(Map<String, String?> m) {
    name = m["name"]!;
    imageUrl = m["imageUrl"];
  }
  // 第6种构建，重定向构建
  Car({required this.name, this.imageUrl});
  // Car.defaults(String n, String url):this(name: n, imageUrl: url);
}