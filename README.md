# RealtimeRanking
[![Pub](https://img.shields.io/pub/v/realtime_ranking.svg)](https://pub.dartlang.org/packages/realtime_ranking)

## Intoduction
![realtime_ranking](https://user-images.githubusercontent.com/29463340/159152379-3e209a82-0647-4a2e-84aa-bba38dd0b616.gif)

## Usage

### Normal

```dart
import 'package:flutter/material.dart';
import 'package:realtime_ranking/realtime_ranking.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Theme(
            data: Theme.of(context).copyWith(
              primaryColor: Colors.black,
              backgroundColor: Colors.white,
            ),
            child: RealtimeRanking(
              header: RealtimeRankingNormalHeader(
                item: RealtimeRankingNormalItem(
                  title: 'Hello.',
                  subtitle: '2022. 03. 20.',
                ),
                onTap: () {
                  print('Header Select!!');
                },
              ),
              animatedHeaders: List.generate(
                15,
                (index) {
                  final RealtimeRankingIndexItem item = RealtimeRankingIndexItem(
                    title: 'Ranking',
                    index: index + 1,
                  );
                  return RealtimeRankingIndexHeader(
                    item: item,
                    onTap: () {
                      print('${item.index}. ${item.title} Select!!');
                    },
                  );
                },
              ),
              keepAlive: false,
              isSelected: _isExpanded,
              trailing: RealtimeRankingIconButton(
                isSelected: _isExpanded,
                animated: true,
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

### Custom

``` dart
import 'package:flutter/material.dart';
import 'package:realtime_ranking/realtime_ranking.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Theme(
            data: Theme.of(context).copyWith(
              primaryColor: Colors.black,
              backgroundColor: Colors.white,
            ),
            child: RealtimeRanking.custom(
              header: GestureDetector(
                onTap: () {
                  print('Header Select!!');
                },
                child: Container(
                  color: Colors.red,
                ),
              ),
              animatedHeaders: [
                Container(
                  color: Colors.blue,
                ),
                Container(
                  color: Colors.black,
                ),
              ],
              keepAlive: true,
              isSelected: _isExpanded,
              trailing: RealtimeRankingIconButton(
                isSelected: _isExpanded,
                animated: true,
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```
