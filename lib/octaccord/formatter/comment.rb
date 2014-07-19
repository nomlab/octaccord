module Octaccord
  module Formatter
    class Comment
      def initialize(comment)
        @resource = comment
      end

      def user
        User.new(@resource.user)
      end

      def url
        @resource.url
      end

      def created_at
        @resource.created_at.localtime
      end

      def updated_at
        @resource.updated_at.localtime
      end

      def html_url
        @resource.html_url
      end

      def issue_url
        @resource.issue_url
      end

      def id
        @resource.id
      end

      def body
        @resource.body
      end

      def references
        @resource.body.scan(/#(\d+)/).map{|d| d.first.to_i}
      end

      def summary
        lines = @resource.body.split(/\r?\n/).map{|line|
          line.sub(/^[*#]+\s+/, "")
        }.join(" ")[0,200]
      end

      alias_method :title, :summary

      def link(text: "...")
        "[#{text}](#{@resource.html_url})"
      end

    end # class Comment
  end # module Formatter
end # module Octaccord
