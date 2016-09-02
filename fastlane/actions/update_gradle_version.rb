require "java-properties"
module Fastlane
  module Actions
    class UpdateGradleVersionAction < Action
      def self.run(params)
        properties = JavaProperties.load("gradle.properties")
        properties[:VERSION_NAME] = params[:version]
        JavaProperties.write(properties, "gradle.properties")
      end

      def self.description
        "Update gradle aar version"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :version,
                                       description: "The value for VERSION_NAME in gradle.properties",
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
