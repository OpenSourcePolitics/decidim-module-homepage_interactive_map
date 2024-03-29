# frozen_string_literal: true

require "spec_helper"

module Decidim
  module HomepageInteractiveMap
    describe InteractiveMapHelper do
      let(:organization) { create(:organization) }

      describe "#geolocation_enabled?" do
        subject { helper.geolocation_enabled? }

        before do
          allow(Decidim::Map).to receive(:available?).with(:geocoding).and_return(true)
        end

        it { is_expected.to be_truthy }

        context "when geocoding is not available" do
          before do
            allow(Decidim::Map).to receive(:available?).with(:geocoding).and_return(false)
          end

          it { is_expected.to be_falsey }
        end
      end

      describe "#interactive_map_for" do
        subject { helper.interactive_map_for(geojson) { "" } }

        let(:scope) { create(:scope, :with_geojson, organization: organization) }
        let(:geojson) { scope.geojson }

        it "returns the map" do
          expect(subject).to match("interactive_map")
        end

        it "returns the api key" do
          expect(subject).to match("data-here-api-key")
          expect(subject).to match(Decidim::Map.configuration[:api_key])
        end

        context "when api_key is not defined" do
          before do
            allow(Decidim::Map.configuration).to receive(:[]).with(:api_key).and_return(nil)
          end

          it "returns nil" do
            expect(subject).to be_nil
          end
        end

        context "when adding css classes" do
          subject { helper.interactive_map_for(geojson, css) { "" } }

          let(:css) { "fake css klass" }

          it "returns map with defined css" do
            expect(subject).to match("fake css klass")
          end
        end

        context "when geocoding is disabled" do
          before do
            allow(Decidim::Map).to receive(:available?).with(:geocoding).and_return(false)
          end

          it "returns nil" do
            expect(subject).not_to match("interactive_map ")
            expect(subject).to be_nil
          end
        end
      end
    end
  end
end
