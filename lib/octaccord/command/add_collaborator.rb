module Octaccord
  module Command
    class AddCollaborator
      Encoding.default_external = "UTF-8"

      def initialize(client, repos, **options)
        if options[:users]
          add_users(client, repos, options[:users].split(','))
        elsif options[:teams]
          add_team_members(client, repos, options[:teams].split(','))
        end
      end

      def add_users(client, repos, users)
        users.each do |user|
          response = client.add_collaborator(repos, user)
        end
      end

      def add_team_members(client, repos, teams)
        teams.each do |team|
          org, team_name = team.split('/')
          response = client.organization_teams(org)
          team_id = response.select{|t| t.name == team_name}.first.id
          response = client.team_members(team_id)
          members = response.map(&:login)
          members.each do |member|
            response = client.add_collaborator(repos, member)
          end
        end
      end
    end # class AddCollaborator
  end # module Command
end # module Octaccord
