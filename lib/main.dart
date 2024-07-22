import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'meal_provider.dart';
import 'meal.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MealProvider(),
      child: MaterialApp(
        title: 'Meal Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MealTrackerHomePage(),
      ),
    );
  }
}

class MealTrackerHomePage extends StatefulWidget {
  @override
  _MealTrackerHomePageState createState() => _MealTrackerHomePageState();
}

class _MealTrackerHomePageState extends State<MealTrackerHomePage> {
  DateTime _startDate = DateTime.now().subtract(Duration(days: 7));
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Tracker'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () async {
              DateTimeRange? picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2101),
              );
              if (picked != null) {
                setState(() {
                  _startDate = picked.start;
                  _endDate = picked.end;
                });
                Provider.of<MealProvider>(context, listen: false)
                    .filterMeals(_startDate, _endDate);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MealChartPage()),
              );
            },
          ),
        ],
      ),
      body: Consumer<MealProvider>(
        builder: (context, mealProvider, child) {
          if (mealProvider.meals.isEmpty) {
            return Center(
              child: Text(
                "My belly is empty. Feed me !!!",
                style: TextStyle(fontSize: 24, color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: mealProvider.meals.length,
            itemBuilder: (context, index) {
              final meal = mealProvider.meals[index];
              final formattedDate =
                  DateFormat('MMM d, y, h:mm a').format(meal.dateTime);
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading: Icon(Icons.fastfood, color: Colors.blue),
                  title: Text(meal.food,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                      '$formattedDate - ${meal.notes.isNotEmpty ? meal.notes : 'No notes'}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.green),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddMealPage(meal: meal)),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          mealProvider.removeMeal(meal);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(meal.food),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text('Date: $formattedDate'),
                              SizedBox(height: 10),
                              Text(
                                  'Notes: ${meal.notes.isNotEmpty ? meal.notes : 'No notes'}'),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Close'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMealPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddMealPage extends StatefulWidget {
  final Meal? meal;

  AddMealPage({this.meal});

  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final _formKey = GlobalKey<FormState>();
  String _food = '';
  DateTime _dateTime = DateTime.now();
  String _notes = '';

  @override
  void initState() {
    super.initState();
    if (widget.meal != null) {
      _food = widget.meal!.food;
      _dateTime = widget.meal!.dateTime;
      _notes = widget.meal!.notes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal == null ? 'Add Meal' : 'Edit Meal'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _food,
                decoration: InputDecoration(
                    labelText: 'Food', icon: Icon(Icons.fastfood)),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some food';
                  }
                  return null;
                },
                onSaved: (value) {
                  _food = value!;
                },
              ),
              TextFormField(
                initialValue: _notes,
                decoration:
                    InputDecoration(labelText: 'Notes', icon: Icon(Icons.note)),
                onSaved: (value) {
                  _notes = value!;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final meal = Meal(
                      id: widget.meal?.id,
                      food: _food,
                      dateTime: _dateTime,
                      notes: _notes,
                    );
                    if (widget.meal == null) {
                      Provider.of<MealProvider>(context, listen: false)
                          .addMeal(meal);
                    } else {
                      Provider.of<MealProvider>(context, listen: false)
                          .updateMeal(meal);
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.meal == null ? 'Add Meal' : 'Update Meal'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MealChartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Chart'),
      ),
      body: Consumer<MealProvider>(
        builder: (context, mealProvider, child) {
          Map<String, int> foodCount = {};
          mealProvider.meals.forEach((meal) {
            foodCount.update(meal.food, (value) => value + 1,
                ifAbsent: () => 1);
          });

          List<BarChartGroupData> barGroups = foodCount.entries.map((entry) {
            return BarChartGroupData(
              x: entry.key.hashCode,
              barRods: [
                BarChartRodData(
                  y: entry.value.toDouble(),
                  width: 16,
                  colors: [Colors.blue],
                ),
              ],
              showingTooltipIndicators: [0],
            );
          }).toList();

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                barGroups: barGroups,
                titlesData: FlTitlesData(
                  leftTitles: SideTitles(showTitles: true),
                  bottomTitles: SideTitles(
                    showTitles: true,
                    getTitles: (double value) {
                      return foodCount.keys.firstWhere(
                          (key) => key.hashCode == value.toInt(),
                          orElse: () => '');
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
