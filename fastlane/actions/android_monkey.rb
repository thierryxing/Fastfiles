module Fastlane
  module Actions
    module SharedValues
      ANDROID_MONKEY_CUSTOM_VALUE = :ANDROID_MONKEY_CUSTOM_VALUE
    end

    #adb shell monkey -p com.wanmeizhensuo.zhensuo --ignore-security-exceptions --ignore-crashes --ignore-timeouts --monitor-native-crashes --throttle  300 --pct-touch 94 --pct-motion 6 -s 1000 -v -v -v 6000
    class AndroidMonkeyAction < Action
      def self.run(params)
        package_name = params[:package_name]
        count = params[:count]
        seed = params[:seed]
        
        command = ['adb shell monkey']
        command << "-p #{package_name}"
        command << '--ignore-security-exceptions'
        command << '--ignore-timeouts'
        command << '--monitor-native-crashes'
        command << '--monitor-native-crashes'
        command << "--throttle 500"
        command << "--pct-touch 94"
        command << "--pct-motion 6"
        command << "-s #{seed}"
        command << "-v -v -v"
        command << "#{count}"
        Action.sh command.join(' ')
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "Android Monkey Test"
      end

      def self.details
        "Android Monkey Test"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :package_name,
                                       description: "Android App Package Name"),
          FastlaneCore::ConfigItem.new(key: :count,
                                       description: "Event count"),
          FastlaneCore::ConfigItem.new(key: :seed,
                                       description: "Seed count")
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['ANDROID_MONKEY_CUSTOM_VALUE', 'A description of what this value contains']
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
        platform == :android
      end
    end
  end
end
