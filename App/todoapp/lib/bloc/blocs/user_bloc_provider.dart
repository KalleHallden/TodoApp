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

  signinUser(String username, String password) async {
    User user = await _repository.signinUser(username, password);
    _userGetter.sink.add(user);
  }

  dispose() {
    _userGetter.close();
  }
}

final bloc = UserBloc();