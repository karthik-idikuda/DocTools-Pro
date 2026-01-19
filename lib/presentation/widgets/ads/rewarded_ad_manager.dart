import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdManager {
  RewardedAd? _rewardedAd;
  bool _isLoaded = false;

  static const String _adUnitId = 'ca-app-pub-3940256099942544/5224354917'; // Test ID

  void loadAd() {
    RewardedAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isLoaded = true;
          debugPrint('RewardedAd loaded');
        },
        onAdFailedToLoad: (error) {
          debugPrint('RewardedAd failed to load: ${error.message}');
          _isLoaded = false;
        },
      ),
    );
  }

  void showAd({required Function(RewardItem) onRewarded, VoidCallback? onAdDismissed}) {
    if (_isLoaded && _rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _isLoaded = false;
          onAdDismissed?.call();
          loadAd(); // Preload next
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _isLoaded = false;
          onAdDismissed?.call();
        },
      );
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {
          onRewarded(reward);
        },
      );
      _rewardedAd = null;
    } else {
      ScaffoldMessenger.of(NavigatorState().context).showSnackBar(
        const SnackBar(content: Text('Ad not available')),
      );
    }
  }

  void dispose() {
    _rewardedAd?.dispose();
  }
}
