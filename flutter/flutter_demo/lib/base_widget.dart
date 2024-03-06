import 'package:flutter/material.dart';


class TextDemo extends StatelessWidget {

  const TextDemo({super.key});

  final TextStyle _textStyle = const TextStyle(
    fontSize: 20.0,
  );

  final String _title1 = 'Flutter 牛';
  final String _autor = "Walg 牛";

  @override
  Widget build(BuildContext context) {
    return Text(
      "1、 $_autor flutter demo $_title1 flutter demo 2、 $_autor flutter demo $_title1 flutter demo 3、 $_autor flutter demo $_title1 flutter demo 4、 $_autor flutter demo $_title1 flutter demo ",
      textAlign: TextAlign.left,
      style: _textStyle,
      maxLines: 10,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class RichTextDemo extends StatelessWidget {
  const RichTextDemo({super.key});
  @override
  Widget build(BuildContext context) {
    return RichText(
        text: const TextSpan(
          text: '<Flutter 厉害>\n',
          style: TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(
              text: '1.--\n',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
              ),
            ),
            TextSpan(
              text: '2.==\n',
              style: TextStyle(
                fontSize: 30,
                color: Colors.red,
              ),
            ),
          ],
        ),
    );
  }
}

class ContainerDemo extends StatelessWidget {
  const ContainerDemo({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Column(
        children: <Widget>[
          Container(
           color: Colors.red,
           padding: const EdgeInsets.all(30),
           margin: const EdgeInsets.all(20),
           height: 200,
           width: 200,
           child: const Icon(
             Icons.add,
             size: 45,
           ),
          ),
          Container(
            color: Colors.red,
            padding: const EdgeInsets.all(30),
            margin: const EdgeInsets.all(10),
            height: 200,
            width: 200,
            child: const Icon(
              Icons.add,
              size: 45,
            ),
          ),
        ],
      ),
    );
  }
}