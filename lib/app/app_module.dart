import 'package:dictionary/app/modules/home/home_module.dart';
import 'package:dictionary/app/modules/splash/splash_module.dart';
import 'package:dictionary/app/shared/repository/dictionary_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.lazySingleton((i) => DictionaryRepository()),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: SplashModule()),
    ModuleRoute('/home', module: HomeModule()),
  ];
}
