import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:go_router/go_router.dart';


import 'chooseplatform.dart';

void main() {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const MyHomePage(title: 'Практика 6'),
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

class _MyHomePageState extends State<MyHomePage> {
  int currentPageIndex = 0;

  List<String> messages = [];
  TextEditingController messageController = TextEditingController();

  void sendMessage() {
    String message = messageController.text;
    if (message.isNotEmpty) {
      setState(() {
        messages.add(message);
        messageController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
        Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        messages[index],
                        style: theme.textTheme.bodyLarge!
                            .copyWith(color: theme.colorScheme.onPrimary),
                      ),
                    ),
                  );
                }
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      decoration: const InputDecoration(
                        hintText: 'Сообщение...',
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: sendMessage,
                    color: Colors.deepPurple,
                  ),
                ],
              ),
            ),

          ],
        ),

        // settings
        Column(
          children: [

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


class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Text("Скоро тут можно будет войти"),
      ),
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