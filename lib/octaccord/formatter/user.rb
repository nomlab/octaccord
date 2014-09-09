module Octaccord
  module Formatter
    class User
      def initialize(user)
        @resource = user
      end

      def login
        @resource.login
      end

      def id
        @resource.id
      end

      def url
        @resource.html_url
      end

      def type
        @resource.type
      end

      def site_admin?
        @resource.site_admin
      end

      def avatar
        sep = (/\?/ =~ @resource.avatar_url) ? "&" : "?"
        return "![#{@resource.login}](#{@resource.avatar_url}#{sep}s=20 \"#{@resource.login}\")"
      end

      def references
        @resource.body.scan(/#(\d+)/).map{|d| d.first.to_i}
      end

      def link(text: @resource.login)
        return "![#{@resource.login}](#{@resource.html_url})"
      end

    end # class User
  end # module Formatter
end # module Octaccord
