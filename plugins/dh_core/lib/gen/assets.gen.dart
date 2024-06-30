/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

import 'package:flutter/widgets.dart';

class $AssetsImgGen {
  const $AssetsImgGen();

  AssetGenImage get lptIconCommonBackN =>
      const AssetGenImage('assets/img/lpt_icon_common_back_n.webp');
  AssetGenImage get lptUiEmptyBg =>
      const AssetGenImage('assets/img/lpt_ui_empty_bg.png');
}

class $AssetsJsonGen {
  const $AssetsJsonGen();

  String get commonLoadingLottie =>
      'packages/dh_core/assets/json/common_loading_lottie.json';
}

class Assets {
  Assets._();
  static const String packageName = "dh_core";

  static const $AssetsImgGen img = $AssetsImgGen();
  static const $AssetsJsonGen json = $AssetsJsonGen();
}

class AssetGenImage extends AssetImage {
  const AssetGenImage(String assetName) : super(assetName, package: 'dh_core');

  Image image({
    Key? key,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? width,
    double? height,
    Color? color,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    FilterQuality filterQuality = FilterQuality.low,
  }) {
    return Image(
      key: key,
      image: this,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      filterQuality: filterQuality,
    );
  }

  String get path => assetName;
}
