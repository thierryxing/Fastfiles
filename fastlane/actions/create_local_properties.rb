require "java-properties"

module Fastlane
  module Actions
    class CreateLocalPropertiesAction < Action
      def self.run(params)
        properties = {}
        properties['sdk.dir'] = ENV["JG_ANDROID_SDK_DIR"]
        properties[:user] = params[:user]
        properties[:password] = params[:password]
        UI.message("sdk.dir:#{properties['sdk.dir']}")
        JavaProperties.write(properties, "local.properties")
      end

      def self.description
        "Create a local.properties file , and write into android sdk path and maven access account"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :user,
                                       description: "maven username",
                                       is_string: true),
          FastlaneCore::ConfigItem.new(key: :password,
                                       description: "maven password",
                                       is_string: true)
        ]
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["thierry"]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
