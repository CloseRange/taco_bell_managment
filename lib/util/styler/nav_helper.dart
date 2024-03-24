

import 'package:flutter/cupertino.dart';


// write a function to pop all the pages and go to a selected page as an argument

void gotoMainpage(BuildContext context, Widget page) {
  Navigator.of(context).popUntil((route) => route.isFirst);
  Navigator.of(context).pushReplacement(
    CupertinoPageRoute(builder: (_) => page),
  );
}

