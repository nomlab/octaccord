module Octaccord
  module Command
    class GetTeamMembers
      Encoding.default_external = "UTF-8"

      def initialize(client, teams, **options)
        teams.split(',').each do |team|
          org, team_name = team.split('/')
          response = client.organization_teams(org)
          team_id = response.select{|t| t.name == team_name}.first.id
          response = client.team_members(team_id)
          members = response.map(&:login)
          puts members
        end
      end
    end # class GetTeamMembers
  end # module Command
end # module Octaccord
