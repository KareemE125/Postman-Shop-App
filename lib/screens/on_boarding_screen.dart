import 'package:flutter/material.dart';
import 'package:post_man_api/constants.dart';
import 'package:post_man_api/screens/auth_screens/login_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();

}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  bool isLastPage = false;
  final PageController _pageController = PageController();
  final List<OnBoardingPageBuilder> onBoardingScreens = 
  [
    OnBoardingPageBuilder(
        imageUrl: 'assets/images/onboarding1.png',
        headingText: 'Explore Many Products',
        subHeadingText: 'you can buy whatever you wish of products here in our store'
    ),
    OnBoardingPageBuilder(
        imageUrl: 'assets/images/onboarding2.png',
        headingText: 'Choose And Checkout',
        subHeadingText: 'choose your products and checkout, you can choose to pay in cash with delivery or with online payment'
    ),
    OnBoardingPageBuilder(
        imageUrl: 'assets/images/onboarding3.jpg',
        headingText: 'Get It Delivered',
        subHeadingText: 'get your products delivered safely and as quick as possible with our delivery service'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: [
          TextButton(
            child: Text('SKIP', style: kTextButton2Regular),
            style: ButtonStyle(
              overlayColor:
                  MaterialStateProperty.all(Colors.grey.withOpacity(0.2)),
            ),
            onPressed:(){ Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false); },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                itemCount: onBoardingScreens.length,
                itemBuilder: (_,index) => onBoardingScreens[index],
                physics: BouncingScrollPhysics(),
                controller: _pageController,
                onPageChanged:(index)
                {
                  if(index == onBoardingScreens.length-1) {setState((){ isLastPage = true; });}
                  else{setState((){ isLastPage = false; });}
                },
              ),
            ),
            Row(
              children: [
                Expanded(child: Container()),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: onBoardingScreens.length,
                  effect: ExpandingDotsEffect(dotHeight: 12,dotWidth: 12,dotColor: Colors.black12, activeDotColor: Theme.of(context).primaryColor),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      child: Text(isLastPage?'FINISH':'NEXT', style: kTextButton2Regular),
                      style: ButtonStyle(overlayColor: MaterialStateProperty.all(Colors.grey.withOpacity(0.2))),
                      onPressed: ()
                      {
                        if(isLastPage)
                        {
                          Navigator.of(context).pushNamedAndRemoveUntil(LoginScreen.routeName, (route) => false);
                        }
                        else
                        {
                          _pageController.nextPage(duration: Duration(milliseconds: 500), curve: Curves.decelerate);
                        }

                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class OnBoardingPageBuilder extends StatelessWidget {

  final String imageUrl;
  final String headingText;
  final String subHeadingText;

  OnBoardingPageBuilder({required this.imageUrl, required this.headingText, required this.subHeadingText});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            imageUrl,
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              Text(
                headingText,
                style: kTextHeadRegular,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  subHeadingText,
                  style: kTextSubRegular,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
