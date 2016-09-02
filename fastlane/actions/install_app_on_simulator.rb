module Fastlane
  module Actions

    class InstallAppOnSimulatorAction < Action
      def self.run(params)
        device_type = params[:device_type]
        app_path = params[:app_path]
        command = ['set -o pipefail && ios-sim'] 
        command << "install #{app_path}"  
        command << "--devicetypeid #{device_type}"
        command << "--exit"
      
        Action.sh command.join(' ')
      end
      
      # ios-sim install /Users/Thierry/Library/Developer/Xcode/DerivedData/Gengmei-fwlefrcslagvocbtnylgubtdgofr/Build/Products/Debug-iphonesimulator/Gengmei.app --devicetypeid iPhone-6s, 9.3 --exit
      def self.description
        "A short description with <= 80 characters of what this action does"
      end

      def self.details
        # Optional:
        # this is your chance to provide a more detailed description of this action
        "You can use this action to do cool things..."
      end

      def self.available_options
        # Define all options your action supports. 
        
        # Below a few examples
        [
          FastlaneCore::ConfigItem.new(key: :device_type,
                                       description: "Device Type"
                                       ),
          FastlaneCore::ConfigItem.new(key: :app_path,
                                       description: "App Path")
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['INSTALL_APP_ON_SIMULATOR_CUSTOM_VALUE', 'A description of what this value contains']
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
