class CompetitionsController < ApplicationController
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
        competition: view_context.build_competition_json(service.competition)
      }
    end
  end

  private
    def competition_params
      params.require(:competition).permit(
        :name, :requires_entry_name, :mailchimp_api_key, :mailchimp_list_id
      )
    end
end