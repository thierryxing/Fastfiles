module Fastlane
  module Actions
    class PodInstallAction < Action
      def self.run(params)
      	Actions.sh "cd Example && pod install"
        Helper.log.info "Successfully pod install ⬆️ ".green
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

      def self.authors
        ["thierry"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
