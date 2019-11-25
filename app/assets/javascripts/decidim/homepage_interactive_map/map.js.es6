// = require leaflet
// = require leaflet-tilelayer-here
// = require proj4
// = require proj4leaflet

$(document).ready(() => {
    const here_app_id = $("#mapid").data("app-id");
    const here_app_code = $("#mapid").data("app-code");
    const geoJson = $("#mapid").data("geojson");

    const mymap = L.map('mapid');
    proj4.defs("EPSG:3943", "+proj=lcc +lat_1=42.25 +lat_2=43.75 +lat_0=43 +lon_0=3 +x_0=1700000 +y_0=2200000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs");

    L.tileLayer.here({
        appId: here_app_id,
        appCode: here_app_code
    }, {
        continuousWorld: true
    }).addTo(mymap);

    console.log(geoJson);

    let geoJsonLayer = L.Proj.geoJson(geoJson).addTo(mymap);
    mymap.fitBounds(geoJsonLayer.getBounds());
});
