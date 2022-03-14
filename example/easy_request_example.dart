import 'package:easy_request/easy_request.dart' show request;

void main() async {
  //GET
  final dynamic getData =
      await request(url: 'https://reqres.in/api/users?page=2');
  // print(getData);

  //POST => if a response is sent back to user, it will be available into the postData variable
  final dynamic postData = await request(
      url: 'https://reqres.in/api/users?page=2',
      method: 'POST',
      // headers: {'Content-Type': 'application/json'}, => NO NEED TO SET THIS HEADER
      body: {'name': 'Example post request', 'job': 'Post data to reqRes'});
  // print(postData);

  //PUT => The same as post
  final dynamic putData = await request(
      url: 'https://reqres.in/api/users?page=2',
      method: 'PUT',
      body: {
        'name': 'Modified data',
        'job': 'Job has been updated to PUT job'
      });
  // print(putData);

  //delete
  final deleteData = await request(
      url: 'https://reqres.in/api/users?page=2', method: 'DELETE');
  print('Delete: ${deleteData}');
}
