$(document).ready(() => {
    let $geolocalized = $("#scope_geolocalized");
    let $geojson = $("#geojson");

    function toggleSubField(field, subfield) {
        if (field.is(":checked")) {
            subfield.show();
        } else {
            subfield.hide();
        }
    }

    $geolocalized.on("click", function () {
            toggleSubField($geolocalized, $geojson);
        }
    );

    toggleSubField($geolocalized, $geojson);
});
