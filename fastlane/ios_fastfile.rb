fastlane_version "2.38.0"

default_platform :ios

platform :ios do

  MASTER_PATH = "https://github.com/CocoaPods/Specs"
  PRIVATE_PATH = "git@git.yourdomain.com:ios/YourSpecs.git"
  SOURCES = [MASTER_PATH, PRIVATE_PATH]
  FIR_APPKEY = 'your fir key'


  desc 'Deploy a new version to the App Store'
  lane :do_deliver_app do |options|
    app_identifier = options[:app_identifier]
    scheme = options[:scheme]
    version = options[:version]
    build = options[:build] || Time.now.strftime('%Y%m%d%H%M')
    output_directory = options[:output_directory]
    output_name = options[:output_name]
    plist = options[:plist]
    branch = options[:branch]

    git_pull_and_pod

    update_build_number(version: build, plist: plist)
    gym(scheme: scheme, clean: true, output_directory: output_directory, output_name: output_name, export_method: 'app-store')

    deliver(force: false, skip_screenshots: true, skip_metadata: true)

    git_add(path: '.')
    git_commit(path: '.', message: "Update build number to #{build} and upload to itunesconnect")
    git_pull
    git_push(branch: branch)

    bugly_upload_dsym(version: version, dsym_dir: output_directory, dsym_zip_name: output_name, bundle_identifier: app_identifier)
  end

  desc "Release new private pod version"
  lane :do_release_lib do |options|
    target_version = options[:version]
    podspec_path = options[:podspec_path]

    git_pull
    pod_repo_update(name: "GMSpecs")
    pod_install

    pod_lib_lint(verbose: true, allow_warnings: true, sources: SOURCES, use_bundle_exec: true, fail_fast: true)
    version_bump_podspec(path: podspec_path, version_number: target_version) # 更新 podspec
    git_commit_all(message: "Bump version to #{target_version}") # 提交版本号修改
    add_git_tag(tag: target_version) # 设置 tag
    push_to_git_remote # 推送到 git 仓库

    pod_push(path: podspec_path, repo: "GMSpecs", allow_warnings: true, sources: SOURCES) # 提交到 CocoaPods
    pod_repo_update
  end

  desc 'Publish a beta version'
  lane :do_publish_beta do |options|
    scheme = options[:scheme]
    output_directory = options[:output_directory]
    output_name = options[:output_name]
    cocoapods
    gym(scheme: scheme, clean: false, output_directory: output_directory, output_name: output_name, export_method: 'ad-hoc')
  end

  desc 'Publish a test version'
  lane :do_publish_test do |options|
    scheme = options[:scheme]
    output_directory = options[:output_directory]
    output_name = options[:output_name]

    git_pull_and_pod
    gym(scheme: scheme, clean: false, output_directory: output_directory, output_name: output_name, export_method: 'ad-hoc')
    upload_app_to_fir(file_path: File.join(output_directory,"#{output_name}.ipa"), app_key:FIR_APPKEY)
  end

  private_lane :git_pull_and_pod do |options|
    git_pull
    pod_repo_update(name: "GMSpecs")
    cocoapods
  end

  error do |lane, exception|
    UI.message(exception.message)
  end

end