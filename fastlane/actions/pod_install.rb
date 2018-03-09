module Fastlane
  module Actions
    class PodInstallAction < Action
      def self.run(params)
      	Actions.sh "pod repo update #{params[:name]} && cd Example && pod install"
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Update all pods"
      end

      def self.details
        "Update all pods"
      end
      
      def self.available_options
        # Define all options your action supports. 
        [
          FastlaneCore::ConfigItem.new(key: :name,
                                       description: "name",
                                       is_string: true,
                                       verify_block: proc do |value|
                                       end),
        ]
      end

      def self.authors
        ["thierry"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
