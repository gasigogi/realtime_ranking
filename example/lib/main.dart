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
                  final RealtimeRankingIndexItem item =
                      RealtimeRankingIndexItem(
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
