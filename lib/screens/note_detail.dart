import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:sqllite_ex/models/note.dart';
import 'package:sqllite_ex/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  NoteDetail(this.note, this.appBarTitle);

  @override
  _NoteDetailState createState() =>
      _NoteDetailState(this.note, this.appBarTitle);
}

class _NoteDetailState extends State<NoteDetail> {
  String appBarTitle;
  Note note;
  _NoteDetailState(this.note, this.appBarTitle);

  DatabaseHelper databaseHelper = DatabaseHelper();

  static var _priorities = ['High', 'Low'];
  TextEditingController tittleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    tittleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
            top: 15.0,
            left: 10.0,
            right: 10.0,
          ),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: DropdownButton(
                  items: _priorities.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  style: textStyle,
                  value: getPriorityAsString(note.priorities),
                  onChanged: (valueSelectedByUsers) {
                    setState(() {
                      print(valueSelectedByUsers);
                      updatePriorityAsInt(valueSelectedByUsers);
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: tittleController,
                  style: textStyle,
                  onChanged: (value) {
                    print('tittleController');
                    updateTitle();
                  },
                  decoration: InputDecoration(
                    labelText: 'Tittle',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: descriptionController,
                  style: textStyle,
                  onChanged: (value) {
                    print('descriptionController');
                    updateDescription();
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          print('Save Button is pressed!');
                          _save();
                        },
                      ),
                    ),
                    Container(
                      width: 15.0,
                    ),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          print('Delete Button is pressed!');
                          _delete();
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  //Convert String priority to Int for saving into database
  void updatePriorityAsInt(String priority) {
    switch (priority) {
      case 'High':
        note.priorities = 1;
        break;
      case 'Low':
        note.priorities = 2;
        break;
    }
  }

  //Convert to String from Int for display on View
  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void updateTitle() {
    note.title = tittleController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen();
    int result;
    note.date = DateTime.now().toString();

    if (note.id != null) {
      result = await databaseHelper.updateNote(note);
    } else {
      result = await databaseHelper.insertNote(note);
    }

    if (result != 0) {
      //Success
      _showAlertDialog('Status', 'Note Save Successful');
    } else {
      //failure
      _showAlertDialog('Status', 'Note Save Unsuccessful');
    }
  }

  void _delete() async {
    moveToLastScreen();
    int result;
    if (note.id == null) {
      _showAlertDialog('Status', 'No note to deleted');
    }

    result = await databaseHelper.deleteNote(note.id);

    if (result != 0) {
      _showAlertDialog('Status', 'Note is deleted!');
    } else {
      _showAlertDialog('Status', 'Failed to deleted note');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
