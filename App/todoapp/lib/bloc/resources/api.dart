import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/models/classes/task.dart';
import 'dart:convert';
import 'package:todoapp/models/classes/user.dart';

class ApiProvider {
  Client client = Client();
  final _apiKey = 'your_api_key';

  Future<User> registerUser(String username, String firstname, String lastname, String password, String email) async {
    final response = await client
        .post("http://127.0.0.1:5000/api/register",
        // headers: "",
        body: jsonEncode(
          {
          	"emailadress" : email,
	          "username" : username,
	          "password" : password,
	          "firstname" : firstname,
	          "lastname" : lastname
        }
        ) 
        );
    final Map result = json.decode(response.body);
    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      await saveApiKey(result["data"]["api_key"]);
      return User.fromJson(result["data"]);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future signinUser(String username, String password, String apiKey) async {
    final response = await client
        .post("http://127.0.0.1:5000/api/signin",
        headers: {
          "Authorization" : apiKey
        },
        body: jsonEncode(
          {
	          "username" : username,
	          "password" : password,
        }
        ) 
        );
    final Map result = json.decode(response.body);
    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      await saveApiKey(result["data"]["api_key"]);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<List<Task>> getUserTasks(String apiKey) async {
    final response = await client
        .get("http://127.0.0.1:5000/api/tasks",
        headers: {
          "Authorization" : apiKey
        },
        );
    final Map result = json.decode(response.body);
    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      List<Task> tasks = [];
      for (Map json_ in result["data"]) {
        try {
          tasks.add(Task.fromJson(json_));
        }
        catch (Exception) {
          print(Exception);
        }
      }
      for (Task task in tasks) {
        print(task.taskId);
      }
      return tasks;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load tasks');
    }
  }

  Future addUserTask(String apiKey, String taskName, String deadline) async {
    final response = await client
        .post("http://127.0.0.1:5000/api/tasks",
        headers: {
          "Authorization" : apiKey
        },
        body: jsonEncode({
          "note" : "",
	        "repeats" : "",
	        "completed" : false,
	        "deadline" : deadline,
	        "reminders" : "",
	        "title" : taskName 
        })
        );
    if (response.statusCode == 201) {
      print("Task added");
    } else {
      // If that call was not successful, throw an error.
      print(json.decode(response.body));
      throw Exception('Failed to load tasks');
    }
  }

 saveApiKey(String api_key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('API_Token', api_key);
 }
}