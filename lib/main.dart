import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/rasoi_provider.dart';
import 'theme/app_theme.dart';
import 'screens/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BhandaarApp());
}

class BhandaarApp extends StatelessWidget {
  const BhandaarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => RasoiProvider())],
      child: MaterialApp(
        title: 'Bhandaar Rasoi',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const MainNavigationScreen(),
      ),
    );
  }
}
