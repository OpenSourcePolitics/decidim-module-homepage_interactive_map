module Decidim
  module HomepageInteractiveMap
    class DataController < Decidim::HomepageInteractiveMap::ApplicationController
      helper_method :assembly_path

      def polygon
        @assemblies = Decidim::Assembly.where(scope: Scope.find(params[:id]))

        if @assemblies.count == 1
          redirect_to assembly_path(@assemblies.first)
        else
          render layout: false
        end
      end

      private

      def assembly_path(assembly)
        Decidim::EngineRouter.main_proxy(assembly).assembly_path(assembly)
      end
    end
  end
end
