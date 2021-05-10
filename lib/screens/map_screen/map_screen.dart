import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kampus_sggw/global_widgets/side_drawer.dart';
import 'package:kampus_sggw/logic/search_history.dart';
import 'package:kampus_sggw/logic/stream_service.dart';
import 'package:kampus_sggw/logic/visited_items.dart';
import 'package:kampus_sggw/models/map_item.dart';
import 'package:kampus_sggw/models/map_items.dart';
import 'package:kampus_sggw/translations/locale_keys.g.dart';
import 'info_card.dart';
import 'interactive_map.dart';
import 'map_floating_buttons.dart';

class MapScreen extends StatefulWidget {
  final MapItems mapItems;
  final SearchHistory searchHistory;
  final VisitedItems visitedItems;

  MapScreen({
    Key key,
    this.mapItems,
    this.searchHistory,
    this.visitedItems,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static MapItem _selectedMapItem;
  StreamService recenterButtonNotifier = StreamService();
  StreamService filterButtonNotifier = StreamService();
  StreamService unfilterButtonNotifier = StreamService();

  showInfoCard(MapItem mapItem) {
    _selectedMapItem = mapItem;
    Navigator.of(context).restorablePush(_dialogBuilder);
  }

  static Route<Object> _dialogBuilder(BuildContext context, Object arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) =>
          InfoCardDialog.fromMapItem(_selectedMapItem),
    );
  }

  @override
  void dispose() {
    widget.visitedItems.save();
    recenterButtonNotifier.dispose();
    filterButtonNotifier.dispose();
    unfilterButtonNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          LocaleKeys.map_screen_title.tr(),
          style: TextStyle(
            fontFamily: 'SGGWMastro',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Stack(
        children: [
          InteractiveMap(
            mapItems: widget.mapItems,
            showCard: showInfoCard,
            visitedItems: widget.visitedItems,
            shouldRecenter: recenterButtonNotifier,
            shouldFilterMarkers: filterButtonNotifier,
            shouldUnfilterMarkers: unfilterButtonNotifier,
          ),
        ],
      ),
      floatingActionButton: MapFloatingButtons(
        searchHistory: widget.searchHistory,
        visitedItems: widget.visitedItems,
        onRecenterButtonPressed: () => recenterButtonNotifier.addEvent(null),
        filterButtonNotifier: filterButtonNotifier,
        onUnfilterButtonPressed: () => unfilterButtonNotifier.addEvent(null),
      ),
      drawer: SideDrawer(),
    );
  }
}
