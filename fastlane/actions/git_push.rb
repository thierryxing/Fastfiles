module Fastlane
  module Actions
    class GitPushAction < Action
      def self.run(params)
        cmd = "git push"
        if params[:branch]
          cmd << " origin #{params[:branch]}"
        end
        result = Actions.sh(cmd.to_s)
        UI.success("Successfully pushed 💾.")
        return result
      end

      def self.description
        "Directly commit the given file with the given message"
      end

      def self.details
        ""
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :branch,
                                       description: "The branch you want to push",
                                       is_string: false,
                                       verify_block: proc do |value|
                                       end),
        ]
      end

      def self.output
      end

      def self.return_value
        nil
      end

      def self.authors
        ["thierryxing"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
