module Octaccord
  module Command
    dir = File.dirname(__FILE__) + "/command"
    autoload :AddCollaborator, "#{dir}/add_collaborator.rb"
    autoload :Comments,        "#{dir}/comments.rb"
    autoload :Completions,     "#{dir}/completions.rb"
    autoload :GetTeamMembers,  "#{dir}/get_team_members.rb"
    autoload :Info,            "#{dir}/info.rb"
    autoload :Label,           "#{dir}/label.rb"
    autoload :Link,            "#{dir}/link.rb"
    autoload :Scan,            "#{dir}/scan.rb"
    autoload :Show,            "#{dir}/show.rb"
    autoload :UpdateIssues,    "#{dir}/update_issues.rb"
    autoload :CreateIteration, "#{dir}/create_iteration.rb"
    autoload :CreateIssue,     "#{dir}/create_issue.rb"
  end # module Command
end # module Octaccord
