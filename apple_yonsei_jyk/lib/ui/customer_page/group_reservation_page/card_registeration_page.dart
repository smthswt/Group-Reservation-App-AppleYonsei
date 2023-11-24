import 'package:flutter/material.dart';
import 'package:AppleYonsei/ui/enterprise_page/common/animated_scale_screen_widget.dart';
import 'package:AppleYonsei/ui/enterprise_page/profile_page/login_overlay_widget.dart';

class CardRegisterationPage extends StatefulWidget {
  final bool isShrink;
  const CardRegisterationPage({Key? key, required this.isShrink}) : super(key: key);

  @override
  _CardRegisterationPageState createState() => _CardRegisterationPageState();
}

class _CardRegisterationPageState extends AnimatedScaleScreenWidget<CardRegisterationPage> {
  bool _showOverlay = false;
  late AnimationController? overlayController;
  late Animation<double>? overlayAnimation;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    isShrink = widget.isShrink;
    overlayController = null;
    overlayAnimation = null;
  }

  @override
  void dispose() {
    super.dispose();
    if (!mounted) {
      overlayController!.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return animatedScaleWidget(
      SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 25.0, vertical: 35.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  const Text(
                    "보증금 카드 등록",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                      color: Colors.black87,
                      letterSpacing: 1.2,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Container(
                      height: 1.5,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                  ),
                  const Text(
                    "안녕하세요 밥플 사장님 계정에 오신 것을 환영합니다!",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 24.0,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Text(
                    "TEST.",
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
