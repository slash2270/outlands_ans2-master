import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../util/constants.dart';

abstract class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState();
}

abstract class BasePageState<T extends BasePage> extends State<T> {

  String setTitle();

  Widget setBuild();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${setTitle()} Page'),
          leading: Visibility(
            visible: setTitle() != Constants.home,
            child: IconButton(icon: const Icon(Icons.keyboard_backspace), onPressed: () => context.pop()),
          )
      ),
      body: SafeArea(
        child: setBuild(),
      ),
    );
  }

}