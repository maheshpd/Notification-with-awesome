import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:notification_with_awesome/navigationPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebasePushHandler);
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: 'key1',
            channelName: 'Proto Coders Point',
            channelDescription: 'Notification example',
            defaultColor: const Color(0xFF9050DD),
          ledColor: Colors.white,
          playSound: true,
        enableLights: true,
        enableVibration: true)
      ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/navigationPage': (context) => const NavigationPage()
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            FirstTopic();
          },
          child: const Icon(
              Icons.circle_notifications
          ),
        ),
      ),
    );
  }
  
  void Notify() async {
   await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 1,
            channelKey: 'key1',
            title: 'This is Notification title',
            body: 'This is Body of Notification')
    );

   AwesomeNotifications().actionStream.listen((receivedNotification) {
        Navigator.of(context).pushNamed(
          '/navigationPage',
        );
   });
  }
  
}

void FirstTopic() async{
  await FirebaseMessaging.instance.subscribeToTopic('hotel').then((value) => print("Hotel 1"));
  
  FirebaseMessaging.onMessage.listen((RemoteMessage message) { 
    AwesomeNotifications().createNotification(content: NotificationContent(
        id: 1,
        channelKey: 'key1',
      title: message.notification?.title,
      body: message.notification?.body
    ));
  });
}


Future<void> _firebasePushHandler(RemoteMessage message) async {
    print("Message from push notification is ${message.data}");

    AwesomeNotifications().createNotificationFromJsonData(message.data);
}
