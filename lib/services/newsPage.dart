import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../components/custom_tile.dart';
import '../models/article_model.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest News Today!'),
      ),
      body: FutureBuilder(
        future: getLatestNews(),
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          //let's check if we got a response or not
          if (snapshot.hasData) {
            //Now let's make a list of articles
            print("this snapshot has data");
            List<Article>? articles = snapshot.data;
            return ListView.builder(
              //Now let's create our custom List tile
              itemCount: articles?.length,
              itemBuilder: (context, index) =>
                  customListTile(articles![index], context),
            );
          }
          else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

        },
      ),
    );
  }

  Future<List<Article>> getLatestNews() async {
    String apiKey = '9e41705b1971450abd0c4d6f7e346287';
    var url = Uri.parse(
        "http://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> body = json['articles'];

      List<Article> articles =
          body.map((dynamic item) => Article.fromJson(item)).toList();

      print("Successfully fetched the news");
      return articles;
    }
    else {

      throw Exception(response.body);
    }
  }
}
