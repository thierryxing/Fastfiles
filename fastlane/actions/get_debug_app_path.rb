module Fastlane
  module Actions
    module SharedValues
      GET_DEBUG_APP_PATH_CUSTOM_VALUE = :GET_DEBUG_APP_PATH_CUSTOM_VALUE
    end

    # To share this integration with the other fastlane users:
    # - Fork https://github.com/fastlane/fastlane/tree/master/fastlane
    # - Clone the forked repository
    # - Move this integration into lib/fastlane/actions
    # - Commit, push and submit the pull request

    class GetDebugAppPathAction < Action
      
      def self.run(params)
        project = params[:project]
        scheme = params[:scheme]
        command = ['xcodebuild']
        command << '-workspace'
        command << "#{project}.xcworkspace"
        command << '-scheme'
        command << "#{scheme}"
        command << '-sdk'
        command << "iphonesimulator9.3"
        command << '-arch'
        command << "x86_64"
        command << '-configuration Debug -showBuildSettings | grep CONFIGURATION_BUILD_DIR'
        output_result = Actions.sh command.join(' ')
        configure = output_result.match(/CONFIGURATION_BUILD_DIR = (.*)/i).captures
        File.join(configure[0],"#{scheme}.app")
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        # like: /Users/Thierry/Library/Developer/Xcode/DerivedData/Gengmei-fwlefrcslagvocbtnylgubtdgofr/Build/Products/Debug-iphonesimulator/Gengmei.app
        "Get Xcode build app path of simlulator's debug enviroment"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        # Define all options your action supports. 
        [
          FastlaneCore::ConfigItem.new(key: :project,
                                      description: "project name",
                                      is_string: true),
          FastlaneCore::ConfigItem.new(key: :scheme,
                                      description: "scheme name",
                                      is_string: true)
        ]
      end

      def self.output
      end

      def self.return_value
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
