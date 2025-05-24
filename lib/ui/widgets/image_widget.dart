
import 'package:cached_network_image/cached_network_image.dart';
import 'package:careqar/constants/colors.dart';
import 'package:careqar/constants/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'circular_loader.dart';

class ImageWidget extends StatelessWidget {
  final url;
  final double width;
  final double height;
  final isLocalImage;
  final bool isProfileImage;
  final file;
  final fit;
  final bgColor;
  final bool isCircular;

  const ImageWidget(this.url,
      {Key? key, this.isCircular = false,
      this.bgColor,
      this.width = double.infinity,
      this.file,
      this.height = double.infinity,
      this.isLocalImage = false,
      this.isProfileImage = false,
      this.fit = BoxFit.contain}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return ClipRRect(
          borderRadius: isCircular
              ? BorderRadius.circular(width + height / 2)
              : BorderRadius.zero,
          child: Image.file(
            file,
            width: width,
            height: height,
            fit: fit,
          ));
    } else if (isLocalImage) {
      return ClipRRect(
          borderRadius: isCircular
              ? BorderRadius.circular(width + height / 2)
              : BorderRadius.zero,
          child: Image.asset(
            url,
            width: width,
            height: height,
            fit: fit,
          ));
    } else {
      try{
        return ClipRRect(
          borderRadius: isCircular
              ? BorderRadius.circular(width + height / 2)
              : BorderRadius.zero,
          child: CachedNetworkImage(
            imageUrl: url,
            width: width,
            height: height,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                color: bgColor,
                image: DecorationImage(
                  image: imageProvider,
                  fit: fit,
                ),
              ),
            ),
            placeholder: (context, url) => const CircularLoader(
              color: kGreyColor,
            ),
            errorWidget: (context, url, error) => ClipRRect(
                borderRadius: isCircular
                    ? BorderRadius.circular(width + height / 2)
                    : BorderRadius.zero,
                child: Center(child: FittedBox(fit: BoxFit.contain,child: Text("Image\nComing\nSoon",style: kImageStyle,)))),
          ),
        );
      }catch(ex){
        return ClipRRect(
            borderRadius: isCircular
                ? BorderRadius.circular(width + height / 2)
                : BorderRadius.zero,
            child: Center(child: FittedBox(fit: BoxFit.contain,child: Text("Image\nComing\nSoon",style: kImageStyle,))));
      }

    }
  }
}
