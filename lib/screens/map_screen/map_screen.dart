import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:kampus_sggw/global_widgets/side_drawer.dart';
import 'package:kampus_sggw/logic/search_services/markers_service.dart';
import 'package:kampus_sggw/logic/info_card_dialog_builder.dart';
import 'package:kampus_sggw/models/map_item.dart';
import 'package:kampus_sggw/screens/map_screen/search_button.dart';
import 'package:kampus_sggw/screens/map_screen/search_widgets/search_bar.dart';
import 'package:kampus_sggw/translations/locale_keys.g.dart';
import 'package:provider/provider.dart';
import 'interactive_map.dart';
import 'map_buttons.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static MapItem _selectedMapItem;

  showInfoCard(MapItem mapItem) {
    _selectedMapItem = mapItem;
    Navigator.of(context).restorablePush(_dialogBuilder);
  }

  static Route<Object> _dialogBuilder(BuildContext context, Object arguments) {
    return DialogRoute<void>(
      context: context,
      builder: (BuildContext context) =>
          InfoCardDialogBuilder().fromMapItem(_selectedMapItem),
    );
  }

  void _showBottomDrawer() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: SearchBar(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SearchButton(
            _showBottomDrawer,
            Provider.of<MarkersService>(context, listen: false),
            () => Navigator.pop(context),
          ),
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            LocaleKeys.map_screen_title.tr(),
            style: TextStyle(
              fontFamily: 'SGGWSans',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Stack(
          children: [
            InteractiveMap(
              showCard: showInfoCard,
            ),
          ],
        ),
        floatingActionButton: MapButtons(),
        drawer: SideDrawer(),
      ),
    );
  }
}
