import 'package:flutter/material.dart';

class LayoutDemo extends StatelessWidget {
  const LayoutDemo({super.key});
  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.yellow,
      alignment: Alignment(0.0, 0.0),
      child: AspecDemo(),
    );
  }
}

class AspecDemo extends StatelessWidget {
  const AspecDemo({super.key});
  @override
  Widget build(BuildContext context){
    return Container(
      color: Colors.blue,
      height: 150,
      child: const AspectRatio(
        aspectRatio: 2/1,
        child: Icon(
          Icons.add,
          size: 30,
          color: Colors.red,
        ),
      ),
    );
  }
}

class StackDemo extends StatelessWidget {
  const StackDemo({super.key});
  @override
  Widget build(BuildContext context){
    return Stack(
      alignment: const Alignment(0.0, 0.0),
      children: <Widget>[
        Positioned(
            child: Container(
              color: Colors.yellow,
              width: 200,
              height: 200,
              child: const Icon(Icons.add),
            )
        ),
        Positioned(

            child: Container(
              color: Colors.white,
              width: 100,
              height: 100,
              child: const Icon(Icons.add_a_photo_sharp),
            )
        ),
        Positioned(
            right:0,
            top:0,
            child: Container(
              color: Colors.blue,
              width: 40,
              height: 20,
              child: const Icon(Icons.search),
            )
        )
      ],
    );
  }
}

class RowDemo extends StatelessWidget {
  const RowDemo({super.key});
  @override
  Widget build(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.ideographic,
      children: <Widget>[
        Expanded(
            child: Container(
              height: 80,
              color: Colors.blue,
              child: const Text(
                'hello',
                style: TextStyle(fontSize: 15),
              ),
            ),
        ),
        Expanded(
          child: Container(
            height: 80,
            color: Colors.yellow,
            child: const Text(
              'hello',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        Expanded(
          child: Container(
            height: 80,
            color: Colors.red,
            child: const Text(
              'hello',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}