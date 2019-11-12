class Note {
  int _id;
  String _title;
  String _description;
  String _date;
  int _priorities;

  Note(this._title, this._date, this._priorities, [this._description]);
  Note.withID(this._id, this._title, this._date, this._priorities,
      [this._description]);

  //Get value
  int get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  int get priorities => _priorities;

  //Set value

  set title(String newTittle) {
    if (newTittle.length <= 255) {
      this._title = newTittle;
    }
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set priorities(int newPriorities) {
    if (newPriorities >= 1 && newPriorities <= 2) {
      this._priorities = newPriorities;
    }
  }

  set date(String newDate) {
    this._date = newDate;
  }

  //Convert Note object to Map Object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();

    if (_id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['priorities'] = _priorities;
    map['date'] = _date;

    return map;
  }

  //Extract Note Object from Map Object
  Note.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._priorities = map['priorities'];
    this._date = map['date'];
  }
}
