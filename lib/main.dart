import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:social_media_clone/providers/user_provider.dart';
import 'package:social_media_clone/responsive/mobile_screen_layout.dart';
import 'package:social_media_clone/responsive/responsive_layout.dart';
import 'package:social_media_clone/responsive/web_screen_layout.dart';
import 'package:social_media_clone/screens/login_screen.dart';
import 'package:social_media_clone/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // initialise app based on platform- web or mobile
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyA1IID4oU0-PyWLmSuvBSysYswhzxL4wg0",
          appId: "1:824488871223:web:fe48aa99be15ca69f206b2",
          messagingSenderId: "824488871223",
          projectId: "insta-flutter-clone-f1096",
          storageBucket: 'insta-flutter-clone-f1096.appspot.com'),
    );
  } else {
    Platform.isAndroid
        ? await Firebase.initializeApp(
            options: const FirebaseOptions(
                apiKey: "AIzaSyBSOEIHRagvHxJWsLmDSE3_GzTol46tAak",
                appId: "1:824488871223:android:b3e4ed1034bcd3c7f206b2",
                messagingSenderId: "824488871223",
                projectId: "insta-flutter-clone-f1096",
                storageBucket: "insta-flutter-clone-f1096.appspot.com"))
        : await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Social Media Clone',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              // Checking if the snapshot has any data or not
              if (snapshot.hasData) {
                // if snapshot has data which means user is logged in then we check the width of screen and accordingly display the screen layout
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }

            // means connection to future hasnt been made yet
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
