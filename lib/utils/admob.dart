import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/foundation.dart';

String getAdMobAppId(){
  return defaultTargetPlatform == TargetPlatform.android
      ? "ca-app-pub-4539817448561450~1829202203"
      : "ca-app-pub-4539817448561450~7145764600";
}

String getAdMobBannerAdUnitId(){
  return defaultTargetPlatform == TargetPlatform.android
      ? "ca-app-pub-4539817448561450/8682207557"
      : "ca-app-pub-4539817448561450/9081840410";
}

String getAdMobInterstitialAdUnitId(){
  return defaultTargetPlatform == TargetPlatform.android
      ? "ca-app-pub-4539817448561450/1542084136"
      : "ca-app-pub-4539817448561450/7757026740";
}

String getAdMobRewardAdUnitId(){
  return defaultTargetPlatform == TargetPlatform.android
      ? "ca-app-pub-4539817448561450/1283241440"
      : "ca-app-pub-4539817448561450/8878536720";
}

final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  testDevices: <String>["356736175D9CA7F508ED08337745F7B6"],
);

BannerAd createBannerAd() {
  return BannerAd(
    adUnitId: getAdMobBannerAdUnitId(),
    size: AdSize.banner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event $event");
    },
  );
}

InterstitialAd createInterstitialAd() {
  return InterstitialAd(
    adUnitId: getAdMobInterstitialAdUnitId(),
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event $event");
    },
  );
}