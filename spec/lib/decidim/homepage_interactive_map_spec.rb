# frozen_string_literal: true

describe Decidim::HomepageInteractiveMap do
  let(:subject) { described_class }

  describe "#version" do
    it "returns module's version" do
      expect(described_class.version).to eq("1.0.0")
    end
  end

  describe "#decidim_compatibility_version" do
    it "returns module's version" do
      expect(described_class.decidim_compatibility_version).to eq("0.26")
    end
  end
end
