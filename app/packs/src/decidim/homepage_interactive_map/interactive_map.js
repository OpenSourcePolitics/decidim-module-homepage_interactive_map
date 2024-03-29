import * as L from "leaflet";
import "src/decidim/vendor/leaflet-tilelayer-here"
import "src/decidim/map/icon.js" // comes with Decidim
import "leaflet.markercluster"; // Comes with Decidim
import "leaflet.featuregroup.subgroup" // included in this package.json
import "src/vendor/jquery.truncate"

import "src/vendor/leaflet-polylabel-centroid";

L.DivIcon.SVGIcon.DecidimIcon = L.DivIcon.SVGIcon.extend({
  options: {
    iconSize: L.point(24,34),
    fillColor: getComputedStyle(document.documentElement).getPropertyValue('--primary'),
    fillOpacity: 1,
    opacity: 0,
  },
  _createPathDescription: function() {
    return "M12,0.17 C5.5465527,0.17 0.315,5.4015527 0.315,11.855 C0.315,23.105 10.545,32.465 10.98,32.855 C11.5531636,33.3793645 12.4318364,33.3793645 13.005,32.855 C13.44,32.42 23.67,23.045 23.67,11.855 C23.67,5.40740603 18.4475887,0.178276757 12,0.17 Z M12,17.585 C9.19163205,17.585 6.915,15.308368 6.915,12.5 C6.915,9.69163205 9.19163205,7.415 12,7.415 C14.808368,7.415 17.085,9.69163205 17.085,12.5 C17.085,15.308368 14.808368,17.585 12,17.585 L12,17.585 Z";
  },
  _createCircle: function() {
    return ""
  }
});

