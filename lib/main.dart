import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receitas/PAGES/splash_screen.dart';
import 'package:receitas/providers/receita_provider.dart';

void main() => runApp(const Receitas());

class Receitas extends StatelessWidget {
  const Receitas({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReceitaProvider>(
      create: (_) => ReceitaProvider()..carregarReceitas(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const SplashScreen(),
      ),
    );
  }
}
