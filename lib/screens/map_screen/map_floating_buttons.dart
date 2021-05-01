import 'package:flutter/material.dart';
import 'package:kampus_sggw/logic/search_history.dart';
import 'package:kampus_sggw/logic/visited_items.dart';
import 'search_panel/search_bar.dart';

class MapFloatingButtons extends StatelessWidget {
  final SearchHistory searchHistory;
  final VisitedItems visitedItems;
  final Function onMapButtonPressed;

  const MapFloatingButtons({
    Key key,
    this.searchHistory,
    this.visitedItems,
    this.onMapButtonPressed
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FloatingActionButton(
          child: const Icon(Icons.map),
          backgroundColor: Colors.lightGreen,
          onPressed: () => onMapButtonPressed(),
        ),
        Padding(
          padding: EdgeInsets.all(5),
        ),
        FloatingActionButton(
          child: const Icon(Icons.search),
          backgroundColor: Colors.green,
          onPressed: () => _onSearchButtonPressed(context),
        ),
      ],
    );
  }

  void _onSearchButtonPressed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        child: SearchBar(
          searchHistory: searchHistory,
          visitedItems: visitedItems,
        ),
      ),
    );
  }
}