import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rescue_army/firebase_options.dart';
import 'package:rescue_army/screens/call_screen.dart';
import 'package:rescue_army/screens/eventinfo_screen.dart';
import 'package:rescue_army/screens/events_screen.dart';
import 'package:rescue_army/screens/home_screen.dart';
import 'package:rescue_army/screens/notification_screen.dart';
import 'package:rescue_army/screens/profile_page.dart';
import 'package:rescue_army/screens/signin_screen.dart';
import 'package:rescue_army/screens/signup_screen.dart';
import 'package:rescue_army/stores/app_store.dart';
import 'package:rescue_army/utils/routes.dart';
import 'package:velocity_x/velocity_x.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  await FlutterDownloader.initialize(debug: false, ignoreSsl: false);
  runApp(VxState(store: AppStore(), child: const App()));
}

late AndroidNotificationChannel channel;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // print('Handling a background message ${message.messageId}');
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? AppRoutes.home
          : AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.signin: (context) => const SigninScreen(),
        AppRoutes.signup: (context) => const SignupScreen(),
        AppRoutes.profile: (context) => const Profile(),
        AppRoutes.notification: (context) => const NotificationScreen(),
        AppRoutes.eventinfo: (context) => EventInfoScreen(),
        AppRoutes.call: (context) => CallScreen(),
        AppRoutes.events: (context) => EventsScreen(),
      },
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(),
      darkTheme: ThemeData.light(),
    );
  }
}
