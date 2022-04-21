import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:application/services/auth.dart';

// User can edit their personal calendar hear and days that they are availible will be stored in the database
class BookdCalendar extends StatefulWidget{
  @override
  BookdCalendarState createState() => BookdCalendarState();
}
class BookdCalendarState extends State<BookdCalendar> {
  final AuthService _authService = AuthService();
  FirebaseDatabase database = FirebaseDatabase.instance;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List _availableDates = [];

  var profileType; // added so we can navigate to appropriate user account
  @override
  void initState() {
    super.initState();
    _getDatabaseDates(); // on initial start, add dates to _availableDates list
    _selectedDay = _focusedDay;

    _getDatabaseProfileType(); // get profile type
  }

  void _getDatabaseDates() async { //get all availableDates from database

    String? uid = _authService.userID;
    
    DatabaseReference databaseRef = database.ref(); //get the reference
    DatabaseEvent userType = await databaseRef.child("Users/$uid/profileType").once(); //event for getting the profile type for comparison
    DatabaseEvent userDates;
    if(userType.snapshot.value == "artist"){
      userDates = await databaseRef.child("Artists/$uid/availableDates").orderByValue().once();
    }
    else{//(userType == "Venue"){
      userDates = await databaseRef.child("Venues/$uid/availableDates").orderByValue().once();
    }
    List<dynamic> allDates = []; //a list that will contain all the dates stored in the database for an user (as strings)
    for (var date in userDates.snapshot.children){ //add each date to list of dates
      allDates.add(date.value);
    }
    setState(() { //set the state once data has arrived
      _availableDates = allDates; //set global list of dates
    });
  }

  List _getEventsForDay(DateTime day){ //return a list of "events" that exist on a day. In this case there can only be one event on any particular day, so return a single value array or empty array
    List available = [];
    if(_availableDates.contains(day.toString())){
      available.add(true);
    }
    return available;
  }

  void _getDatabaseProfileType() async {
    String? uid = _authService.userID;
    DatabaseReference profileTypeRef = database.ref("Users/$uid/profileType");
    DatabaseEvent profileTypeEv = await profileTypeRef.once();
    profileType = profileTypeEv.snapshot.value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body:Column(children: [
          TableCalendar(
            calendarBuilders: CalendarBuilders(
              singleMarkerBuilder: (context, day, events) { //changes the look of the event markers.
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.cyan),
                  width: 60.0,
                  height: 13.0,
                );
              },
              selectedBuilder: (context, day, events) { //changes look of days that are selected
                return Container(
                  //duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.orangeAccent),
                  width: 45.0,
                  height: 45.0,              
                  child: Center(
                    child: Text(day.day.toString(), style: const TextStyle(fontSize: 14, color: Colors.black)),)                  
                );
              },
              todayBuilder: (context, day, events) {
                return Container(
                  //duration: Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(100, 255, 171, 64)),
                  width: 45.0,
                  height: 45.0,              
                  child: Center(
                    child: Text(day.day.toString(), style: const TextStyle(fontSize: 14, color: Colors.black)),)                  
                );
              }
            ),
            firstDay: DateTime.utc(DateTime.now().year, DateTime.now().month, 1),
            lastDay: DateTime.utc(DateTime.now().year+5, DateTime.now().month, 1),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) { //mark the day on the calendar that is currently selected
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) { //update focused day and selected day 
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            onDayLongPressed: (selectedDay, focusedDay) async{ //on long press add date to availibility days
              String? uid = _authService.userID;
              DatabaseReference databaseRef = database.ref(); //get the reference for database
              DatabaseEvent userType = await databaseRef.child("Users/$uid/profileType").once(); //get a data snapshot of the user type for comparison
              String userTypePath;         
              if(userType.snapshot.value == "artist"){
                userTypePath = "Artists/$uid/availableDates";
              }
              else{//(userType == "Venue"){
                userTypePath = "Venues/$uid/availableDates";
              }
              DatabaseEvent userDate = await databaseRef.child(userTypePath).orderByValue().equalTo(selectedDay.toString()).once(); //query for finding if the selected day exists in the database
              if(!userDate.snapshot.exists){ //if this day does not already exist in the database
                DatabaseReference addedListItemRef = databaseRef.child(userTypePath).push(); //create new spot for selected day
                addedListItemRef.set(selectedDay.toString()); //set the current date to be in the spot just created
              }
              else{ //delete day from database
                for(var child in userDate.snapshot.children){ //delete each key of the children from the artistDate query (should be only one child)
                  databaseRef.child(userTypePath + "/" + child.key!).remove();
                }
              }
              setState(() { //update the longpressed day to be "selected"
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
              _getDatabaseDates(); //update _availableDates from new database values
            },
            onFormatChanged: (format) { //if format if calendar is changed, update it
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: _getEventsForDay, //get events for a particular day.
          ),
        ],)
    );
  }
}