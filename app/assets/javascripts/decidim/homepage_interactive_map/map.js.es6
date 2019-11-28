// = require leaflet
// = require leaflet-tilelayer-here
// = require proj4
// = require proj4leaflet

$(document).ready(() => {
    const here_app_id = $("#interactive_map").data("here-app-id");
    const here_app_code = $("#interactive_map").data("here-app-code");
    const geoJson = $("#interactive_map").data("geojson-data");

    const map = L.map('interactive_map');
    proj4.defs("EPSG:3943", "+proj=lcc +lat_1=42.25 +lat_2=43.75 +lat_0=43 +lon_0=3 +x_0=1700000 +y_0=2200000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs");

    console.log(geoJson);

    L.tileLayer.here({
        appId: here_app_id,
        appCode: here_app_code
    }, {
        continuousWorld: true
    }).addTo(map);

    function onEachFeature(feature, layer) {
        layer.on("click", (e) => {
            window.location = feature.link;
        });
    }

    const geoJsonLayer = L.Proj.geoJson(geoJson, {
        style: (feature) => {
            return {color: feature.color}
        },
        onEachFeature: onEachFeature
    }).addTo(map);

    map.fitBounds(geoJsonLayer.getBounds());
});
