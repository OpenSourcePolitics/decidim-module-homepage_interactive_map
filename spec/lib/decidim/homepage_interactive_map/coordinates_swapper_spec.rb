# frozen_string_literal: true

require "spec_helper"
require "decidim/homepage_interactive_map/coordinates_swapper"

describe Decidim::HomepageInteractiveMap::CoordinatesSwapper do
  let(:geojson) do
    {
      color: "#24d36a",
      geometry: {
        "type": "Feature",
        "properties": {
          "infobulle": "1.3\nLes Chalets / Bayard / Belfort / Saint-Aubin / Dupuy\nSecteur Toulouse Centre\nMaire de quartier : Jacqueline Winnepenninckx-Kieser",
          "quartier": "1.3",
          "nom_quartier": "Les Chalets / Bayard / Belfort / Saint-Aubin / Dupuy",
          "maire_de_quartier": "Jacqueline Winnepenninckx-Kieser",
          "secteur": 1,
          "nom_secteur": "Toulouse Centre",
          "libelle_maire": "Maire de quartier : Jacqueline Winnepenninckx-Kieser",
          "oid": 143
        },
        "formattedProperties": {
          "infobulle": "1.3<br/>Les Chalets / Bayard / Belfort / Saint-Aubin / Dupuy<br/>Secteur Toulouse Centre<br/>Maire de quartier : Jacqueline Winnepenninckx-Kieser",
          "quartier": "1.3",
          "nom_quartier": "Les Chalets / Bayard / Belfort / Saint-Aubin / Dupuy",
          "maire_de_quartier": "Jacqueline Winnepenninckx-Kieser",
          "secteur": "1",
          "nom_secteur": "Toulouse Centre",
          "libelle_maire": "Maire de quartier : Jacqueline Winnepenninckx-Kieser",
          "oid": "143"
        },
        "geometry": {
          "type": "MultiPolygon",
          "coordinates": [
            [
              [
                [1_573_864.4303, 2_269_611.967399989],
                [1_573_866.1109999998, 2_269_612.390899989],
                [1_573_937.0363999999, 2_269_622.778199987],
                [1_573_969.0081999998, 2_269_625.055299987]
              ]
            ]
          ],
          "crs": "EPSG:3943"
        },
        "centroid": {
          "type": "Point",
          "coordinates": [1_575_093.2722624019, 2_268_421.172549989],
          "crs": "EPSG:3943"
        },
        "id": "143",
        "crs": {
          "type": "name",
          "properties": {
            "name": "EPSG:3943"
          }
        },
        "bbox": [1_573_864.4303, 2_267_226.4562999886, 1_575_430.5514999998, 2_269_625.055299987]
      },
      parsed_geometry: {
        "type": "Feature",
        "properties": {
          "infobulle": "1.3\nLes Chalets / Bayard / Belfort / Saint-Aubin / Dupuy\nSecteur Toulouse Centre\nMaire de quartier : Jacqueline Winnepenninckx-Kieser",
          "quartier": "1.3",
          "nom_quartier": "Les Chalets / Bayard / Belfort / Saint-Aubin / Dupuy",
          "maire_de_quartier": "Jacqueline Winnepenninckx-Kieser",
          "secteur": 1,
          "nom_secteur": "Toulouse Centre",
          "libelle_maire": "Maire de quartier : Jacqueline Winnepenninckx-Kieser",
          "oid": 143
        },
        "formattedProperties": {
          "infobulle": "1.3<br/>Les Chalets / Bayard / Belfort / Saint-Aubin / Dupuy<br/>Secteur Toulouse Centre<br/>Maire de quartier : Jacqueline Winnepenninckx-Kieser",
          "quartier": "1.3",
          "nom_quartier": "Les Chalets / Bayard / Belfort / Saint-Aubin / Dupuy",
          "maire_de_quartier": "Jacqueline Winnepenninckx-Kieser",
          "secteur": "1",
          "nom_secteur": "Toulouse Centre",
          "libelle_maire": "Maire de quartier : Jacqueline Winnepenninckx-Kieser",
          "oid": "143"
        },
        "geometry": {
          "type": "MultiPolygon",
          "coordinates": [
            [
              [
                [1_573_864.4303, 2_269_611.967399989],
                [1_573_866.1109999998, 2_269_612.390899989],
                [1_573_937.0363999999, 2_269_622.778199987],
                [1_573_969.0081999998, 2_269_625.055299987]
              ]
            ]
          ],
          "crs": "EPSG:3943"
        },
        "centroid": {
          "type": "Point",
          "coordinates": [1_575_093.2722624019, 2_268_421.172549989],
          "crs": "EPSG:3943"
        },
        "id": "143",
        "crs": {
          "type": "name",
          "properties": {
            "name": "EPSG:3943"
          }
        },
        "bbox": [1_573_864.4303, 2_267_226.4562999886, 1_575_430.5514999998, 2_269_625.055299987]
      }
    }
  end

  describe ".detect_crs" do
    it "detects the crs" do
      expect(described_class.detect_crs(geojson)).to eq("EPSG:3943")
    end

    context "when the crs is not present" do
      it "returns nil" do
        expect(described_class.detect_crs({})).to be_nil
      end
    end
  end

  describe ".transform" do
    let(:coordinates) do
      [1_575_093.2722624019, 2_268_421.172549989]
    end

    it "transforms the coordinates" do
      expect(subject.transform(coordinates, "EPSG:3943", "EPSG:3857")).to eq([161_720.39963370157, 5_404_601.1563320365])
    end

    context "when coordinates are nested" do
      let(:coordinates) do
        [
          [
            [
              [1_573_864.4303, 2_269_611.967399989],
              [1_573_866.1109999998, 2_269_612.390899989],
              [1_573_937.0363999999, 2_269_622.778199987],
              [1_573_969.0081999998, 2_269_625.055299987]
            ]
          ]
        ]
      end
      let(:expected_coordinates) do
        [
          [
            [
              [159_995.75580659864, 5_406_217.276604411],
              [159_998.06238362205, 5_406_217.905877928],
              [160_095.59190558322, 5_406_234.104355573],
              [160_139.61809037466, 5_406_238.077716673]
            ]
          ]
        ]
      end

      it "transforms the coordinates" do
        expect(subject.transform(coordinates, "EPSG:3943", "EPSG:3857")).to eq(expected_coordinates)
      end
    end
  end

  describe ".convert_geojson" do
    let(:expected_geojson) do
      {
        color: "#24d36a",
        geometry: {
          type: "Feature",
          properties: {
            infobulle: "1.3\nLes Chalets / Bayard / Belfort / Saint-Aubin / Dupuy\nSecteur Toulouse Centre\nMaire de quartier : Jacqueline Winnepenninckx-Kieser",
            quartier: "1.3",
            nom_quartier: "Les Chalets / Bayard / Belfort / Saint-Aubin / Dupuy",
            maire_de_quartier: "Jacqueline Winnepenninckx-Kieser",
            secteur: 1,
            nom_secteur: "Toulouse Centre",
            libelle_maire: "Maire de quartier : Jacqueline Winnepenninckx-Kieser",
            oid: 143
          },
          formattedProperties: {
            infobulle: "1.3<br/>Les Chalets / Bayard / Belfort / Saint-Aubin / Dupuy<br/>Secteur Toulouse Centre<br/>Maire de quartier : Jacqueline Winnepenninckx-Kieser",
            quartier: "1.3",
            nom_quartier: "Les Chalets / Bayard / Belfort / Saint-Aubin / Dupuy",
            maire_de_quartier: "Jacqueline Winnepenninckx-Kieser",
            secteur: "1",
            nom_secteur: "Toulouse Centre",
            libelle_maire: "Maire de quartier : Jacqueline Winnepenninckx-Kieser",
            oid: "143"
          },
          geometry: {
            type: "MultiPolygon",
            coordinates:
              [
                [
                  [
                    [1_573_864.4303, 2_269_611.967399989],
                    [1_573_866.1109999998, 2_269_612.390899989],
                    [1_573_937.0363999999, 2_269_622.778199987],
                    [1_573_969.0081999998, 2_269_625.055299987]
                  ]
                ]
              ],
            crs: "EPSG:3943"
          },
          centroid: {
            type: "Point",
            coordinates:
              [1_575_093.2722624019, 2_268_421.172549989],
            crs: "EPSG:3943"
          },
          id: "143",
          crs: {
            type: "name",
            properties: {
              name: "EPSG:3943"
            }
          },
          bbox:
            [1_573_864.4303, 2_267_226.4562999886, 1_575_430.5514999998, 2_269_625.055299987]
        },
        parsed_geometry: {
          type: "Feature",
          properties: {
            infobulle: "1.3\nLes Chalets / Bayard / Belfort / Saint-Aubin / Dupuy\nSecteur Toulouse Centre\nMaire de quartier : Jacqueline Winnepenninckx-Kieser",
            quartier: "1.3",
            nom_quartier: "Les Chalets / Bayard / Belfort / Saint-Aubin / Dupuy",
            maire_de_quartier: "Jacqueline Winnepenninckx-Kieser",
            secteur: 1,
            nom_secteur: "Toulouse Centre",
            libelle_maire: "Maire de quartier : Jacqueline Winnepenninckx-Kieser",
            oid: 143
          },
          formattedProperties: {
            infobulle: "1.3<br/>Les Chalets / Bayard / Belfort / Saint-Aubin / Dupuy<br/>Secteur Toulouse Centre<br/>Maire de quartier : Jacqueline Winnepenninckx-Kieser",
            quartier: "1.3",
            nom_quartier: "Les Chalets / Bayard / Belfort / Saint-Aubin / Dupuy",
            maire_de_quartier: "Jacqueline Winnepenninckx-Kieser",
            secteur: "1",
            nom_secteur: "Toulouse Centre",
            libelle_maire: "Maire de quartier : Jacqueline Winnepenninckx-Kieser",
            oid: "143"
          },
          geometry: {
            type: "MultiPolygon",
            coordinates:
              [
                [
                  [
                    [159_995.75580659864, 5_406_217.276604411],
                    [159_998.06238362205, 5_406_217.905877928],
                    [160_095.59190558322, 5_406_234.104355573],
                    [160_139.61809037466, 5_406_238.077716673]
                  ]
                ]
              ],
            crs: "EPSG:3943"
          },
          centroid: {
            type: "Point",
            coordinates:
              [1_575_093.2722624019, 2_268_421.172549989],
            crs: "EPSG:3943"
          },
          id: "143",
          crs: {
            type: "name",
            properties: {
              name: "EPSG:3943"
            }
          },
          bbox:
            [1_573_864.4303, 2_267_226.4562999886, 1_575_430.5514999998, 2_269_625.055299987]
        }
      }
    end

    it "convert the geojson" do
      expect(subject.convert_geojson(geojson)).to eq(expected_geojson)
    end
  end
end
