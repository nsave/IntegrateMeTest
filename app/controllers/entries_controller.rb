class EntriesController < ApplicationController

  # POST /entries.json
  def create
    service = Services::CreateEntryService.new(entry_params).run

    if service.errors.any?
      render json: {success: false, errors: service.errors}
    else
      render json: {success: true}
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def entry_params
      params.require(:entry).permit(:competition_id, :name, :email)
    end
end
