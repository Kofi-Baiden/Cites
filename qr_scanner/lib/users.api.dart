import 'users.dart';
import 'package:http/http.dart' as http;

Future<List<Users>> fetchUsers(id) async {
  String url = "http://192.168.137.1/users/users.php?id=$id";
  final response = await http.get(Uri.parse(url));
  return usersFromMap(response.body);
}