// = require leaflet
// = require leaflet-tilelayer-here
// = require leaflet-svg-icon
// = require leaflet.markercluster
// = require proj4
// = require proj4leaflet
// = require_self

L.DivIcon.SVGIcon.DecidimIcon = L.DivIcon.SVGIcon.extend({
    options: {
        fillColor: getComputedStyle(document.documentElement).getPropertyValue('--primary'),
        opacity: 0
    },
    _createPathDescription: function () {
        return "M14 1.17a11.685 11.685 0 0 0-11.685 11.685c0 11.25 10.23 20.61 10.665 21a1.5 1.5 0 0 0 2.025 0c0.435-.435 10.665-9.81 10.665-21A11.685 11.685 0 0 0 14 1.17Zm0 17.415A5.085 5.085 0 1 1 19.085 13.5 5.085 5.085 0 0 1 14 18.585Z";
    },
    _createCircle: function () {
        return ""
    }
});

$(document).ready(() => {
    const here_app_id = $("#interactive_map").data("here-app-id");
    const here_app_code = $("#interactive_map").data("here-app-code");
    const geoJson = $("#interactive_map").data("geojson-data");
    let markerClusters = L.markerClusterGroup();

    const map = L.map('interactive_map');
    proj4.defs("EPSG:3943", "+proj=lcc +lat_1=42.25 +lat_2=43.75 +lat_0=43 +lon_0=3 +x_0=1700000 +y_0=2200000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs");

    L.tileLayer.here({
        appId: here_app_id,
        appCode: here_app_code
    }, {
        continuousWorld: true
    }).addTo(map);

    function addMarker(feature, layer) {
        let marker = L.marker(layer.getBounds().getCenter(), {
            icon: new L.DivIcon.SVGIcon.DecidimIcon()
        });
        marker.bindPopup("Hello!");
        markerClusters.addLayer(marker)
    }

    function onEachFeature(feature, layer) {
        addMarker(feature, layer);
        layer.on("click", (e) => {
            window.location = feature.link;
        });
    }

    const geoJsonLayer = L.Proj.geoJson(geoJson, {
        onEachFeature: onEachFeature,
        style: (feature) => {
            return {color: feature.color}
        }
    });

    geoJsonLayer.addTo(map);
    markerClusters.addTo(map);
    map.fitBounds(geoJsonLayer.getBounds());
});
