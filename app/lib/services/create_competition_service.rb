module Services
  class CreateCompetitionService
    attr_reader :errors, :competition

    def initialize(competition_params, repository = Competition)
      @competition_params = competition_params
      @repository         = repository

      @errors       = {}
      @competition  = nil
    end

    def run
      @competition = @repository.create(@competition_params)

      if @competition.valid?
        # TODO: validate mailchimp api_key and list_id here
      else
        @errors.merge!(@competition.errors.as_json)
      end

      return self
    end
  end
end
