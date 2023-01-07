import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'settings.dart';

class GMap extends StatefulWidget {
  const GMap({Key? key}) : super(key: key);

  @override
  State<GMap> createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  GoogleMapController? controller;
  Map<PolygonId, Polygon> polygons = <PolygonId, Polygon>{};
  int _polygonIdCounter = 0;
  PolygonId? selectedPolygon;

  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PolygonId? selectedId = selectedPolygon;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.settings, color: Colors.blue),
          onPressed: (){
            // navigates to settings page (to accept 2 numbered inputs from user and add them)
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Settings())
            );
          },
        ),
        actions: [
          IconButton(
            // to add a polygon on the center of the viewport
            icon: const Icon(Icons.add, color: Colors.blue,), 
            onPressed: _add,
          ),
          IconButton(
            // when polygon is tapped, tapping this button deletes the polygon. Otherwise, nothing happens
            icon: const Icon(Icons.delete, color: Colors.blue,), 
            onPressed: (selectedId == null)
              ? null
              : () => _remove(selectedId),
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(55.5, 10),
          zoom: 10,
        ),
        polygons: Set<Polygon>.of(polygons.values),
        onMapCreated: _onMapCreated,
      ),
    );
  }

  void _add() async{
    final String polygonIdVal = 'polygon_id_$_polygonIdCounter';
    final PolygonId polygonId = PolygonId(polygonIdVal);
    LatLngBounds visibleRegion = await controller!.getVisibleRegion();

    // the polygon object that's returned from the _add() function
    final Polygon polygon = Polygon(
      polygonId: polygonId,
      consumeTapEvents: true,
      strokeColor: Colors.red,
      strokeWidth: 1,
      fillColor: Colors.transparent,
      points: _createPoints(visibleRegion),
      onTap: () {
        _onPolygonTapped(polygonId);
      },
    );

    setState(() {
      polygons[polygonId] = polygon;
      // increment _polygonIdCounter to have unique polygon id each time
      _polygonIdCounter++;
    });
  }

  Future<void> _showInfoDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('There is some info here'),
                Text('Additional info here'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _onPolygonTapped(PolygonId polygonId) {
    setState(() {
      selectedPolygon = polygonId;
      polygons[selectedPolygon]!.copyWith(
        fillColorParam: Colors.black26,
      );
    });
    _showInfoDialog();
  }
  List<LatLng> _createPoints(visibleRegion) {
    double startLat = visibleRegion.southwest.latitude;       // LatLng at bottom left of viewport
    double startLng = visibleRegion.southwest.longitude;      
    double endLat = visibleRegion.northeast.latitude;         // LatLng at top right of viewport
    double endLng = visibleRegion.northeast.longitude;

    // to create a polygon in the middle of viewport that is half the size of viewport and centered
    double quarterLat= (endLat-startLat)/4;
    double quarterLng = (endLng-startLng)/4;

    final List<LatLng> points = <LatLng>[];
    // bottom 4 points form the borders of the polygon to be drawn...clockwise starting from bottom-left
    points.add(_createLatLng(startLat+quarterLat, startLng+quarterLng));
    points.add(_createLatLng(endLat-quarterLat, startLng+quarterLng));
    points.add(_createLatLng(endLat-quarterLat, endLng-quarterLng));
    points.add(_createLatLng(startLat+quarterLat, endLng-quarterLng));
    return points;
  }
  LatLng _createLatLng(double lat, double lng) {
    return LatLng(lat, lng);
  }

  void _remove(PolygonId polygonId) {
    setState(() {
      if (polygons.containsKey(polygonId)) {
        polygons.remove(polygonId);
      }
      selectedPolygon = null;
    });
  }
}