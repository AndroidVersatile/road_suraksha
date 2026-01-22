import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gauvigyaan/constants/api_urls.dart';
import 'package:gauvigyaan/constants/assets.dart';
import 'package:gauvigyaan/constants/common_text.dart';
import 'package:gauvigyaan/providers/home_provider.dart';
import 'package:gauvigyaan/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:gauvigyaan/widgets/error_utils.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../routing/app_pages.dart';
import 'appDrawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  var exploreList = [
    {
      "title": "ताज़ा\nजानकारी",
      "image": Assets.latestNews,
      "navigate": AppPages.latestNews,
    },
    {
      "title": "भारतीय गौदर्शन\nपुस्तक",
      "image": Assets.book,
      "navigate": AppPages.gauVigyaanBooks,
    },
    {
      "title": "विविद\nजानकारी",
      "image": Assets.differentNews,
      "navigate": AppPages.differentNews,
    },
    {
      "title": "अन्य\nजानकारी",
      "image": Assets.otherNews,
      "navigate": AppPages.otherNews,
    },
  ];

  var examList = [
    {
      "index": "0",
      "title": "परीक्षा प्रारंभ करे",
      "image": Assets.exam,
      "navigate": AppPages.liveInstruction,
    },
    // {
    //   "index": "1",
    //   "title": "डेमो परीक्षा",
    //   "image": Assets.demoExam,
    //   "navigate": AppPages.instruction,
    // },
    {
      "index": "1",
      "title": "अपना सुझाव भेजे",
      "image": Assets.feedback,
      "navigate": AppPages.feedback,
    },
  ];
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        await context.read<HomeProvider>().getSlider();
        await context.read<HomeProvider>().getUserDetails();
        await context.read<HomeProvider>().getExamInstruction();
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeProvider>(context);
    var slider = provider.sliderList;
    return Scaffold(
      key: scaffoldKey,
      drawer: AppDrawer(),
      body: Container(
        // decoration: const BoxDecoration(
        //     image: DecorationImage(
        //   image: AssetImage(
        //     Assets.bg,
        //   ),
        //   fit: BoxFit.fill,
        // )),
        child: Column(
          children: [
            AppTheme.verticalSpacing(mul: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    scaffoldKey.currentState?.openDrawer();
                  },
                  icon: const Icon(Icons.menu),
                  color: Color(0xFF850000),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      Assets.appLogo,
                      height: 50,
                      width: 50,
                      fit: BoxFit.fill,
                    ),
                    Text(
                      CommonText.appName,
                      textAlign: TextAlign.center,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF850000),
                      ),
                    )
                  ],
                ),
              ],
            ),
            Container(
              margin: AppTheme.boxPadding * 1.2,
              padding: AppTheme.boxPadding,
              height: context.screenHeight - 120,
              width: context.screenWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radius),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppTheme.radius),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    /// 🔹 Background Image
                    Image.asset(
                      Assets.bg,
                      fit: BoxFit.cover,
                    ),

                    /// 🔹 Blur Effect
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 2, // Horizontal blur intensity
                          sigmaY: 2, // Vertical blur intensity
                        ),
                        child: Container(
                          color: Colors.white.withOpacity(0.1), // optional overlay
                        ),
                      ),
                    ),

                    /// 🔹 Foreground Content (Your Existing Widgets)
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CarouselSlider(
                            options: CarouselOptions(
                              height: 250,
                              aspectRatio: 0.5,
                              viewportFraction: 1,
                              autoPlay: true,
                              enlargeCenterPage: true,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _current = index;
                                });
                              },
                            ),
                            carouselController: _controller,
                            items: slider.map((e) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(AppTheme.radius),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: ApiUrls.sliderImageUrl + e.imageUrl,
                                  fit: BoxFit.fill,
                                  height: 300,
                                  errorWidget: (context, url, error) => Container(
                                    height: 300,
                                    width: context.screenWidth,
                                    color: Colors.white,
                                    child: Image.asset(Assets.appLogo),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          AppTheme.verticalSpacing(mul: 2),
                          Text(
                            'परीक्षा',
                            textAlign: TextAlign.start,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          AppTheme.verticalSpacing(mul: 2),

                          Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            children: examList.map((e) {
                              return GestureDetector(
                                onTap: () async {
                                  if (e['index'] == '0') {
                                    var res = await provider.loadLiveExam();
                                    if (res['Status'] == 'True') {
                                      context.pushNamed(e['navigate']!);
                                    } else {
                                      ErrorUtils.showSimpleInfoDialog(
                                        context,
                                        content: Text(res['Message']),
                                      );
                                    }
                                  } else if (e['index'] == '1') {
                                    var res = await provider.loadDemoExam();
                                    if (res == 200) {
                                      context.pushNamed(e['navigate']!);
                                    }
                                  } else {
                                    context.pushNamed(e['navigate']!);
                                  }
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: context.screenWidth / 4.5,
                                      margin: AppTheme.boxPadding,
                                      width: context.screenWidth / 4.5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(AppTheme.radius),
                                      ),
                                      child: Image.asset(e['image']!),
                                    ),
                                    Text(
                                      e['title']!,
                                      textAlign: TextAlign.center,
                                      style: context.textTheme.titleSmall,
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          ),

                          AppTheme.verticalSpacing(mul: 5),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
