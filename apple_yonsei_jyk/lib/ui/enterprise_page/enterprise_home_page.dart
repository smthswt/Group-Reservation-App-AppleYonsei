import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';

import 'package:AppleYonsei/ui/enterprise_page/explore_page/explore_page.dart';
import 'package:AppleYonsei/ui/enterprise_page/wishlist_page/wishlist_page.dart';
import 'package:AppleYonsei/ui/enterprise_page/inbox_page/inbox_page.dart';
import 'package:AppleYonsei/ui/enterprise_page/login_page/login_page.dart';
import 'package:AppleYonsei/ui/enterprise_page/trips_page/trips_page.dart';
import 'package:AppleYonsei/ui/enterprise_page/bottom_bar/custom_bottom_bar.dart';

class EnterpriseMyHomePage extends StatefulWidget {
  const EnterpriseMyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<EnterpriseMyHomePage> createState() => _EnterpriseMyHomePageState();
}

class _EnterpriseMyHomePageState extends State<EnterpriseMyHomePage> with AfterLayoutMixin {
  int _bottomBarIndex = 2;
  bool _isLoading = true;
  final Size _loadingIconSize = const Size(100, 100);

  @override
  void initState() {
    super.initState();
  }

  Widget bodyWidget() {
    if (_isLoading) {
      return Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height / 2 - 65,
            left: MediaQuery.of(context).size.width / 2 -
                _loadingIconSize.width / 2,
            child: SizedBox(
              height: _loadingIconSize.height,
              width: _loadingIconSize.width,
              child: const Image(
                image: AssetImage(
                  'assets/icon/airbnb_icon.png',
                ),
                color: Colors.blue,
              ),
            ),
          ),
        ],
      );
    }
    switch (_bottomBarIndex) {
      case 0:
        return const WishlistPage(isShrink: false);
      case 1:
        return const InboxPage(
          isShrink: false,
        );
      case 3:
        return const LoginPage(
          isShrink: false,
        );
      case 2:
      default:
        return const TripsPage(
          isShrink: false,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: bodyWidget(),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  height: 65,
                )
              : SizedBox(
                  height: 65,
                  child: CustomBottomBar(
                    index: _bottomBarIndex,
                    selectedIndex: (index) {
                      setState(
                        () {
                          _bottomBarIndex = index;
                        },
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) async {
    Future.delayed(
      const Duration(seconds: 1),
      () => {
        setState(() {
          _isLoading = false;
        })
      },
    );
  }
}
