# frozen_string_literal: true

require "spec_helper"
require "decidim/core/test/shared_examples/has_contextual_help"

describe "Participatory Processes Steps", type: :system do
  let(:organization) { create(:organization) }
  let(:participatory_process) do
    create(
      :participatory_process,
      :active,
      organization: organization,
      description: { en: "Description", ca: "Descripció", es: "Descripción" },
      short_description: { en: "Short description", ca: "Descripció curta", es: "Descripción corta" }
    )
  end

  before do
    switch_to_host(organization.host)
  end

  context "when there are some published processes" do
    let!(:promoted_process) { create(:participatory_process, :promoted, organization: organization) }

    before do
      visit decidim_participatory_processes.participatory_processes_path
    end

    context "with active steps" do
      let!(:promoted_process) { create(:participatory_process, :promoted, organization: organization) }
      let!(:active_step) do
        create(:participatory_process_step,
               :active,
               participatory_process: promoted_process,
               title: { en: "Active step", ca: "Fase activa", es: "Fase activa" })
      end

      context "when promoted process" do
        it "display default button" do
          visit decidim_participatory_processes.participatory_process_participatory_process_steps_path(promoted_process)

          within ".process-header__phase" do
            expect(page).to have_content("VIEW PHASES")
          end
        end

        context "with action button" do
          let(:cta_text) { { en: "SEE", ca: "SEE", es: "SEE" } }
          let(:cta_path) { "my path" }
          let!(:active_step) do
            create(:participatory_process_step,
                   :active,
                   cta_text: cta_text,
                   cta_path: cta_path,
                   participatory_process: promoted_process,
                   title: { en: "Active step", ca: "Fase activa", es: "Fase activa" })
          end

          it "display custom button" do
            visit decidim_participatory_processes.participatory_process_participatory_process_steps_path(promoted_process)

            within ".process-header__phase" do
              expect(page).to have_content("SEE")
            end
          end

          context "when action btn is nil" do
            let(:cta_text) { nil }

            it "display default button" do
              visit decidim_participatory_processes.participatory_process_participatory_process_steps_path(promoted_process)

              within ".process-header__phase" do
                expect(page).to have_content("VIEW PHASES")
              end
            end
          end

          context "when action btn is blank in current locale" do
            let(:cta_text) { { en: "", ca: "HEY IN CATALÀ!", es: "HEY IN CASTELLANO!" } }

            it "display next language defined in cta_text in button" do
              visit decidim_participatory_processes.participatory_process_participatory_process_steps_path(promoted_process)

              within ".process-header__phase" do
                expect(page).to have_content("HEY IN CATALÀ!")
              end
            end
          end

          context "when action btn is blank in another locale" do
            let(:cta_text) { { en: "HEY!", ca: "", es: "" } }

            it "display custom button" do
              visit decidim_participatory_processes.participatory_process_participatory_process_steps_path(promoted_process)

              within ".process-header__phase" do
                expect(page).to have_content("HEY!")
              end
            end
          end
        end
      end

      context "when highlighted process" do
        it "display default button" do
          visit decidim_participatory_processes.participatory_process_participatory_process_steps_path(promoted_process)

          within ".process-header__phase" do
            expect(page).to have_content("VIEW PHASES")
          end
        end

        context "with cta button" do
          let(:cta_text) { { en: "SEE", ca: "SEE", es: "SEE" } }
          let(:cta_path) { "my path" }
          let!(:active_step) do
            create(:participatory_process_step,
                   :active,
                   cta_text: cta_text,
                   cta_path: cta_path,
                   participatory_process: promoted_process,
                   title: { en: "Active step", ca: "Fase activa", es: "Fase activa" })
          end

          it "display custom button" do
            visit decidim_participatory_processes.participatory_process_participatory_process_steps_path(promoted_process)

            within ".process-header__phase" do
              expect(page).to have_content("SEE")
            end
          end

          context "when cta btn is nil" do
            let(:cta_text) { nil }

            it "display default button" do
              visit decidim_participatory_processes.participatory_process_participatory_process_steps_path(promoted_process)

              within ".process-header__phase" do
                expect(page).to have_content("VIEW PHASES")
              end
            end
          end

          context "when cta btn is blank in en" do
            let(:cta_text) { { en: "", ca: "HEY IN CATALÀ!", es: "HEY IN CASTELLANO!" } }

            it "display next language defined in cta_text in button" do
              visit decidim_participatory_processes.participatory_process_participatory_process_steps_path(promoted_process)

              within ".process-header__phase" do
                expect(page).to have_content("HEY IN CATALÀ!")
              end
            end
          end

          context "when cta btn is blank in ca" do
            let(:cta_text) { { en: "HEY!" } }

            it "display custom button" do
              visit decidim_participatory_processes.participatory_process_participatory_process_steps_path(promoted_process)

              within ".process-header__phase" do
                expect(page).to have_content("HEY!")
              end
            end
          end
        end
      end
    end
  end
end
