class Competition::JsonSerializer
  include CompetitionsHelper

  def initialize(competition)
    @competition = competition
  end

  def as_json(*_)
    {
      name: @competition.name,
      link: competition_entrant_page(@competition)
    }
  end
end
