# frozen_string_literal: true

require "spec_helper"

describe Decidim::HomepageInteractiveMap::ContentBlocks::InteractiveMapCell, type: :cell do
  subject { described_class.new }

  let(:organization) { create(:organization) }

  before do
    allow(controller).to receive(:current_organization).and_return(organization)
    allow(subject).to receive(:current_organization).and_return(organization)
  end

  controller Decidim::PagesController

  describe "#geolocalized_scopes" do
    let(:geolocalized_scopes) { create(:scope, :with_geojson, organization: organization) }
    let(:not_geolocalized_scopes) { create(:scope, organization: organization) }

    it "returns geolocalized scopes" do
      expect(subject.send(:geolocalized_scopes)).to include(geolocalized_scopes)
      expect(subject.send(:geolocalized_scopes)).not_to include(not_geolocalized_scopes)
    end
  end

  describe "#geolocalized_assemblies" do
    context "when there is no assembly" do
      let(:assemblies) { nil }

      it "returs an empty array" do
        expect(subject.geolocalized_assemblies).to eq([])
      end
    end
  end

  describe "#assemblies_data_for_map" do
    let(:scope) { create(:scope, :with_geojson, organization: organization) }
    let(:assembly) { create(:assembly, :with_scope, scope: scope, organization: organization) }
    let(:expected) { subject.send(:assemblies_data_for_map, [assembly]) }

    it "returns an array containing hashes" do
      expect(expected.class).to eq(Array)
      expect(expected.length).to eq(1)
    end

    it "returns a code" do
      expect(expected.first[:code]).to eq(scope.code)
    end

    it "returns the color" do
      expect(expected.first[:color]).to eq(scope.geojson["color"])
    end
  end
end
