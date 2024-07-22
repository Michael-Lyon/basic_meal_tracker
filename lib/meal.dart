class Meal {
  int? id;
  String food;
  DateTime dateTime;
  String notes;

  Meal({this.id, required this.food, required this.dateTime, this.notes = ''});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'food': food,
      'dateTime': dateTime.toIso8601String(),
      'notes': notes,
    };
  }
}
