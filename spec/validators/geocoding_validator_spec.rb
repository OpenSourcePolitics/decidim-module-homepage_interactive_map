# frozen_string_literal: true

require "spec_helper"

describe GeocodingValidator do
  describe "geolocalized component" do
    subject { validatable.new(address: address) }

    let(:validatable) do
      Class.new do
        include FactoryBot::Syntax::Methods
        def self.model_name
          ActiveModel::Name.new(self, nil, "Validatable")
        end

        include Virtus.model
        include ActiveModel::Validations

        attribute :address
        attribute :latitude
        attribute :longitude

        validates :address, geocoding: true

        def component
          create(:component)
        end
      end
    end

    let(:address) { "Carrer Pare Llaurador 113, baixos, 08224 Terrassa" }
    let(:latitude) { 40.1234 }
    let(:longitude) { 2.1234 }

    context "when the address is valid" do
      before do
        stub_geocoding(address, [latitude, longitude])
      end

      it "uses Geocoder to compute its coordinates" do
        expect(subject).to be_valid
        expect(subject.latitude).to eq(latitude)
        expect(subject.longitude).to eq(longitude)
      end
    end

    context "when the address is not valid" do
      let(:address) { "The post-apocalyptic Land of Ooo" }

      before do
        stub_geocoding(address, [])
      end

      it { is_expected.to be_invalid }
    end
  end

  describe "geolocalized participatory process" do
    subject { validatable.new(address: address) }

    let(:validatable) do
      Class.new do
        include FactoryBot::Syntax::Methods
        def self.model_name
          ActiveModel::Name.new(self, nil, "Validatable")
        end

        include Virtus.model
        include ActiveModel::Validations

        attribute :address
        attribute :latitude
        attribute :longitude

        validates :address, geocoding: true

        def component
          create(:participatory_process)
        end
      end
    end

    let(:address) { "Carrer Pare Llaurador 113, baixos, 08224 Terrassa" }
    let(:latitude) { 40.1234 }
    let(:longitude) { 2.1234 }

    context "when the address is valid" do
      before do
        stub_geocoding(address, [latitude, longitude])
      end

      it "uses Geocoder to compute its coordinates" do
        expect(subject).to be_valid
        expect(subject.latitude).to eq(latitude)
        expect(subject.longitude).to eq(longitude)
      end
    end

    context "when the address is not valid" do
      let(:address) { "The post-apocalyptic Land of Ooo" }

      before do
        stub_geocoding(address, [])
      end

      it { is_expected.to be_invalid }
    end
  end
end
