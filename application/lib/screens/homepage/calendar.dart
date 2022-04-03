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
  @override
  void initState() {
    super.initState();
    _getDatabaseDates(); // on initial start, add dates to _availableDates list
  }

  void _getDatabaseDates() async { //get all availableDates from database

    String? uid = _authService.userID;
    DatabaseReference artistDatesRef = database.ref("Artists/$uid/availableDates"); //get the reference for current user
    List<dynamic> allDates = []; //a list that will contain all the dates stored in the database for an artist (as strings)
    DatabaseEvent artistDates = await artistDatesRef.orderByValue().once(); //get artistDates as a data snapshot
    for (var date in artistDates.snapshot.children){ //add each date to list of dates
      allDates.add(date.value);
    }
    _availableDates = allDates; //set global list of dates
  }

  List _getEventsForDay(DateTime day){ //return a list of "events" that exist on a day. In this case there can only be one event on any particular day, so return a single value array or empty array
    List available = [];
    if(_availableDates.contains(day.toString())){
      available.add(true);
    }
    return available;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
            backgroundColor: Colors.cyan,
            elevation: 0.0,
            title: Text('Calendar'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/account');
              },
            )),
      body:Column(children: [
          TableCalendar(
            calendarBuilders: CalendarBuilders(
              singleMarkerBuilder: (context, day, events) { //changes the look of the event markers. Needs to be made to look good.
                return Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    color: Colors.blue),
                  width: 10.0,
                  height: 10.0,
              
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                );
              },
              // selectedBuilder: (context, day, events) { //changes look of days that are selected
              //   return Container(
              //     decoration: BoxDecoration(
              //       shape: BoxShape.rectangle,
              //       color: Colors.blue),
              //     width: 10.0,
              //     height: 10.0,
              
              //     margin: const EdgeInsets.symmetric(horizontal: 1.5),
              //   );
              // }
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
              DatabaseReference artistDatesRef = database.ref("Artists/$uid/availableDates"); //get the reference for current user's availible Dates
              DatabaseEvent artistDate = await artistDatesRef.orderByValue().equalTo(selectedDay.toString()).once(); //query for finding if the selected day exists in the database
              if(!artistDate.snapshot.exists){ //if this day does not already exist in the database
                DatabaseReference addedListItemRef = artistDatesRef.push(); //create new spot for selected day
                addedListItemRef.set(selectedDay.toString()); //set the current date to be in the spot just created
              }
              else{ //delete day from database
                for(var child in artistDate.snapshot.children){ //delete each key of the children from the artistDate query (should be only one child)
                  artistDatesRef.child(child.key!).remove();
                }
              }
              setState(() { //update the longpressed day to be "selected"
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
                _getDatabaseDates(); //update _availableDates from new database values
              });
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