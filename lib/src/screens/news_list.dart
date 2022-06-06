import 'package:flutter/material.dart';
import 'package:news/src/models/storie_model.dart';
import 'package:news/src/widgets/navigation_drawer_widget.dart';
import '../blocs/stories_provider.dart';
import '../widgets/news_list_tile.dart';
import '../widgets/refresh.dart';
import '../widgets/loading_container.dart';

class NewsList extends StatelessWidget {
  Widget build(context) {
    final bloc = StoriesProvider.of(context);
    return Scaffold(
      drawer: NavigationDrawerWidget(),
      appBar: AppBar(
        title: Text('Top Stories'),
      ),
      body: buildList(bloc),
      // bottomNavigationBar: NavBar(),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
      // en el paso anterior insertamos la lista de topIds al stream topIds
      stream: bloc.storieList,
      builder: (context, AsyncSnapshot<List<StorieModel>> snapshot) {
        // si aun el stream no tiene datos muestra el widget circular
        // print('buildList snapshot : ' + snapshot.data.toString());
        // if (!snapshot.hasData) {
        //   return Center(
        //     child: CircularProgressIndicator(),
        //   );
        // }

        if (!snapshot.hasData) {
          //new List<int>.generate(10, (i) => i + 1).map((e) => LoadingContainer());
          return LoadingContainer();
        }

        return Refresh(
          child: ListView.builder(
            itemCount: snapshot.data.length,
            controller: bloc.scrollController,
            itemBuilder: (context, int index) {
              print('snapshot.data[index] :' + snapshot.data[index].toString());
              //bloc.fetchItem(snapshot.data[index]);

              return NewsListTile(
                storie: snapshot.data[index],
              );
            },
          ),
        );
      },
    );
  }
}