(() => {
  $(document).ready(() => {
    const here_api_key = $("#interactive_map").data("here-api-key");
    const geoJson = $("#interactive_map").data("geojson-data");
    const $viewParticipatoryProcess = $("#view-participatory-process");

    // Used to prevent click event when double click navigating
    const clickDelay = 500;
    let clickTimer = 0;
    let clickPrevent = false;

    // Style options
    const colorOpacity = 0.5;
    const hoverColorOpacity = 0.8;
    const strokeWeight = 1.5;
    const polyLineColor = 1;
    const strokeColor = "#8a8a8a";
    const iconSize = 28;

    const map = L.map('interactive_map', {scrollWheelZoom: false});

    let zoomOrigin = map.getZoom();
    let allZonesLayer = L.featureGroup();
    let allZonesMarkers = [];
    let allProcessesLinks = {};

    function zoneMarkerIconCSS(size) {
      return {
        'font-size': `${(size / 2) - 2}px`,
        'width' : `${size - 2}px`,
        'height' : `${size - 2}px`,
        'line-height' : `${size - 2}px`,
        'border-radius' : `${size / 2}px`
      }
    }

    function processMarkerIconCSS(size) {
      return {
        'font-size': `${Math.round(size / 3)}px`,
        'width' : `${size / 2}px`,
        'height' : `${size / 2}px`,
        'line-height' : `${size / 2}px`,
        'border-radius' : `${size / 4}px`
      }
    }

    function popupMaxwidth() {
      if ($(window).width() < 600) {
        return 260
      } else {
        return 640
      }
    }

    function popupMinwidth() {
      if ($(window).width() < 600) {
        return 204
      } else {
        return 500
      }
    }

    function isCoordinates(value, length) {
      return Array.isArray(value) && (value.length === length) && !!value.reduce((a, v) => (a && (a !== null)));
    }

    function hasLocation(participatory_process) {
      return (participatory_process.location !== undefined) && isCoordinates(participatory_process.location, 2);
    }

    function updateProcessMarkerPosition(marker, delta, zoom) {
      if (marker.origin === undefined) {
        return;
      }
      let oldPoint = map.project(L.latLng(marker.origin), zoom);

      let radius = ( delta / 2.5 ) + ( marker.getRadius() / 1.75 ) ;
      let newPoint = L.point(
          oldPoint.x + ( radius * Math.cos( Math.PI / 4 ) ),
          oldPoint.y - ( radius * Math.sin( Math.PI / 4 ) )
      );
      marker._latlng = map.unproject(newPoint, zoom);
    }

    function calculateIconSize() {
      const delta = Math.round(1.75 * (map.getZoom()));
      return (delta + 2) * 2;
    }

    function tmpl(participatoryProcess, linkTxt) {
      return `
            <div class="map-info__content homepage_interactive_map">
              <h3>${participatoryProcess.title}</h3>
              <div id="bodyContent">
                <div class="card__datetime">
                  <div class="card__datetime__date">
                    ${participatoryProcess.start_date} - ${participatoryProcess.end_date}
                  </div>
                </div>
                <div class="map-info__button">
                  <a href="${participatoryProcess.link}" class="button button--sc">
                    ${linkTxt}
                  </a>
                </div>
              </div>
            </div>
      `
    }


    L.tileLayer.here({
      apiKey: here_api_key,
      scheme: "normal.day.grey"
    }, {continuousWorld: true}).addTo(map);

    map.createPane("processPane").style.zIndex = 610;
    let allProcessesLayer = L.markerClusterGroup({
      clusterPane: "processPane",
      zoomToBoundsOnClick: false,
      removeOutsideVisibleBounds: true,
      spiderfyDistanceMultiplier: 2,
      chunkedLoading: true,
      showCoverageOnHover: false,
      maxClusterRadius: 40,
      spiderLegPolylineOptions: {
        weight: 2,
        color: getComputedStyle(document.documentElement).getPropertyValue('--primary'),
        opacity: polyLineColor
      },
      iconCreateFunction: (cluster) => {
        let actualIconSize = ( map.getZoom() > zoomOrigin ) ? calculateIconSize() : iconSize;

        let style = Object.entries(processMarkerIconCSS(actualIconSize)).map(
          (v) => `${v[0]}: ${v[1]};`
        ).join(" ");

        return new L.DivIcon({
          html: '<div style="' + style + '">' + cluster.getChildCount() + '</div>',
          className: 'marker-cluster',
          iconSize: new L.Point(actualIconSize / 2, actualIconSize / 2)
        });
      }
    });

    // Convert data from GeoJSON
    const geoJsonLayer = L.geoJson(geoJson, {
      style: (feature) => {
        return {
          interactive: false,
          stroke: true,
          color: strokeColor,
          weight: strokeWeight,
          fillColor: feature.color,
          fillOpacity: colorOpacity
        }
      }
    });

    // We parsed the data to generate advanced layers configuration
    geoJsonLayer.eachLayer((layer) => {
      let { feature } = layer;
      let zoneLayer = L.featureGroup();

      // Zone = Assembly with scope

      // Base zone polygon
      zoneLayer.addLayer(layer);

      zoneLayer.on("mouseover", function() {
        this.setStyle({
          fillOpacity: hoverColorOpacity
        });
      });

      zoneLayer.on("mouseout", function() {
        this.setStyle({
          fillOpacity: colorOpacity
        });
      });


      // Zone label
      const icon = L.divIcon({
        className: 'district-number',
        html: feature.code,
        iconSize: new L.Point(iconSize, iconSize)
      });
      const centroid = L.PolylabelCentroid(L.GeoJSON.latLngsToCoords(layer._latlngs[0], 1), 1/1000);

      let zoneMarker = L.marker(centroid, { icon });

      allZonesMarkers.push(zoneMarker);
      zoneLayer.addLayer(zoneMarker);

      // Navigate to target page
      zoneMarker.on("keypress", (e) => {
        if( e.originalEvent.key === "Enter" ) {
          return window.location = feature.link;
        }
      });

      // Navigate to target page if not double click
      zoneMarker.on("click", (e) => {
        clickTimer = setTimeout(() => {
          if (!clickPrevent) {
            return window.location = feature.link;
          }
          clickPrevent = false;
        }, clickDelay);
      });

      // Zoom to Polygone / Zone
      zoneMarker.on("dblclick", (e) => {
        clearTimeout(clickTimer);
        clickPrevent = true;
        map.fitBounds(zoneLayer.getBounds(), {
          padding: [25, 25]
        });
      });

      // Manage linked participatory processes
      feature.participatory_processes.forEach((participatory_process) => {

        // Filling the registry links
        if(Object.keys(allProcessesLinks).includes(participatory_process.id.toString())) {
          allProcessesLinks[participatory_process.id.toString()].push(layer);
          // Process with location are only displayed once
          if( hasLocation(participatory_process) ) { return }
        } else {
          allProcessesLinks[participatory_process.id.toString()] = [layer];
        }

        let marker = new L.circleMarker(
          // marker is placed on its location or the center of the assembly
          hasLocation(participatory_process) ? participatory_process.location : centroid,
          {
            pane: "processPane",
            radius: Math.round(iconSize / 4),
            weight: 0,
            fillOpacity: 1,
            fillColor: getComputedStyle(document.documentElement).getPropertyValue('--primary'),
          }
        );

        let node = document.createElement("div");
        $(node).html((tmpl(participatory_process, $viewParticipatoryProcess.val())));

        marker.bindPopup(node, {
          maxwidth: popupMaxwidth(),
          minWidth: popupMinwidth(),
          keepInView: true,
          className: "interactive-map-info"
        }).openPopup();

        marker.participatory_process_data = participatory_process;
        marker.origin = centroid;

        // Add marker to marker cluster group
        allProcessesLayer.addLayer(marker);
      });

      // Add zone to layer group
      allZonesLayer.addLayer(zoneLayer);
    });

    // Add zones to map
    allZonesLayer.addTo(map);

    // Map is centered on all the zone
    map.fitBounds(allZonesLayer.getBounds(), {
      padding: [25, 25]
    });

    // Update the starting zoom
    zoomOrigin = map.getZoom();


    // Now, all the element are actually projected on the map
    allProcessesLayer.eachLayer((marker) => {

      // Each participatory process should highlight its linked assemblies / zones
      let linked = allProcessesLinks[marker.participatory_process_data.id.toString()];

      linked.forEach((layer) => {
        marker.on("mouseover", function() {
          layer.bringToFront().setStyle({
            fillOpacity: hoverColorOpacity,
            color: getComputedStyle(document.documentElement).getPropertyValue('--primary'),
            weight: 2
          });
        });

        marker.on("mouseout", function() {
          layer.bringToBack().setStyle({
            fillOpacity: colorOpacity,
            color: strokeColor,
            weight: strokeWeight
          });
        });
      });

      // Translate the marker centered on the zone outside the zone label
      // ( like an notification badge )
      if(!hasLocation(marker.participatory_process_data)) {
        updateProcessMarkerPosition(marker, iconSize, map.getZoom());
      }
    });

    // Map zoom events
    map.on('zoomstart', (e) => {
      $('#interactive_map .leaflet-process-pane').hide();
    });

    map.on('zoomend', (e) => {
      let actualIconSize = iconSize;

      if (map.getZoom() > zoomOrigin) {
        actualIconSize = calculateIconSize()
        $('#interactive_map .district-number').css(zoneMarkerIconCSS(actualIconSize));
      } else {
        $('#interactive_map .district-number').css(zoneMarkerIconCSS(iconSize));
      }

      allZonesMarkers.forEach((marker) => {
        let icon = marker.options.icon;
        icon.options.iconSize = new L.Point(actualIconSize, actualIconSize);
        marker.setIcon(icon);
      });

      allProcessesLayer.eachLayer((marker) => {
        if(!hasLocation(marker.participatory_process_data)) {
          updateProcessMarkerPosition(marker, actualIconSize, map.getZoom());
        }
      });

      allProcessesLayer.refreshClusters();
      $('#interactive_map .leaflet-process-pane').show();
    });
    // Add markers to map
    allProcessesLayer.addTo(map);
  });
})(window);
