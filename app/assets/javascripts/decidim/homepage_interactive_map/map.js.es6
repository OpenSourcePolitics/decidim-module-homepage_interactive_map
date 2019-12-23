// = require leaflet
// = require leaflet-tilelayer-here
// = require leaflet-svg-icon
// = require leaflet.markercluster
// = require proj4
// = require proj4leaflet
// = require jquery-tmpl
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
    const popupTemplateId = "marker-popup";
    $.template(popupTemplateId, $(`#${popupTemplateId}`).html());
    const colorOpacity = 0.2;
    const hoverColorOpacity = 0.5;
    const strokeWeight = 1;
    const polyLineColor = 0.75;

    let markerClusters = L.markerClusterGroup({
            zoomToBoundsOnClick: true,
            removeOutsideVisibleBounds: true,
            spiderfyDistanceMultiplier: 2,
            chunkedLoading: true,
            showCoverageOnHover: false,
            spiderLegPolylineOptions: {
                weight: 2,
                color: getComputedStyle(document.documentElement).getPropertyValue('--secondary'),
                opacity: polyLineColor
            }
        }
    );

    const map = L.map('interactive_map');
    proj4.defs("EPSG:3943", "+proj=lcc +lat_1=42.25 +lat_2=43.75 +lat_0=43 +lon_0=3 +x_0=1700000 +y_0=2200000 +ellps=GRS80 +towgs84=0,0,0,0,0,0,0 +units=m +no_defs");

    L.tileLayer.here({
        appId: here_app_id,
        appCode: here_app_code
    }, {
        continuousWorld: true
    }).addTo(map);

    function addMarker(feature, layer) {
        feature.participatory_processes.forEach((process) => {
            let marker = L.marker(layer.getBounds().getCenter(), {
                icon: new L.DivIcon.SVGIcon.DecidimIcon()
            });
            let node = document.createElement("div");

            $.tmpl(popupTemplateId, process).appendTo(node);
            marker.bindPopup(node, {
                maxwidth: 640,
                minWidth: 500,
                keepInView: true,
                className: "map-info"
            }).openPopup();

            markerClusters.addLayer(marker)
        });
    }

    function addIcon(feature, layer) {
        const icon = L.divIcon({
            className: 'district-number',
            html: feature.code
        });
        L.marker(layer.getBounds().getCenter(), {icon: icon}).addTo(map);
    }

    function onEachFeature(feature, layer) {
        addMarker(feature, layer);
        addIcon(feature, layer);
        layer.on("click", (e) => {
            return window.location = feature.link;
        });

        layer.on("mouseover", function () {
            this.setStyle({fillOpacity: hoverColorOpacity});
        });

        layer.on("mouseout", function () {
            this.setStyle({fillOpacity: colorOpacity});
        });
    }

    const geoJsonLayer = L.Proj.geoJson(geoJson, {
        onEachFeature: onEachFeature,
        style: (feature) => {
            return {
                color: feature.color,
                stroke: true,
                weight: strokeWeight,
                fillOpacity: colorOpacity
            }
        }
    });

    map.on('zoomend', function () {
        if (map.getZoom() > 12) {
            const newzoom = '' + (Math.round(1.75 * (map.getZoom()))) + 'px';
            $('#interactive_map .district-number').css({'font-size': newzoom});
        } else {
            $('#interactive_map .district-number').css({'font-size': ''});
        }
    });

    geoJsonLayer.addTo(map);
    markerClusters.addTo(map);
    map.fitBounds(geoJsonLayer.getBounds());
});
