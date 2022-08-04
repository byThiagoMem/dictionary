import 'package:dictionary/app/modules/splash/splash_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      Modular.initialRoute,
      child: (context, args) => const SplashPage(),
    ),
  ];
}
