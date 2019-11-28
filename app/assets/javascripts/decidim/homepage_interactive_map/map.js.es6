// = require leaflet
// = require leaflet-tilelayer-here
// = require proj4
// = require proj4leaflet

$(document).ready(() => {
    const here_app_id = $("#mapid").data("app-id");
    const here_app_code = $("#mapid").data("app-code");
    const tempGeoJson = $("#mapid").data("geojson");

    console.log(tempGeoJson);

    const mymap = L.map('mapid');
    proj4.defs("EPSG:3943", "+proj=lcc +lat_1=42.25 +lat_2=43.75 +lat_0=43 +lon_0=3 +x_0=1700000 +y_0=2200000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs");
    let polygonPopup = L.popup();

    const geoJson = tempGeoJson.map((tempObject) => {
        let tmp = tempObject.parsed_geometry;
        tmp.color = tempObject.color;
        tmp.scope = tempObject.scope;
        return tmp;
    });

    console.log(geoJson);

    L.tileLayer.here({
        appId: here_app_id,
        appCode: here_app_code
    }, {
        continuousWorld: true
    }).addTo(mymap);

    function setPopup(body, layer) {
        polygonPopup.setLatLng(layer.getBounds().getCenter())
            .setContent(body)
            .openOn(mymap);
    }

    function onEachFeature(feature, layer) {
        layer.on("click", (e) => {
            $.ajax({
                url: `/homepage_interactive_map/data/polygon/${feature.scope.toString()}`,
                type: 'GET',
                success: (body, status) => {
                    console.log(body);
                    console.log(status);
                    setPopup(body, layer);
                },
                error: (body, status) => {
                    console.log(body);
                    console.log(status);
                }
            });
        });
    }

    const geoJsonLayer = L.Proj.geoJson(geoJson, {
        style: (feature) => {
            return {color: feature.color}
        },
        onEachFeature: onEachFeature
    }).addTo(mymap);

    mymap.fitBounds(geoJsonLayer.getBounds());
});
