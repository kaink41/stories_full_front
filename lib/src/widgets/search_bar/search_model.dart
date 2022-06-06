import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news/src/models/storie_model.dart';
import 'package:news/src/resources/repository.dart';
import 'package:news/src/util.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'place.dart';

class SearchModel extends ChangeNotifier {
  // SearchModel(List<StorieModel> stories) {
  //   _suggestions = stories;
  // }
  final _repository = Repository();
  bool _isLoading = false;
  List<StorieModel> _suggestions = [];
  String _query = '';

  // SearchModel(List<StorieModel> listStorieModel) {
  //   _suggestions = listStorieModel;
  // }

  bool get isLoading => _isLoading;
  List<StorieModel> get suggestions => _suggestions;
  String get query => _query;

  void onQueryChanged(String query) async {
    if (query == _query) return;

    _query = query;
    _isLoading = true;
    notifyListeners();

    if (query.isEmpty) {
      // _suggestions = await getHistory();
    } else {
      //final Map<String, String> params = {'q': query};
      // final response = await http.get(Uri.parse('https://photon.komoot.io/api/').replace(queryParameters: params));
      List<StorieModel> storieList =
          await _repository.fetchStoriesLazy(query, 0, "stories");

      // final body = json.decode(utf8.decode(response.bodyBytes));
      // final features = body['features'] as List;

      //_suggestions = features.map((e) => Place.fromJson(e)).toSet().toList();
      _suggestions = storieList;
    }

    _isLoading = false;
    notifyListeners();
  }

  void clear() async {
    _suggestions = await getHistory();
    notifyListeners();
  }
}

// Future<List<StorieModel>> history() async {
  
//   return await getHistory();
// }
