import 'package:flutter/cupertino.dart';

class ListViewBuilder extends Widget {
  ListViewBuilder({super.key});
  int _itemCount = 0;
  Widget _itemForRow(BuildContext context, int index) {
    return const Text("test");
  }
  @override
  Future<Element> createElement() async {
    _itemCount = 0;
    return this;
  }
}

class ListViewBusiness extends StatelessWidget {
  ListViewBusiness({super.key});
  final ListViewBuilder _itemForRow = ListViewBuilder();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _itemForRow._itemCount,
      itemBuilder: _itemForRow._itemForRow,
    );
  }
}