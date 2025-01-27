import 'package:flutter/material.dart';

import 'package:harmonoid/screens/discover/discoveralbum.dart';
import 'package:harmonoid/scripts/discover.dart';
import 'package:harmonoid/widgets.dart';
import 'package:harmonoid/language/constants.dart';


class DiscoverSearch extends StatefulWidget {
  final String keyword;
  final String mode;
  DiscoverSearch({Key key, @required this.keyword, @required this.mode}) : super(key: key);
  DiscoverSearchState createState() => DiscoverSearchState();
}


class DiscoverSearchState extends State<DiscoverSearch> {
  int _elementsPerRow;
  double _tileWidth;
  double _tileHeight;
  bool _init = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (this._init) {
      this._elementsPerRow = MediaQuery.of(context).size.width ~/ (156 + 8);
      this._tileWidth = (MediaQuery.of(context).size.width - 16 - (this._elementsPerRow - 1) * 8) / this._elementsPerRow;
      this._tileHeight = this._tileWidth * 242 / 156;
    }
    this._init = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            snap: false,
            pinned: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              iconSize: Theme.of(context).iconTheme.size,
              splashRadius: Theme.of(context).iconTheme.size - 8,
              onPressed: Navigator.of(context).pop,
            ),
            backgroundColor: Theme.of(context).primaryColor,
            brightness: Brightness.dark,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.mode,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              background: Image.asset(
                'assets/images/${widget.mode.toLowerCase()}.jpg',
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
            expandedHeight: 148.0,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                FadeFutureBuilder(
                  future: () async => await discover.search(widget.keyword, widget.mode),
                  initialWidgetBuilder: (BuildContext context) => FakeLinearProgressIndicator(
                    label: Constants.STRING_SEARCH_RESULT_LOADER_LABEL,
                    duration: Duration(seconds: 10),
                    width: 156.0,
                    margin: EdgeInsets.only(top: 196.0),
                  ),
                  finalWidgetBuilder: (BuildContext context, Object data) => Column(
                    children: tileGridListWidgets(
                      context: context,
                      tileHeight: this._tileHeight,
                      tileWidth: this._tileWidth,
                      elementsPerRow: this._elementsPerRow,
                      leadingSubHeader: Constants.STRING_SEARCH_RESULT_TOP_SUBHEADER_ALBUM,
                      subHeader: Constants.STRING_SEARCH_RESULT_OTHER_SUBHEADER_ALBUM,
                      leadingWidget: LeadingDiscoverAlbumTile(
                        height: this._tileWidth,
                        album: (data as List<dynamic>).first,
                      ),
                      widgetCount: (data as List<dynamic>).length,
                      builder: (BuildContext context, int index) => DiscoverAlbumTile(
                        album: (data as List<dynamic>)[index],
                        height: this._tileHeight,
                        width: this._tileWidth,
                      )
                    ),
                  ),
                  errorWidgetBuilder: (_, Object exception) => ExceptionWidget(
                    margin: EdgeInsets.only(top: 8.0),
                    height: 156.0,
                    assetImage: 'assets/images/exception.jpg',
                    title: Constants.STRING_NO_INTERNET_TITLE,
                    subtitle: Constants.STRING_NO_INTERNET_SUBTITLE,
                  ),
                  transitionDuration: Duration(milliseconds: 400),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
