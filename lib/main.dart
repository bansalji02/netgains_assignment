import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:netgains_assignment/services/currentWeather.dart';
import 'package:netgains_assignment/services/newsPage.dart';
import 'package:provider/provider.dart';
import 'package:netgains_assignment/providers/dataProvider.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // WidgetFlutterBinding is used to interact with flutter engine
  await Firebase
      .initializeApp(); // Firebase.initializedApp() needs to call native code to initialize firebase,
  // and since the plugins needs to use platform channels to call the native code,which is done asynchronously by calling ensureinitialized()
  //to make sure that we have an instance of widget binding.
  // video in the group..
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => DataProvider(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  TextEditingController noteValueController = TextEditingController();

  var appBarHeight = AppBar().preferredSize.height;

  MyHomePage({super.key});
  //value of note to be added to firebase
  @override
  Widget build(BuildContext context) {
    final List<String> notesList = Provider.of<DataProvider>(context).notesList;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Hello NetGains!'),
            ),
            ListTile(
              title: const Text("Let's See Weather"),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CurrentWeatherPage()),
                );
                //Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Show me latest News!'),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewsPage()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text('NetGains Weather!'),
      ),

      body: Container(
        child: Column(children: [
          Container(
            decoration: BoxDecoration(
              

              border: Border.all(
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            height: MediaQuery.of(context).size.height * (0.3) - appBarHeight,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: "Enter your Note",
                    border: OutlineInputBorder(),
                  ),
                  controller: noteValueController,
                  // onChanged: (val) {
                  //   noteValue = val;
                  // },
                ),
                 ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: (){
                    Provider.of<DataProvider>(context,listen: false).addNewNote(noteValueController.text);
                  },
                  child: const Text("Save"),


                )
              ],
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height * (0.7) - appBarHeight,
              child: ListView.builder(
                  itemCount: notesList.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    return ListTile(
                      title: Text(notesList[index]),
                      onTap: null,
                    );
                  })),
        ]),
      ),
    );
  }
}
