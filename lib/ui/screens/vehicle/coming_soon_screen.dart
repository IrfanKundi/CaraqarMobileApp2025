import 'package:careqar/constants/style.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class ComingSoonScreen extends StatelessWidget {
  ComingSoonScreen({super.key, this.title="AllNumberPlates"});

  String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context,title: title),
        body:  Center(child: Text("ComingSoon".tr.toUpperCase(), style: kTextStyle16,))
    );
  }
}
