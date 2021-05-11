import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class ImageLayoutWidget extends StatefulWidget {
  const ImageLayoutWidget({
    this.overlappingHeight = 30.0,
    this.coverHeight = 80.0,
    this.coverLeadingSpacing = 25.0,
  });

  /// 重叠高度
  final overlappingHeight;

  /// 覆盖物高度
  final coverHeight;

  /// 覆盖物左侧间距
  final coverLeadingSpacing;

  @override
  _ImageLayoutWidgetState createState() => _ImageLayoutWidgetState();
}

class _ImageLayoutWidgetState extends State<ImageLayoutWidget> {
  @override
  Widget build(BuildContext context) {
    // 屏幕宽度
    final width = MediaQuery.of(context).size.width;

    // 重叠高度需小于覆盖物高度
    assert(widget.overlappingHeight < widget.coverHeight);

    // 覆盖物左侧间距需小于整体屏幕宽度的一半
    assert(widget.coverLeadingSpacing < width / 2);

    final imageWidget = Image.network(
      'https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3077706139,3737588013&fm=11&gp=0.jpg',
    );

    // final imageWidget = Image.network(
    //   'https://scpic.chinaz.net/files/pic/pic9/202105/hpic3909.jpg',
    // );

    final completer = Completer<ui.Image>();

    imageWidget.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo imageInfo, bool synchronousCall) {
          completer.complete(imageInfo.image);
        },
      ),
    );

    return FutureBuilder<ui.Image>(
      future: completer.future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          print('image size: ${snapshot.data.width} * ${snapshot.data.height}');
          final imageHeight =
              (snapshot.data.height * width) / snapshot.data.width;
          return Container(
            color: Colors.orange,
            height: imageHeight + widget.coverHeight - widget.overlappingHeight,
            child: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: [
                Positioned(
                  // left: 0,
                  width: width,
                  height: imageHeight,
                  bottom: widget.coverHeight - widget.overlappingHeight,
                  child: imageWidget,
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: widget.coverLeadingSpacing,
                  ),
                  width: width,
                  height: widget.coverHeight,
                  color: Colors.red[100],
                ),
              ],
            ),
          );
        } else {
          return Text('Loading');
        }
      },
    );
  }
}
