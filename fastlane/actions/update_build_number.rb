module Fastlane
  module Actions

    class UpdateBuildNumberAction < Action
 
      #/usr/libexec/PlistBuddy -c "Set :CFBundleVersion 201605141556" GengmeiDoctor/Info.plist
      def self.run(params)
   
        command = []
        command << "/usr/libexec/PlistBuddy"
        command << "-c"
        command << "\"Set :CFBundleVersion #{params[:version]}\""
        command << params[:plist]

        result = Actions.sh(command.join(' '))
        Helper.log.info "Update Build Number Successfully ⬆️ ".green
        return result
      end

      def self.output
        [
          ['BUILD_NUMBER', 'The new build number']
        ]
      end
      
      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :version,
          description: "Build version",
          is_string: true),
          FastlaneCore::ConfigItem.new(key: :plist,
          description: "Plist file",
          is_string: true)
        ]
      end
      
      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Set the build version of your project"
      end

      def self.authors
        ["thierry"]
      end

      def self.is_supported?(platform)
        [:ios].include? platform
      end
    end
  end
end
