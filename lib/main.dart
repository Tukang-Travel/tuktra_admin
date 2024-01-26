import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tuktra_admin/firebase_options.dart';
import 'package:tuktra_admin/provider/user_provider.dart';
import 'package:tuktra_admin/screens/welcome_screen.dart';
import 'package:tuktra_admin/utils/color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'Tukang Travel',
        theme: ThemeData(
          primarySwatch: tukangtravelColor,
        ),
        home: const WelcomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
