import 'dart:io';

import 'package:args/args.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;

void main(List<String> args) async {
  final parser = ArgParser()..addOption('port', abbr: 'p');
  final result = parser.parse(args);

  final portStr = result['port'] ?? Platform.environment['PORT'] ?? '8080';
  final port = int.tryParse(portStr);

  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number.');
    exitCode = 64;
    return;
  }

  final handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(_echoRequest);


  final server = await io.serve(handler, 'localhost', port);
  print('Serving at http://${server.address.host}:${server.port}');
}

shelf.Response _echoRequest(shelf.Request request) =>
    shelf.Response.ok('Request for "${request.url}"');
