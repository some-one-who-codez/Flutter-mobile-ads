import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final BannerAd myBanner = BannerAd(
    adUnitId: Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716', // sets platform specific ad ids
    size: AdSize
        .banner, // sets 320 x 50 banner size you can set custom banner sizes using:
    // size: AdSize(
    //   width: 300,
    //   height: 70,
    // ),
    // or you can use the different sizes as specified in the documentation. See README for more info.
    request: AdRequest(),
    listener: BannerAdListener(
      onAdFailedToLoad: (ad, error) {
        print('Ad failed with error: $error'); // prints error
        ad.dispose(); // disposes of ad
      },
    ),
  );

  RewardedAd myRewarded;
  InterstitialAd myInterstitial;

  @override
  void initState() {
    super.initState();

    myBanner.load(); // loads banner ad
    _createRewardedAd(); // create rewarded ad
    _createInterstitialAd(); // create interstitial ad
  }

  @override
  void dispose() {
    super.dispose();
    myBanner.dispose(); // disposes of banner when UI is disposed of
    myRewarded.dispose(); // disposes of rewarded when UI is disposed of
    myInterstitial.dispose(); // disposes of interstitial when UI is disposed of
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ads',
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 30.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  // show interstitial
                  _showInterstitialAd();
                },
                child: Text('Interstitial Ad'),
              ),
              ElevatedButton(
                onPressed: () {
                  // show rewarded ad
                  _showRewardedAd();
                },
                child: Text('Rewarded Ad'),
              ),
              ElevatedButton(
                onPressed: () {
                  // go to next page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SecondPage(),
                    ),
                  );
                },
                child: Text('Go to next page'),
              ),
              Spacer(),
              Container(
                height:
                    myBanner.size.height.toDouble(), // sets container height
                width: myBanner.size.width.toDouble(), // sets container width
                child: AdWidget(
                  ad: myBanner, // ad must be loaded before insertion to widget tree
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showRewardedAd() {
    myRewarded.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecondPage(),
          ),
        );
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
    );

    myRewarded.show(
      onUserEarnedReward: (ad, reward) {
        print('You eanred ${reward.amount} ${reward.type}');
      },
    );
  }

  _showInterstitialAd() {
    myInterstitial.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SecondPage(),
          ),
        );
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
    );
    myInterstitial.show();
  }

  _createRewardedAd() {
    RewardedAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'
          : 'ca-app-pub-3940256099942544/1712485313', // test ad ids for different platforms
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdFailedToLoad: (LoadAdError error) {
          print('Ad failed with error: $error');
        },
        onAdLoaded: (RewardedAd ad) {
          setState(() {
            this.myRewarded = ad;
          });
        },
      ),
    ); // create rewarded ad
  }

  _createInterstitialAd(){
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910', // test ad ids for different platforms
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdFailedToLoad: (LoadAdError error) {
          print('Ad exited with error: $error');
        },
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            this.myInterstitial = ad;
          });
        },
      ),
    );
  }
}

class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final BannerAd myBanner = BannerAd(
    adUnitId: Platform.isAndroid
        ? 'ca-app-pub-3940256099942544/6300978111'
        : 'ca-app-pub-3940256099942544/2934735716', // sets platform specific ad ids
    size: AdSize
        .banner, // sets 320 x 50 banner size you can set custom banner sizes using:
    // size: AdSize(width: 300, height: 70,)
    request: AdRequest(),
    listener: BannerAdListener(
      onAdFailedToLoad: (ad, error) {
        print('Ad failed with error: $error'); // prints error
        ad.dispose(); // disposes of ad
      },
    ),
  );

  @override
  void initState() {
    super.initState();
    myBanner.load(); // loads banner
  }

  @override
  void dispose() {
    super.dispose();
    myBanner.dispose(); // disposes of banner when UI is disposed of
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(),
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Second Page',
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Spacer(),
              Container(
                height:
                    myBanner.size.height.toDouble(), // sets container height
                width: myBanner.size.width.toDouble(), // sets container width
                child: AdWidget(
                  ad: myBanner, // ad must be loaded before insertion to widget tree
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
