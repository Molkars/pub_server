// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/args.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:pub_server/shelf_pubserver.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;

import './src/cow_repository.dart';
import './src/file_repository.dart';
import './src/http_proxy_repository.dart';

final Uri pubDartLangOrg = Uri.parse('https://pub.dev');

void main(List<String> args) {
  var parser = argsParser();
  var results = parser.parse(args);

  var directory = results['directory'] as String;
  var host = results['host'] as String;
  var port = int.parse(results['port'] as String);
  var standalone = results['standalone'] as bool;

  if (results.rest.isNotEmpty) {
    print('Got unexpected arguments: "${results.rest.join(' ')}".\n\nUsage:\n');
    print(parser.usage);
    exit(1);
  }

  setupLogger();
  runPubServer(directory, host, port, standalone);
}

Future<HttpServer> runPubServer(String baseDir, String host, int port, bool standalone) {
  var client = http.Client();

  var local = FileRepository(baseDir);
  var remote = HttpProxyRepository(client, pubDartLangOrg);
  var cow = CopyAndWriteRepository(local, remote, standalone);

  var server = ShelfPubServer(cow);

  print(
    '''Listening on http://$host:$port\n
To make the pub client use this repository configure your shell via
  \$ export PUB_HOSTED_URL=http://$host:$port''',
  );

  return shelf_io.serve(
    const Pipeline().addMiddleware(logRequests()).addHandler(server.requestHandler),
    host,
    port,
  );
}

ArgParser argsParser() {
  var parser = ArgParser();

  parser.addOption('directory', abbr: 'd', defaultsTo: 'pub_server-repository-data');

  parser.addOption('host', abbr: 'h', defaultsTo: 'localhost');

  parser.addOption('port', abbr: 'p', defaultsTo: '8080');
  parser.addFlag('standalone', abbr: 's', defaultsTo: false);
  return parser;
}

void setupLogger() {
  Logger.root.onRecord.listen((LogRecord record) {
    var head = '${record.time} ${record.level} ${record.loggerName}';
    var tail = record.stackTrace != null ? '\n${record.stackTrace}' : '';
    print('$head ${record.message} $tail');
  });
}
