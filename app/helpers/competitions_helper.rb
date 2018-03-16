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
