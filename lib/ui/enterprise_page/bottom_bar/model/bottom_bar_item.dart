import 'package:AppleYonsei/ui/enterprise_page/common/model/base_model.dart';

class BottomBarItem extends BaseModel {
  static String assertPath = 'assets/icon/';

  BottomBarItem._(String label, String assetImage)
      : super(label, assertPath + assetImage);
  static final BottomBarItem _wishlist = BottomBarItem._(
    '예약',
    'heart_icon.png',
  );
  static final BottomBarItem _inbox = BottomBarItem._(
    '예약확정',
    'inbox_icon.png',
  );
  static final BottomBarItem _trips = BottomBarItem._(
    '홈',
    'airbnb_icon.png',
  );
  static final BottomBarItem _account = BottomBarItem._(
    '계정',
    'account_icon.png',
  );

  static List<BottomBarItem> items = [
    _wishlist,
    _trips,
    _inbox,
    _account
  ];
}
