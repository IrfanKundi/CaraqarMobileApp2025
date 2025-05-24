import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/strings.dart';
import 'package:careqar/constants/style.dart';
import 'package:careqar/controllers/type_controller.dart';
import 'package:careqar/enums.dart';
import 'package:careqar/routes.dart';
import 'package:careqar/ui/widgets/app_bar.dart';
import 'package:careqar/ui/widgets/circular_loader.dart';
import 'package:careqar/ui/widgets/image_widget.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../controllers/vehicle_controller.dart';



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
