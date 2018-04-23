fastlane_version "2.85.0"

default_platform :ios

ENV["FASTLANE_XCODEBUILD_SETTINGS_TIMEOUT"] = "30"
ENV["FASTLANE_XCODEBUILD_SETTINGS_RETRIES"] = "20"

platform :ios do
  
  MASTER_PATH = "https://github.com/CocoaPods/Specs"
  PRIVATE_PATH = "git@git.yourcompany.com:your_group/YourSpecs.git"
  PRIVATE_SPEC = "YourSpecs"
  SOURCES = [MASTER_PATH, PRIVATE_PATH]

  desc 'Deploy a new version to the App Store'
  lane :do_publish_prod do |options|
    app_identifier = options[:ios_app_identifier]
    scheme = options[:ios_scheme]
    version = options[:version]
    build = options[:build_number] || Time.now.strftime('%Y%m%d%H%M')
    output_directory = options[:ios_output_directory]
    output_name = options[:ios_output_name]
    plist = options[:ios_plist_file]
    branch = options[:git_branch]

    git_pull_and_pod

    update_build_number(version: build, plist: plist)
    gym(scheme: scheme, configuration:'AppStore', clean: true, output_directory: output_directory, output_name: output_name, export_method: 'app-store', silent: true, suppress_xcode_output:true)

    deliver(force: false, skip_screenshots: true, skip_metadata: true)

    git_add(path: '.')
    git_commit(path: '.', message: "Update build number to #{build} and upload to itunesconnect")
    git_pull
    git_push(branch: branch)
  end

  desc "Release new private pod version"
  lane :do_publish_lib do |options|
    target_version = options[:version]
    podspec_path = options[:ios_podspec_path]

    git_pull
    pod_repo_update(repo: PRIVATE_SPEC)
    pod_install(repo: PRIVATE_SPEC)

    pod_lib_lint(verbose: false, allow_warnings: true, sources: SOURCES, use_bundle_exec: true, fail_fast: true)
    version_bump_podspec(path: podspec_path, version_number: target_version) # 更新 podspec
    git_commit_all(message: "Bump version to #{target_version}") # 提交版本号修改
    add_git_tag(tag: target_version) # 设置 tag
    push_to_git_remote # 推送到 git 仓库

    pod_push(path: podspec_path, repo: PRIVATE_SPEC, allow_warnings: true, sources: SOURCES) # 提交到 CocoaPods
    pod_repo_update(repo: PRIVATE_SPEC)
  end

  desc 'Publish a beta version'
  lane :do_publish_beta do |options|
    scheme = options[:ios_scheme]
    output_directory = options[:output_directory]
    output_name = options[:output_name]
    cocoapods
    gym(scheme: scheme, configuration:'Release', output_directory: output_directory, output_name: output_name, export_method: 'ad-hoc', silent: true, suppress_xcode_output:true)
  end

  desc 'Publish a test version'
  lane :do_publish_test do |options|
    scheme = options[:ios_scheme]
    bundle_identifier = options[:ios_bundle_identifier]
    output_directory = options[:ios_output_directory]
    output_name = options[:ios_output_name]
    version = options[:version]

    git_pull_and_pod
    sigh(adhoc: true, username: ENV['FASTLANE_USER'], app_identifier: bundle_identifier)
    gym(scheme: scheme, configuration:'Release', output_directory: output_directory, output_name: output_name, export_method: 'ad-hoc', silent: true, suppress_xcode_output:true)
  end

  private_lane :git_pull_and_pod do |options|
    git_pull
    pod_repo_update(repo: PRIVATE_SPEC)
    cocoapods
  end

  error do |lane, exception|
    UI.message(exception.message)
  end

end
