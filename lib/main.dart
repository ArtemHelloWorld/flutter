import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'loginpage.dart';
import 'userprofile.dart';
import 'chooseplatform.dart';
import 'chats.dart';

void main() {
  runApp(const MyApp());
}

final getIt = GetIt.instance.registerSingleton(Admins());
class Admins {
  String message = "Вы админ";
}

class UserInheritedWidget extends InheritedWidget {
  final Widget child;
  final String email;
  final String name;

  const UserInheritedWidget({
    Key? key,
    required this.child,
    required this.email,
    required this.name,
  }) : super(key: key, child: child);

  static UserInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserInheritedWidget>();
  }

  @override
  bool updateShouldNotify(UserInheritedWidget oldWidget) {
    return name != oldWidget.name || email != oldWidget.email;
  }
}


final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const MyHomePage(title: 'Итоговая работа'),
    ),
    GoRoute(
      path: "/about",
      builder: (context, state) =>  AboutPage(),
    ),
    GoRoute(
      path: "/feedback",
      builder: (context, state) =>  FeedbackPage(),
    )
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(

      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      routerConfig: _router,

      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark,

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
Future<String> loading() {
  return Future.delayed(const Duration(seconds: 3), () => 'Загрузка заверешена');
}
void loadData() {
  Future<String> messageFuture = loading();
  String val = '';
  messageFuture.then((value) {
    val = value;
    print(val);
  });
}

Future<Map<String, dynamic>> fetchWeatherData(String city) async {
  const url = 'http://www.randomnumberapi.com/api/v1.0/random?min=-5&max=40&count=1';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return {'data': json.decode(response.body)};
  } else {
    throw Exception('Failed to load weather data');
  }
}



class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;


  Future<Map<String, dynamic>>? _weatherData;


  @override
  Widget build(  context) {
    _weatherData = fetchWeatherData("London");
    loadData();

    return Scaffold(
      // navbar
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.deepPurple,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Главная',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat),
            label: 'Чат',
          ),
          NavigationDestination(
            icon: Icon(Icons.cloudy_snowing),
            label: 'Погода',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'Настройки',
          ),
        ],
      ),


      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(widget.title),
      ),
      body: <Widget>[
        // homepage
        const Card(
          shadowColor: Colors.transparent,
          margin: EdgeInsets.all(8.0),
          child: SizedBox.expand(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image(image: AssetImage('assets/images/image.jpg')),

                  Center(
                    child: ChoosePlatform(),
                  ),

                  Text(
                    'Коновалов Артём Игоревич',
                  ),
                  Text(
                      'БСБО-12-22'
                  ),
                  Text(
                      '22Б0675'
                  ),
                ],
              ),
            ),
          ),
        ),

        // chat
        ChatsPage(),



        // weather
        Column(
          children: [
            Center(
                child: FutureBuilder<Map<String, dynamic>>(
                  future: _weatherData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      String imageUrl;
                      if (snapshot.data!['data']![0] < 5){
                        imageUrl = 'https://aif-s3.aif.ru/images/013/209/512dd3bd076af25ab229ea743096d7af.jpg';
                      }
                      else if (snapshot.data!['data']![0] < 15){
                        imageUrl = 'https://static.tildacdn.com/tild3133-3463-4033-b236-666461356539/_2023-09-14_12045968.png';
                      }
                      else if (snapshot.data!['data']![0] < 30){
                        imageUrl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR4ApWCUUaHWa_3uWIez7X_c3eBVzDb6Gc043kz518w-g&s';
                      }
                      else {
                        imageUrl = 'https://natureyav.ru/foto/zhara.jpg';
                      }


                      return Column(
                        children: [
                          Text("Температура сейчас ${snapshot.data!['data']![0]}°C"),
                            CachedNetworkImage(
                              imageUrl: imageUrl,
                              progressIndicatorBuilder: (context, url, progress) =>
                                  const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Center(
                                child: Icon(Icons.error, color: Colors.red),
                              ),
                            )
                        ]
                      );
                    }
                  },
              ),
            ),
          ],
        ),


        // settings
        Column(
          children: [
          ElevatedButton(
              onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfilePage())); },
              child: const Text("Профиль"),
            ),
          ElevatedButton(
            onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())); },
            child: const Text("Войти в аккаунт"),
          ),
          ElevatedButton(
            onPressed: () { Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage())); },
            child: const Text("Зарегистрироваться"),
          ),
          ElevatedButton(
            onPressed: () => context.go("/about"),
            child: const Text("О нас"),
          ),
          ElevatedButton(
            onPressed: () => context.go("/feedback"),
            child: const Text("Оставить фидбек"),
          )

        ]
        ),
      ][currentPageIndex]
      
    );
  }
}




class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text("Зарегистрироваться"),
      ),
    );
  }
}

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [Container(
        color: Colors.black,
        child: Center(
        child: Text("Страница о нас"),
    ),
    ),
    ElevatedButton(
    onPressed: () => context.go("/"),
    child: const Text("Назад"),
    )]);

  }
}

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Container(
      color: Colors.black,
      child: Center(
        child: Text("Тут можно будет оставить отзыв"),
      ),
    ),
    ElevatedButton(
    onPressed: () => context.go("/"),
    child: const Text("Назад"),
    )]);

  }
}