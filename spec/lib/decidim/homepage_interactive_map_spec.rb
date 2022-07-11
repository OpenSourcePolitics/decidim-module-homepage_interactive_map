# frozen_string_literal: true

describe Decidim::HomepageInteractiveMap do
  let(:subject) { described_class }

  describe "#version" do
    it "returns module's version" do
      expect(described_class::VERSION).to eq("2.0.0")
    end
  end

  describe "#decidim_compatibility_version" do
    it "returns module's version" do
      expect(described_class::COMPAT_DECIDIM_VERSION).to eq([">= 0.25.0","< 0.27"])
    end
  end
end
