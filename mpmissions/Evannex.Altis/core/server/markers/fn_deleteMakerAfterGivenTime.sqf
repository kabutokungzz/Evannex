private _marker = _this select 0; // The marker
private _time = _this select 1; // Future time

waitUntil { time >= _time || br_zone_taken || getMarkerColor _marker == ""; };

br_markers_marked deleteAt (br_markers_marked find _marker);
deleteMarker _marker;