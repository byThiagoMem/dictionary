import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/components/custom_loading.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2)).then(
      (value) => Modular.to.navigate('/home/'),
    );
    return const Scaffold(
      body: Center(
        child: CustomLoading(),
      ),
    );
  }
}
