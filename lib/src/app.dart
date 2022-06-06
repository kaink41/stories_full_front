import 'package:flutter/material.dart';
import 'screens/news_list.dart';
import 'blocs/stories_provider.dart';
import 'screens/news_detail.dart';

class App extends StatelessWidget {
  Widget build(context) {
    return StoriesProvider(
      child: MaterialApp(
        title: 'News!',
        onGenerateRoute: routes,
      ),
    );
  }

  Route routes(RouteSettings settings) {
    print('entro a routes');
    // si hacemos request a la raiz, consultamos y listamos todas las historias
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          final storiesBloc = StoriesProvider.of(context);
          // consulto e insert los topIds en el stream_topIds
          print('App storiesBloc.setHasMore(true);');
          storiesBloc.setHasMore(true);
          storiesBloc.loadMore();

          return NewsList();
        },
      );
    } else {
      print('settings.name != /');
      return MaterialPageRoute(
        builder: (context) {
          print('IN MaterialPageRoute settings.name ' + settings.name);
          print('IN MaterialPageRoute settings.name.replaceFirst(/, ) ' +
              settings.name.replaceFirst('/', ''));
          //  final commentsBloc = CommentsProvider.of(context);
          // tomo el id del item en la ruta en la url

          // final itemId = int.parse(settings.name.replaceFirst('/', ''));
          // print('MaterialPageRoute itemId ' + itemId.toString());
          // consulto los comentarios para ese item
          // commentsBloc.fetchItemWithComments(itemId);

          return NewsDetail(
              //  itemId: itemId,
              );
        },
      );
    }
  }
}
