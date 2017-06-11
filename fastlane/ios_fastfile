fastlane_version "2.2.0"

default_platform :ios

platform :ios do

  ENV['HIPCHAT_API_VERSION'] = '2'
  ENV['HIPCHAT_API_HOST'] = 'hipchat.gengmei.cc'
  ENV['HIPCHAT_NOTIFY_ROOM'] = 'true'
  ENV['FL_HIPCHAT_CHANNEL'] = "iOS%20Team"
  ENV['HIPCHAT_API_TOKEN'] = ""
  ENV['FL_AUTOMATION_TEMPLATE'] = '/Applications/Xcode.app/Contents/Applications/Instruments.app/Contents/PlugIns/AutomationInstrument.xrplugin/Contents/Resources/Automation.tracetemplate'

  MASTER_PATH = "https://github.com/CocoaPods/Specs"
  PRIVATE_PATH = "git@git.gengmei.cc:gengmeiios/GMSpecs.git"
  SOURCES = [MASTER_PATH, PRIVATE_PATH]


  desc 'Deploy a new version to the App Store'
  lane :do_deliver_app do |options|
    app_identifier   = options[:app_identifier]
    project          = options[:project]
    scheme           = options[:scheme]
    version          = options[:version]
    build            = options[:build] || Time.now.strftime('%Y%m%d%H%M')
    output_directory = options[:output_directory]
    output_name      = options[:output_name]
    plist            = options[:plist]
    branch           = options[:branch]
    
    hipchat(message: "Start deilver app #{project} at version #{version}")
    
    hipchat(message: "app_identifier #{app_identifier}, project #{project}, version #{version}, build #{build}, output_directory #{output_directory}, output_name #{output_name} ")

    git_pull
    pod_repo_update
    cocoapods

    begin
      cert(username: ENV["FASTLANE_USER"])
      sigh(username: ENV["FASTLANE_USER"], app_identifier: app_identifier)
    rescue => e
      puts e.message
    end

    update_build_number(version: build, plist: plist)
    gym(scheme: scheme, clean: true, output_directory: output_directory, output_name: output_name, export_method: 'app-store')

    deliver(force: false, skip_screenshots: true, skip_metadata: true)
    
    git_add(path: '.')
    git_commit(path: '.', message: "update build number to #{build} and upload to itunesconnect")
    git_pull
    git_push(branch: branch)

    bugly_upload_dsym(version: version, dsym_dir: output_directory, dsym_zip_name: output_name, bundle_identifier: app_identifier)
  end

  desc "Release new private pod version"
  lane :do_release_lib do |options|
    target_version = options[:version]
    project = options[:project]
    path = "#{project}.podspec"

    hipchat(message: "Start release pod #{project} at version #{target_version}")

    git_pull
    ensure_git_branch # 确认 master 分支
    pod_install
    
    pod_lib_lint(verbose: true, allow_warnings: true, sources: SOURCES, use_bundle_exec: true, fail_fast: true)
    version_bump_podspec(path: path, version_number: target_version) # 更新 podspec
    git_commit_all(message: "Bump version to #{target_version}") # 提交版本号修改
    add_git_tag(tag: target_version) # 设置 tag
    push_to_git_remote # 推送到 git 仓库
    pod_push(path: path, repo: "GMSpecs", allow_warnings: true, sources: SOURCES) # 提交到 CocoaPods
    pod_repo_update
    hipchat(message: "Release pod #{project} Successfully!")
  end

  desc 'Publish a beta version'
  lane :do_publish_beta do |options|
    app_identifier     = options[:app_identifier]
    project            = options[:project]
    scheme             = options[:scheme]
    output_directory   = options[:output_directory]
    output_name        = options[:output_name]

    hipchat(message: "Start publish beta #{project}")
    hipchat(message: "app_identifier #{app_identifier}, project #{project}, output_directory #{output_directory}, output_name #{output_name} ")
    hipchat(message: "Pod install")
    cocoapods
    
    begin
      cert(username: ENV["FASTLANE_USER"])
      sigh(username: ENV["FASTLANE_USER"], app_identifier: app_identifier, adhoc: true, force:true)
    rescue => e
      puts e.message
    end    
    
    gym(scheme: scheme, clean: false, output_directory: output_directory, output_name: output_name, export_method: 'ad-hoc')
  end
  
  desc 'Publish a test version'
  lane :do_publish_test do |options|
    app_identifier     = options[:app_identifier]
    project            = options[:project]
    scheme             = options[:scheme]
    output_directory   = options[:output_directory]
    output_name        = options[:output_name]
    bugly_app_key      = options[:bugly_app_key]
    bugly_exp_id       = options[:bugly_exp_id]
    fir_key            = options[:fir_key]
    
    git_pull
    pod_repo_update(name: "GMSpecs")    
    cocoapods
    
    begin
      cert(username: ENV["FASTLANE_USER"])
      sigh(username: ENV["FASTLANE_USER"], app_identifier: app_identifier, adhoc: true)
    rescue => e
      puts e.message
    end
    
    gym(scheme: scheme, clean: false, output_directory: output_directory, output_name: output_name, export_method: 'ad-hoc')
  end

  desc "UI automation test"
  lane :do_automation_test do |options|
    scheme             = options[:scheme]
    project            = options[:project]
    device_udid        = options[:device_udid]
    device_type        = options[:device_type]
    script_paths       = options[:script_paths]
    file_names         = options[:file_names]
    report_output_path = options[:report_output_path]
    ios_sdk            = options[:ios_sdk]

    hipchat(message: "Start UI AutoTest on #{project}")
    cocoapods

    xcodebuild(scheme: scheme, arch: 'x86_64', sdk: ios_sdk, workspace: "#{project}.xcworkspace", configuration: 'UnitTest')
    app_path = get_debug_app_path(scheme: scheme, project: project, ios_sdk: ios_sdk)
    script_paths.split(",").each_with_index do |path, index|
      begin
        appium_execute_testcase(script_path: path,
                                python_testcase_path: ENV['FASTLANE_PYTHON_TESTCASE_PATH'],
                                python_env_path: ENV['FASTLANE_PYTHON_ENV_PATH'],
                                file_name: file_names.split(",")[index])
      rescue
        next
      end
    end

    hipchat(message: "Execute UI AutoTest on #{project} successfully")
  end

  error do |lane, exception|
    hipchat(
        custom_color: 'red',
        message: exception.message,
        success: false
    )
  end

end