module Fastlane
  module Actions
    module SharedValues
      BUGLY_UPLOAD_DSYM_CUSTOM_VALUE = :BUGLY_UPLOAD_DSYM_CUSTOM_VALUE
    end

    class BuglyUploadDsymAction < Action
      def self.run(params)
        zipDsym = "#{params[:dsym_dir]}/#{params[:dsym_zip_name]}.app.dSYM.zip"
        unzipDsym = "#{params[:dsym_dir]}/dSYMs"
        symbolPath = "#{params[:dsym_dir]}/dSYMSymobls"

        
        identifier = "#{params[:bundle_identifier]}"

        # 默认是“更美用户iOS”的bugly线上帐号：
        buglyAppId = '900008467'
        buglyAppKey = 'DDdQRy3jWYiNUKa4'
        if identifier == "com.wanmeizhensuo.Doctor"
          buglyAppId = 'fa6f576e6e'
          buglyAppKey = 'd88f0596-b55a-4b42-93b1-29ba067c2010'
        end

        # 可以用下面两行代码测试真实执行代码是否正确
        # UI.message "unzip -o #{zipDsym} -d #{unzipDsym}"
        # UI.message "sh ~/Applications/BuglydSYMUploader/dSYMUpload.sh #{buglyAppId} #{buglyAppKey} #{params[:bundle_identifier]} #{params[:version]} #{unzipDsym} #{symbolPath}"

        sh "unzip -o #{zipDsym} -d #{unzipDsym}"
        sh "sh ~/bin/BuglydSYMUploader/dSYMUpload.sh #{buglyAppId} #{buglyAppKey} #{params[:bundle_identifier]} #{params[:version]} #{unzipDsym} #{symbolPath} 0"
      end

      #####################################################
      # @!group Documentation
      #####################################################

      def self.description
        "upload dsym symbol to bugly"
      end

      def self.details
        "unzip the dsym zip file, then use bugly dsym tools to parse and upload dsym symbol to bugly"
      end

      def self.available_options
        # Define all options your action supports. 
        
        [
          FastlaneCore::ConfigItem.new(key: :version,
                                       description: "iOS app 版本号", # a short description of this parameter
                                       verify_block: proc do |value|
                                       end),
          FastlaneCore::ConfigItem.new(key: :dsym_dir,
                                       description: "dsym所在的目录", # a short description of this parameter
                                       verify_block: proc do |value|
                                       end),
          FastlaneCore::ConfigItem.new(key: :dsym_zip_name,
                                       description: "dsym zip 文件名", # a short description of this parameter
                                       verify_block: proc do |value|
                                       end),
          FastlaneCore::ConfigItem.new(key: :bundle_identifier,
                                       description: "iOS app 包名", # a short description of this parameter
                                       verify_block: proc do |value|
                                       end)
        ]
      end

      def self.output
        # Define the shared values you are going to provide
        # Example
        [
          ['BUGLY_UPLOAD_DSYM_CUSTOM_VALUE', 'A description of what this value contains']
        ]
      end

      def self.return_value
        # If you method provides a return value, you can describe here what it does
      end

      def self.authors
        # So no one will ever forget your contribution to fastlane :) You are awesome btw!
        ["wangyang_igiu"]
      end

      def self.is_supported?(platform)
        [:ios, :mac].include?(platform)
      end
    end
  end
end
