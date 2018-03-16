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
      else
        @errors.merge!(@competition.errors.as_json)
      end

      return self
    end
  end
end
