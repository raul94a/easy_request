import 'dart:convert';

import 'package:http/http.dart' as http;

List<String> _availableMethods = ['GET', 'POST', 'DELETE', 'PUT'];
Map<String, dynamic> _availableFunctions = {
  'GET': http.get,
  'POST': http.post,
  'DELETE': http.delete,
  'PUT': http.put
};
_throwError(String method, Map<String, dynamic>? body) {
  if (!_availableMethods.contains(method)) {
    throw _RequestException(type: 'METHOD');
  } else if ((method == 'PUT' || method == 'POST') && body == null) {
    throw _RequestException(type: 'BODY');
  }
}

///The [url] is the endpoint the function is going to attack
///with the specified [method].
///
///When [method] is PUT or POST a [body] is required, which is always a Map<String, dynamic>.
///Working with JSON and RESTFUL Services may need to set the request [headers].
///For example, 'Content-Type': 'application/json' (provided by this package, don't need to set up) or an auth header will be required.
///
///This function [returns] a List<dynamic> or Map<String,dynamic> depending on the data provided by de endpoint.

dynamic request({
  required String url,
  String method = 'GET',
  Map<String, String>? headers,
  Map<String, dynamic>? body,
}) async {
  method = method.toUpperCase();
  _throwError(method, body);

  headers = headers ?? {};
  if (method == 'PUT' || method == 'POST') {
    headers['Content-Type'] = 'application/json';
  }

  final http.Response response = method == 'GET'
      //GET
      ? await _availableFunctions[method](Uri.parse(url), headers: headers)
      //PUT, POST, DELETE
      : await _availableFunctions[method](Uri.parse(url),
          headers: headers, body: jsonEncode(body));
  // if (method == 'DELETE') print(response.body);
  return response.body.isEmpty
      ? 'No data sent back to user'
      : jsonDecode(response.body);
}

class _RequestException implements Exception {
  final Map<String, String> exceptions = {
    'METHOD': 'The request method provided is not available',
    'BODY': 'Post or Put methods always require a body',
  };
  final String type;
  _RequestException({required this.type}) : super();

  @override
  String toString() {
    return 'RequestException: ${exceptions[type]!}';
  }
}
