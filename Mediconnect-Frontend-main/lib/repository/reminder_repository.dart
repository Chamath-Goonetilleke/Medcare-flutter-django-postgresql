import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mediconnect/models/MedicineReminder.dart';

class ReminderRepository {
  Future<List<MedicineReminder>> fetchReminders() async {
    final response = await http.get(Uri.parse('YOUR_API_URL_HERE'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => MedicineReminder.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load reminders');
    }
  }

  Future<void> saveReminder(MedicineReminder reminder) async {
    final url = Uri.parse('YOUR_BACKEND_API_URL');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(reminder.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to save reminder');
    }
  }
}
