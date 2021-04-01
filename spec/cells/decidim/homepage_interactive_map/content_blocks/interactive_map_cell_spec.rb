# frozen_string_literal: true

require "spec_helper"

describe Decidim::HomepageInteractiveMap::ContentBlocks::InteractiveMapCell, type: :cell do
  include Decidim::TranslationsHelper
  subject { cell(content_block.cell, content_block) }

  let(:organization) { create(:organization) }
  let(:content_block) { create :content_block, organization: organization, manifest_name: :interactive_map, scope_name: :homepage }
  let!(:geolocalized_scopes) { create(:scope, :with_geojson, organization: organization) }
  let!(:not_geolocalized_scopes) { create(:scope, organization: organization) }
  let!(:assembly) { create(:assembly, :with_scope, :published, organization: organization, scope: geolocalized_scopes) }

  controller Decidim::PagesController

  before do
    allow(controller).to receive(:current_organization).and_return(organization)
  end

  controller Decidim::PagesController

  describe "#geolocalized_scopes" do
    it "returns geolocalized scopes" do
      expect(subject.send(:geolocalized_scopes)).to include(geolocalized_scopes)
      expect(subject.send(:geolocalized_scopes)).not_to include(not_geolocalized_scopes)
    end
  end

  describe "#geolocalized_assemblies" do
    it "returns geolocalized_assemblies" do
      expect(subject.geolocalized_assemblies.length).to eq(1)
      expect(subject.geolocalized_assemblies).to eq([assembly])
    end

    context "when assembly is not published" do
      let!(:assembly) { create(:assembly, :unpublished, :with_scope, organization: organization, scope: geolocalized_scopes) }

      it "doesn't returns the assembly" do
        expect(subject.geolocalized_assemblies).to eq([])
      end
    end

    context "when assembly is from another organization" do
      let(:another_organization) { create(:organization) }
      let!(:assembly) { create(:assembly, :with_scope, :published, organization: another_organization) }

      it "doesn't returns the assembly" do
        expect(subject.geolocalized_assemblies).to eq([])
      end
    end

    context "when scope is not geolocalized" do
      let!(:assembly) { create(:assembly, :with_scope, organization: organization, scope: not_geolocalized_scopes) }

      it "doesn't returns the assembly" do
        expect(subject.geolocalized_assemblies).to eq([])
      end
    end

    context "when there is no assembly" do
      let(:assembly) { nil }

      it "doesn't returns the assembly" do
        expect(subject.geolocalized_assemblies).to eq([])
      end
    end
  end

  describe "#participatory_processes" do
    let!(:linked_participatory_processes) { create_list(:participatory_process, 3, :active, :published, organization: organization) }
    let(:expected) { subject.send(:participatory_processes, assembly) }

    before do
      linked_participatory_processes.each { |participatory_process| create_link(assembly, participatory_process) }
    end

    it "returns participatory_processes" do
      expect(expected.length).to eq(3)
      expect(expected).to eq(linked_participatory_processes)
    end

    context "when not published and active" do
      let!(:linked_participatory_processes) { create_list(:participatory_process, 3, organization: organization) }

      it "doesn't returns participatory_processes" do
        expect(expected).to eq([])
      end
    end
  end

  describe "#participatory_process_data_for_map" do
    let!(:linked_participatory_process) { create(:participatory_process, :active, :published, organization: organization) }
    let(:expected) { subject.send(:participatory_process_data_for_map, linked_participatory_process) }

    before do
      create_link(assembly, linked_participatory_process)
    end

    it "returns the title" do
      expect(expected[:title]).to eq(translated_attribute(linked_participatory_process.title))
    end

    it "returns the start_date" do
      expect(expected[:start_date]).to eq(linked_participatory_process.start_date.strftime("%d/%m/%Y"))
    end

    it "returns the end_date" do
      expect(expected[:end_date]).to eq(linked_participatory_process.end_date.strftime("%d/%m/%Y"))
    end

    it "returns the link" do
      link = Decidim::EngineRouter.main_proxy(linked_participatory_process).participatory_process_path(linked_participatory_process)

      expect(expected[:link]).to eq(link)
    end

    it "returns the location" do
      expect(expected[:location]).to eq([linked_participatory_process.latitude, linked_participatory_process.longitude])
      expect(expected[:location].class).to eq(Array)
    end
  end

  describe "#assembly_data_for_map" do
    let(:scope) { create(:scope, :with_geojson, organization: organization) }
    let(:assembly) { create(:assembly, :with_scope, scope: scope, organization: organization) }
    let(:expected) { subject.send(:assembly_data_for_map, assembly) }

    it "returns the coordinates" do
      expect(expected["coordinates"]).to eq(scope.geojson["parsed_geometry"]["coordinates"])
      expect(expected["coordinates"].class).to eq(Array)
    end

    it "returns a code" do
      expect(expected[:code]).to eq(scope.code)
    end

    it "returns the link" do
      link = Decidim::EngineRouter.main_proxy(assembly).assembly_path(assembly)

      expect(expected[:link]).to eq(link)
    end

    it "returns the crs" do
      expect(expected[:crs]).to eq(scope.geojson["crs"])
    end

    it "returns the participatory_processes" do
      expect(expected[:participatory_processes]).to eq([])
    end

    context "when participatory_processes are linked" do
      let!(:linked_participatory_processes) { create_list(:participatory_process, 3, :active, :published, organization: organization) }

      it "returns the participatory_processes" do
        linked_participatory_processes.each { |participatory_process| create_link(assembly, participatory_process) }

        expect(expected[:participatory_processes].length).to eq(3)
      end
    end
  end

  def create_link(assembly, participatory_process)
    Decidim::ParticipatorySpaceLink.create!(
      from_type: assembly.class,
      from_id: assembly.id,
      to_type: participatory_process.class,
      to_id: participatory_process.id,
      name: "included_participatory_processes"
    )
  end
end
