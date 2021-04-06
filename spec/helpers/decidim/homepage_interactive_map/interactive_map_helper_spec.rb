# frozen_string_literal: true

require "spec_helper"

module Decidim
  module HomepageInteractiveMap
    describe InteractiveMapHelper do
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
    end
  end
end
