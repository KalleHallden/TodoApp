import 'package:todoapp/models/classes/task.dart';

import '../resources/repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:todoapp/models/classes/user.dart';

class UserBloc {
  final _repository = Repository();
  final _userGetter = PublishSubject<User>();

  Observable<User> get getUser => _userGetter.stream;

  registerUser(String username, String firstname, String lastname, String password, String email) async {
    User user = await _repository.registerUser(username, firstname, lastname, password, email);
    _userGetter.sink.add(user);
  }

  signinUser(String username, String password, String apiKey) async {
    User user = await _repository.signinUser(username, password, apiKey);
    _userGetter.sink.add(user);
  }

  dispose() {
    _userGetter.close();
  }
}

class TaskBloc {
  final _repository = Repository();
  final _taskGetter = PublishSubject<List<Task>>();

  Observable<List<Task>> get getTasks => _taskGetter.stream;

  getUserTasks(String apiKey) async {
    List<Task> tasks = await _repository.getUserTasks(apiKey);
    _taskGetter.sink.add(tasks);
  }

  dispose() {
    _taskGetter.close();
  }

}
final tasksBloc = TaskBloc();
final userBloc = UserBloc();