fastlane_version "2.81.0"

default_platform :android

ENV["JG_ANDROID_SDK_DIR"] = %x( echo $ANDROID_HOME ).chomp

platform :android do

  desc "Deliver a new app version，upload to Hera"
  lane :do_publish_prod do |options|
    git_pull
    create_properties
    gradle(task: "clean")
    gradle(task: "assembleRelease")
  end

  desc "Publish a test version"
  lane :do_publish_test do |options|
    git_pull
    assemble_test
    cp_build_file(options)
  end

  desc "Publish a test version"
  lane :do_publish_beta do |options|
    assemble_test
    cp_build_file(options)
  end

  desc "Release a new version to the Gengmei Maven Repo"
  lane :do_publish_lib do |options|
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
    create_local_properties(user: 'your_user_name', password: 'your_password')
  end

  private_lane :assemble_test do |options|
    create_properties
    gradle(task: "clean")
    gradle(task: "assembleGmtest", print_command_output: false)
  end
  
  private_lane :cp_build_file do |options|
    source = lane_context[SharedValues::GRADLE_APK_OUTPUT_PATH]
    dest = options[:android_build_dir]
    origin_apk_name = options[:android_origin_apk_name]
    final_apk_name = options[:android_final_apk_name]
    FileUtils.cp(source, dest)
    Dir.chdir(dest) do
      FileUtils.mv(origin_apk_name, final_apk_name)
    end
  end

  error do |lane, exception|
    UI.message(exception.message)
  end

end
