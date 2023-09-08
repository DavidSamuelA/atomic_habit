import 'package:atomic_habit/database_helper.dart';
import 'package:atomic_habit/drawer_navigation.dart';
import 'package:atomic_habit/edit_habit_form_screen.dart';
import 'package:atomic_habit/habit_form_screen.dart';
import 'package:atomic_habit/habit_model.dart';
import 'package:atomic_habit/main.dart';
import 'package:flutter/material.dart';

class HabitListScreen extends StatefulWidget {
  const HabitListScreen({Key? key}) : super(key: key);

  @override
  State<HabitListScreen> createState() => _HabitListScreenState();
}

class _HabitListScreenState extends State<HabitListScreen> {
  late List<HabitModel> _habitList;

  @override
  void initState() {
    super.initState();
    getAllHabits();
  }

  getAllHabits() async {
    _habitList = <HabitModel>[];

    var habits = await dbHelper.queryAllRows(DatabaseHelper.habitsTable);

    habits.forEach((habit) {
      print(habit['_id']);
      print(habit['habit']);
      print(habit['date']);
      print(habit['frequency']);
      print(habit['priority']);

      var habitModel = HabitModel(habit['_id'], habit['habit'], habit['date'],
          habit['frequency'], habit['priority']);

      setState(() {
        _habitList.add(habitModel);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit List'),
      ),
      drawer: DrawerNavigation(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
            itemCount: _habitList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                child: Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    onTap: () {
                      print('---------> Edit/Delete invoked: Send Data');
                      print(_habitList[index].id);
                      print(_habitList[index].habit);
                      print(_habitList[index].date);
                      print(_habitList[index].frequency);
                      print(_habitList[index].priority);

                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditHabitFormScreen(),
                      settings: RouteSettings(
                        arguments: _habitList[index],
                      ),
                      ));
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_habitList[index].habit ?? 'No Data'),
                      ],
                    ),
                    subtitle: Text(_habitList[index].frequency),
                    trailing: Text(_habitList[index].date),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('------> HabitList FAB clicked');
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HabitFormScreen()));
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
