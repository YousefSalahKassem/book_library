// ignore_for_file: public_member_api_docs

import 'package:book_library/utils/constants.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mongo_dart/mongo_dart.dart';

/// MongoClient
class MongoClient {
  /// The database name
  factory MongoClient() => _instance;
  MongoClient._internal();

  /// create singleton instance
  static final MongoClient _instance = MongoClient._internal();

  static final _db = Db(Constants.serverUrl);

//start the database
  static Future<void> startDb() async {
    if (_db.isConnected == false) {
      await _db.open();
    }
  }

  //close the database
  static Future<void> closeDb() async {
    if (_db.isConnected == true) {
      await _db.close();
    }
  }

  /// connect to the database
  static Future<Response> startConnection(
    RequestContext context,
    Future<Response> callBack,
  ) async {
    try {
      await startDb();
      return await callBack;
    } catch (e) {
      return Response.json(
        statusCode: 500,
        body: {'message': 'Internal server error'},
      );
    }
  }

  /// get the database
  Db? get db => _db;
}
