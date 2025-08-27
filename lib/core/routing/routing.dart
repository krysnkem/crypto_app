import 'package:crypto_app/ui/asset_list_page.dart';
import 'package:crypto_app/ui/splash_page.dart';
import 'package:flutter/material.dart';

class RoutePath {
  RoutePath._();
  static const String splash = '/';
  static const String assetList = '/asset-list';
}

class Routing {
  static Route<dynamic>? Function(RouteSettings) onGenerateRoute = (settings) {
    if (settings.name == RoutePath.assetList) {
      return MaterialPageRoute(builder: (_) => AssetListPage());
    }
    return MaterialPageRoute(builder: (_) => SplashPage());
  };
}
