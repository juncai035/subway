import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new SubwayApp());

class SubwayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final wordPair = new WordPair.random();

    return new MaterialApp(
        title: '以色列地铁项目',
        theme: new ThemeData(
          primaryColor: Colors.red
        ),
        home: new RandomWords());
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _saved = new Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('以色列地铁项目'),
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  void _pushSaved() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      final tiles = _saved.map((pair) {
        return new ListTile(
          title: new Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });
      final divided =
          ListTile.divideTiles(context: context, tiles: tiles).toList();

      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Saved Suggestions'),
        ),
        body: new ListView(
          children: divided,
        ),
      );
    }));
  }

  Widget _buildSuggestions() {
    return new ListView.builder(
        padding: const EdgeInsets.all(16.0),
        //对于每个建议的单词都会调用一次itemBuilder，然后将单词对添加到ListTitle行中
        //在偶数行，该函数会为单词对添加一个ListTitle Row
        //在奇数行，该函数会添加一个分割线widget，来分割相邻的词对
        //注意，在小屏幕上，分割线看起来比较吃力
        itemBuilder: (context, i) {
          //在每一列之前，添加一个1像素高的分割线widget
          if (i.isOdd) {
            return new Divider();
          }

          //语法 “i ~/ 2” 表示i除以2，但返回值是整型（向下取整），比如i为：1,2,3,4,5时
          //结果为：0,1,1,2,2
          final index = i ~/ 2;
          //如果是建议列表后最后一个单词对
          if (index >= _suggestions.length) {
            //接着再生成10个单词对，然后添加到建议列表
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}
