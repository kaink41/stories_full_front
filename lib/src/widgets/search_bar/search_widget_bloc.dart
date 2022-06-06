// import 'dart:collection';
// import 'dart:convert';
// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:implicitly_animated_reorderable_list/implicitly_animated_reorderable_list.dart';
// import 'package:implicitly_animated_reorderable_list/transitions.dart';
// import 'package:material_floating_search_bar/material_floating_search_bar.dart';
// import 'package:news/src/blocs/search_bloc.dart';
// import 'package:news/src/blocs/search_provider.dart';
// import 'package:news/src/models/storie_model.dart';
// import 'package:news/src/widgets/search_bar/place.dart';
// import 'package:news/src/widgets/search_bar/search_model.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../../util.dart';

// class SearchWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.ltr,
//       child: Home(),
//     );
//   }
// }

// class Home extends StatefulWidget {
//   const Home({Key key}) : super(key: key);

//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   final controller = FloatingSearchBarController();

//   int _index = 0;
//   int get index => _index;
//   set index(int value) {
//     _index = min(value, 2);
//     _index == 2 ? controller.hide() : controller.show();
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       drawer: Drawer(
//         child: Container(
//           width: 200,
//         ),
//       ),
//       body: buildSearchBar(),
//     );
//   }

//   Widget buildSearchBar() {
//     final actions = [
//       FloatingSearchBarAction.searchToClear(
//         showIfClosed: true,
//       ),
//     ];

//     final isPortrait =
//         MediaQuery.of(context).orientation == Orientation.portrait;
//     final searchBloc = SearchProvider.of(context);

//     return StreamBuilder(
//         stream: searchBloc.getSearchHistory,
//         builder: (context, AsyncSnapshot<List<StorieModel>> snapshot) {
//           if (snapshot.hasData != null) {
//             return FloatingSearchBar(
//               automaticallyImplyBackButton: false,
//               controller: controller,
//               clearQueryOnClose: true,
//               hint: 'Titulo, tema...',
//               iconColor: Colors.grey,
//               transitionDuration: const Duration(milliseconds: 800),
//               transitionCurve: Curves.easeInOutCubic,
//               physics: const BouncingScrollPhysics(),
//               axisAlignment: isPortrait ? 0.0 : -1.0,
//               openAxisAlignment: 0.0,
//               actions: actions,
//               //progress: model.isLoading,
//               debounceDelay: const Duration(milliseconds: 500),
//               onQueryChanged: searchBloc.onQueryChanged,
//               scrollPadding: EdgeInsets.zero,
//               transition: CircularFloatingSearchBarTransition(spacing: 16),
//               builder: (context, _) => buildExpandableBody(searchBloc),
//               body: buildBody(),
//             );
//           }
//         });
//     // );
//   }

//   Widget buildBody() {
//     return Column(
//       children: [
//         Expanded(
//           child: IndexedStack(
//             index: min(index, 2),
//             children: const [
//               SomeScrollableContent(),
//             ],
//           ),
//         ),
//         // buildBottomNavigationBar(),
//       ],
//     );
//   }

//   Widget buildExpandableBody(SearchBloc model) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 16.0),
//       child: Material(
//         color: Colors.white,
//         elevation: 4.0,
//         borderRadius: BorderRadius.circular(8),
//         child: ImplicitlyAnimatedList<StorieModel>(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           items: model.suggestions.take(6).toList(),
//           areItemsTheSame: (a, b) => a == b,
//           itemBuilder: (context, animation, storie, i) {
//             return SizeFadeTransition(
//               animation: animation,
//               child: buildItem(context, storie),
//             );
//           },
//           updateItemBuilder: (context, animation, storie) {
//             return FadeTransition(
//               opacity: animation,
//               child: buildItem(context, storie),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget buildItem(BuildContext context, StorieModel storie) {
//     final theme = Theme.of(context);
//     final textTheme = theme.textTheme;

//     final model = Provider.of<SearchModel>(context, listen: false);
//     final searchBloc = SearchProvider.of(context);
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         InkWell(
//           onTap: () async {
//             await addHistories(storie);
//             await setBrowserHistory(searchBloc);
//             FloatingSearchBar.of(context).close();
//             Future.delayed(
//               const Duration(milliseconds: 500),
//               () => model.clear(),
//             );
//           },
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         storie.titulo,
//                         style: textTheme.subtitle1,
//                       ),
//                       const SizedBox(height: 2),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         if (model.suggestions.isNotEmpty && storie != model.suggestions.last)
//           const Divider(height: 0),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
// }

// class SomeScrollableContent extends StatelessWidget {
//   const SomeScrollableContent({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return FloatingSearchBarScrollNotifier(
//       child: ListView.separated(
//         padding: const EdgeInsets.only(top: kToolbarHeight),
//         itemCount: 100,
//         separatorBuilder: (context, index) => const Divider(),
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text('Item $index'),
//           );
//         },
//       ),
//     );
//   }
// }
