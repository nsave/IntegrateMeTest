class CompetitionsController < ApplicationController
  helper_method :competition_entrant_page, :build_competition_json

  def index
    @competitions = Competition.all.order('created_at desc')
  end

  def show
    @entry = Entry.new(competition: Competition.find(params[:competition_id]))
  end

  def create
    service = Services::CreateCompetitionService.new(competition_params).run

    if service.errors.any?
      render json: {
        success: false,
        errors: service.errors
      }
    else
      render json: {
        success: true,
        competition: build_competition_json(service.competition)
      }
    end
  end

  private
    def competition_params
      params.require(:competition).permit(
        :name, :requires_entry_name, :mailchimp_api_key, :mailchimp_list_id
      )
    end

    def competition_entrant_page(competition)
      "/#{competition.id}/#{competition.name.downcase.gsub(/[^a-z0-9 _\-]/i, '').gsub(/[ _-]/, '-')}"
    end

    def build_competition_json(competition)
      {
        name: competition.name,
        link: competition_entrant_page(competition)
      }
    end
end