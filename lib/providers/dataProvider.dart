
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';



class DataProvider with ChangeNotifier{
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  final List<String> _notesList = [

  ];


  List<String> get notesList {     // getter function
    getNotesList();
    return [..._notesList];  // ... is used because the copy of that data is stored in  variable
  }

  Future getNotesList() async {

    await notes.get().then((querySnapshot) {
      //querySnapshot is the list of all the documents in  collection\
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