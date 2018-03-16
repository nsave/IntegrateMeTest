class CompetitionsController < ApplicationController
  def entrant_page
    @entry = Entry.new(competition: Competition.find(params[:competition_id]))
  end

  def create
    service = Services::CreateCompetitionService.new(competition_params).run

    if service.errors.any?
      render json: {success: false, errors: service.errors}
    else
      render json: {success: true}
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def competition_params
      params.require(:entry).permit(:competition_id, :name, :email)
    end
end