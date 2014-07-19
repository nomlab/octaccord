require "octokit"

module Octokit
  class Client
    module Issues
      # There are these two PRs in the octokit upstream issues.
      # However, both of them are not merged yet.
      # So, I introduced PR 232 by hand.
      # https://github.com/octokit/octokit.rb/pull/229
      # https://github.com/octokit/octokit.rb/pull/232
      def ext_update_issue(repo, number, options = {})
        patch "#{Repository.path repo}/issues/#{number}", options
      end
    end
  end
end
