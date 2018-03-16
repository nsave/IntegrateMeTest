module CompetitionsHelper
  def entrant_init(entry)
    {
      competition: { id: entry.competition.id, name: entry.competition.name, requires_entry_name: entry.competition.requires_entry_name? }
    }.to_json
  end

  def competitions_init(competitions)
    competitions.map do |competition|
      build_competition_json(competition)
    end.to_json
  end
end
