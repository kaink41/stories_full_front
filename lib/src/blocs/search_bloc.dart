import 'package:news/src/models/storie_model.dart';
import 'package:news/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

import '../util.dart';

class SearchBloc {
  final _searchHistory = BehaviorSubject<List<String>>();
  final _repository = Repository();
  String _query = '';
  String get query => _query;
  List<StorieModel> _suggestions;

  Observable<List<String>> get getSearchHistory => _searchHistory.stream;
  List<StorieModel> get suggestions => _suggestions;
  Function(List<String>) get setSearchHistory => _searchHistory.sink.add;

  void onQueryChanged(String query) async {
    if (query == _query) return;

    _query = query;
    // _isLoading = true;
    // notifyListeners();

    if (query.isEmpty) {
      _suggestions = await getHistory();
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

    // _isLoading = false;
    // notifyListeners();
  }

  dispose() {
    _searchHistory.close();
  }
}
