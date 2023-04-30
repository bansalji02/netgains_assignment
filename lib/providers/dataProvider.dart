
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';



class DataProvider with ChangeNotifier{
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  final List<String> _notesList = [
    // Class(name: "3CE12", subject: "ML", instructor: "Navdeep"),
    // Class(name: "3CE34", subject: "ML", instructor: "Navdeep"),
    // Class(name: "3CE56", subject: "ML", instructor: "Navdeep"),
    // Class(name: "3CE78", subject: "ML", instructor: "Navdeep"),
  ];


  List<String> get notesList {     // getter function
    getNotesList(); //calling the classes function
    return [..._notesList];  // ... is used because the copy of that data is stored in classes variable
  }

  Future getNotesList() async {
    //_classes.clear();

    await notes.get().then((querySnapshot) {
      //querySnapshot is the list of all the documents in classes collection\
      _notesList.clear();
      for (var element in querySnapshot.docs) {
        _notesList.add(element.get('note'));
      }
    });

    notifyListeners();
  }
  void  addNewNote(String note)  {
     notes.add({
      'note':note
    });
    //no need to add notify listener here
  }



}