import 'package:flutter/material.dart';

class Content extends StatelessWidget {
  // final String title;
  final Widget child;

  Content({
    Key key,
    //  @required this.title,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        // Card(
        //   elevation: 2,
        //   margin: const EdgeInsets.all(5),
        //   clipBehavior: Clip.antiAliasWithSaveLayer,
        //   child:
        Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Container(
        //   width: double.infinity,
        //   padding: const EdgeInsets.all(15),
        //   color: Colors.blueGrey[50],
        //   child: Text(
        //     title,
        //     style: const TextStyle(
        //         color: Colors.blueGrey, fontWeight: FontWeight.w500),
        //   ),
        // ),
        Flexible(fit: FlexFit.loose, child: child),
      ],
    );
    // );
  }
}
