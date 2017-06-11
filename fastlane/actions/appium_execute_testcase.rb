module Fastlane
  module Actions

    class AppiumExecuteTestcaseAction < Action
      def self.run(params)
        # fastlane will take care of reading in the parameter and fetching the environment variable:
        #  appium --session-override --default-capabilities '{"noReset":true}'
        # . /Users/Thierry/Code/Python/env/bin/activate
        #  python -m unittest discover -s /Users/Thierry/Code/Python/saturn/ios/wiki -p "test_*.py"
        # sh "shellcommand ./path"
        Action.sh ". #{params[:python_env_path]}"
        
        Dir.chdir(params[:python_testcase_path]) do
        
          command = ['python']
          command << '-m unittest'
          command << "discover -s #{params[:script_path]}"
          command << "-p '#{params[:file_name]}'"
        
          Actions.sh command.join(' ')
        
        end
      end

      #####################################################
      # @!group Documentation
      #####################################################

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
          FastlaneCore::ConfigItem.new(key: :python_env_path,
                                       description: "Python virtual env folder path",
                                       is_string: true
                                       ),
          FastlaneCore::ConfigItem.new(key: :script_path,
                                       description: "Python script path",
                                       is_string: true
                                       ),
          FastlaneCore::ConfigItem.new(key: :python_testcase_path,
                                       description: "Python testcase project path",
                                       is_string: true
                                       ),
          FastlaneCore::ConfigItem.new(key: :file_name,
                                       description: "Python testcase file name",
                                       is_string: true
                                       )
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['APPIUM_EXECUTE_TESTCASE_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If you method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["Your GitHub/Twitter Name"]
      end

      def self.is_supported?(platform)
        # you can do things like
        # 
        #  true
        # 
        #  platform == :ios
        # 
        #  [:ios, :mac].include?(platform)
        # 

        platform == :ios
      end
    end
  end
end
