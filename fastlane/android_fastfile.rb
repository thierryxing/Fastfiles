fastlane_version "2.2.0"

default_platform :android

ENV["JG_ANDROID_SDK_DIR"] = %x( echo $ANDROID_HOME ).chomp

platform :android do

  desc "Deliver a new app version"
  lane :do_deliver_app do |options|
    git_pull
    create_properties
    gradle(task: "clean")
    gradle(task: "assembleRelease")
  end

  desc "Publish a test version"
  lane :do_publish_test do |options|
    git_pull
    assemble_test
  end

  desc "Publish a test version"
  lane :do_publish_beta do |options|
    assemble_test
  end

  desc "Release a new version to the Gengmei Maven Repo"
  lane :do_release_lib do |options|
    target_version = options[:version]

    git_pull
    update_gradle_version(version: target_version)
    create_properties
    gradle(task: "upload")
    git_commit_all(message: "Bump version to #{target_version}") # 提交版本号修改
    add_git_tag(tag: target_version, message: "Bump version to #{target_version}") # 设置 tag
    push_to_git_remote # 推送到 git 仓库
  end

  private_lane :create_properties do |options|
    create_local_properties(user: 'liuguanglei', password: 'liuguanglei')
  end

  private_lane :assemble_test do |options|
    create_properties
    gradle(task: "clean")
    gradle(task: "assembleGmtest")
  end

  error do |lane, exception|
    UI.message(exception.message)
  end

end