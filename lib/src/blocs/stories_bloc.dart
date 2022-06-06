import 'dart:async';
import 'package:news/src/models/storie_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import '../resources/repository.dart';

class StoriesBloc {
  // _itemsOutput es de tipo BehaviorSubject, este stream captura el ultimo intem que
  // fue agregado al controller, y lo emite como el primet item a los nuevos listeners
  final _repository = Repository();
  final _stories = PublishSubject<List<StorieModel>>();
  final _storiesOutput = BehaviorSubject<List<StorieModel>>();
  final _currStorieDetail = BehaviorSubject<StorieModel>();
  final scrollController = ScrollController();
  final _pageNumber = BehaviorSubject<int>();
  final _hasMore = BehaviorSubject<bool>();
  //final _topStorieTapped = BehaviorSubject<StorieModel>();

  // Getters to Streams
  Observable<List<StorieModel>> get storieList => _storiesOutput.stream;
  //Observable<List<StorieModel>> get stories => _stories.stream;
  Observable<List<StorieModel>> get stories => _stories.stream;
  Observable<StorieModel> get currStorieDetail => _currStorieDetail.stream;
  //Observable<StorieModel> get topStorieTapped => _topStorieTapped.stream;
  //Observable<int> get pageNumber => _pageNumber.stream;
  //Observable<bool> get hasMore => _hasMore.stream;

  // Getters to Sinks
  // Function(int) get fetchItem => _itemsFetcher.sink.add;

  Function(int) get setPageNumber => _pageNumber.sink.add;
  Function(bool) get setHasMore => _hasMore.sink.add;
  Function(List<StorieModel>) get setStorieList => _storiesOutput.sink.add;
  Function(StorieModel) get setCurrStorieDetail => _currStorieDetail.sink.add;
  //Function(StorieModel) get setTopStorieTapped => _topStorieTapped.sink.add;

  StoriesBloc() {
    print("IN constructor StoriesBloc()");
    // enlaza _itemsFetcher con _itemsTransformer, de modo que cada vez que se
    // inserta um tem al stream, este pasa por este proceso de transformacion
    // y la salida de este sream es la entrada al stream _itemsOutput
    //_itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
    stories.transform(_storiesTransformer()).pipe(_storiesOutput);
    //stories.transform(_storiesTransformer()).toList();
    print('StoriesBloc setHasMore(true)');
    setHasMore(true);
    setPageNumber(0);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        loadMore();
      }
    });
  }

  _storiesTransformer() {
    return ScanStreamTransformer(
      (List<StorieModel> cache, List<StorieModel> stories, index) {
        if (_pageNumber.value == 0) cache.clear();
        // print("id, index" + id.toString() + " " + index.toString());
        cache.addAll(stories);
        print("cache :: " + cache.toString());
        return cache;
      },
      <StorieModel>[],
    );
  }

  loadMore() async {
    bool hasmore = _hasMore.value;
    print('IN loadMore, hasmore ' + hasmore.toString());
    // consulto las Ids de las historias
    if (hasmore) {
      if (_pageNumber.value == 0) {
        _stories.sink.add([]);
      }
      print("Stories Bloc, _pageNumber :: " + _pageNumber.value.toString());
      List<StorieModel> storieList =
          await _repository.fetchStoriesLazy("", _pageNumber.value, "stories");

      if (storieList.isEmpty) {
        setHasMore(false);
        print('loadMore setHasMore(false) ' + _hasMore.value.toString());
      } else {
        setPageNumber(_pageNumber.value + 1);
        // inserto los ids retornados en el stream
        _stories.sink.add(storieList.toList());
      }
    }
  }

  dispose() {
    _stories.close();
    _pageNumber.close();
    _storiesOutput.close();
    _hasMore.close();
    _currStorieDetail.close();
    // _topStorieTapped.close();
  }
}
