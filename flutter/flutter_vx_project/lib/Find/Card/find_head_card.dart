
import 'package:flutter/cupertino.dart';

class FindHeadCard extends StatefulWidget {
  const FindHeadCard({super.key});
  @override
  State<StatefulWidget> createState() {
    return _FindHeadCardState();
  }
}

class _FindHeadCardState extends State<FindHeadCard> {
  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Column(
          children: [
            Text(
              "设计我家",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            )
          ],
        )
      ],
    );
  }
}