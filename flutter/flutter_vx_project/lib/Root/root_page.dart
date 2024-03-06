import 'package:flutter/material.dart';
import 'package:flutter_vx_project/Find/find_page.dart';
import 'package:flutter_vx_project/Home/home_page.dart';
import '../Mine/mine_page.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});
  @override
  State<StatefulWidget> createState() {
    return _RootPageState();
  }
}

class _RootPageState extends State<RootPage> {
  int _pageIndex = 0;
  final List<Widget> _pages = [HomePage(), FindPage(), MinePage()];
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: _pages[_pageIndex],
     appBar: AppBar(
         backgroundColor: Colors.black87,
         shadowColor: Colors.grey,
         toolbarHeight: 44,
       actions: [

       ],
     ),
     bottomNavigationBar: BottomNavigationBar(
       onTap: (index) {
         setState(() {
           _pageIndex = index;
         });
       },
       backgroundColor: Colors.white,
       currentIndex: _pageIndex,
       selectedFontSize: 12.0,
       fixedColor: Colors.green,
       type: BottomNavigationBarType.fixed,
       items: const [
         BottomNavigationBarItem(
           icon: Icon(Icons.book),
             label: '主页'
         ),
         BottomNavigationBarItem(
             icon: Icon(Icons.bookmark),
             label: '发现'
         ),
         BottomNavigationBarItem(
             icon: Icon(Icons.bookmark),
             label: '我的'
         )
       ],
     ),
   );
  }
}