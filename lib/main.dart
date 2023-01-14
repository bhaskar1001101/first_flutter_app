import 'dart:html';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  // get new word
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  // stores liked words
  var liked = <WordPair>[];

  void toggleFavorite() {
    if(liked.contains(current)) {
      liked.remove(current);
    } else {
      liked.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home')
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Liked Words')
                )
              ], 
              selectedIndex: 0,
              onDestinationSelected: (value) {
               print('selected: $value'); 
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: GeneratorPage(),
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    // Add Icon
    IconData icon;
    if(appState.liked.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          // centers column
          mainAxisAlignment: MainAxisAlignment.center, 

          children: [
            BigCard(pair: pair),

            // padding space in between
            SizedBox(height: 10,),

            // Elevatedbuttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // get next word
                    appState.getNext();
                    // print('button pressed!!');
                  }, 
                  child: Text('Next Word'),
                ),

                // Space In Between
                SizedBox(width: 10),

                // Like Button
                ElevatedButton.icon(
                  onPressed: () {
                    // get next word
                    // appState.getNext();
                    appState.toggleFavorite();
                    // print('button pressed!!');
                  }, 
                  icon: Icon(icon),
                  label: Text('Like'),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.pair,
  }) : super(key: key);

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          pair.asLowerCase, 
          style: style,
          semanticsLabel: pair.asPascalCase,  // for screen readers
        ),
      ),
    );
  }
}
