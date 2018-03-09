module Fastlane
  module Actions
    
    # Updates the local clone of the spec-repo
    class PodRepoUpdateAction < Action
      def self.run(params)
        cmd = []
        repos = params[:repos]
        repos.each do |repo|
          cmd << "pod repo update #{repo}"
        end
        result = Actions.sh(cmd.join(";").to_s)
        UI.success("Successfully pod repo update 💾.")
        return result
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Updates the local clone of the spec-repo `NAME`. If `NAME` is omitted this will update all spec-repos in `~/.cocoapods/repos`."
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        # Define all options your action supports. 
        [
          FastlaneCore::ConfigItem.new(key: :repos,
                                       description: "Repos",
                                       is_string: false,
                                       verify_block: proc do |value|
                                       end),
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['POD_REPO_UPDATE_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If you method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["thierryxing"]
      end

      def self.is_supported?(platform)
        platform == :ios
      end
    end
  end
end
