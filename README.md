# Fastfiles
This repository contains a few fastlane fastfile examples and some custom actions that used by our team.
本项目包含我们团队正在使用的一些 Fastlane fastfile 工作流和自定义Action

# 详细说明
## iOS Fastfile

1. Lane  do_publish_prod
发布打包并发布 iPA 到 ITunesConnect

2. Lane do_publish_lib
验证私有 Pod 包，并发布到私有 Pod 仓库中

3.  Lane do_publish_beta
构建并发布 Beta 环境的 IPA 包

4. Lane do_publish_test
构建并发布测试环境的 IPA 包

## Android Fastfile
1. Lane  do_publish_prod
发布打包并发布生产环境的 APK 文件

2. Lane do_publish_lib
验证私有 AAR 包，并发布到私有 Maven 仓库中

3.  Lane do_publish_beta
构建并发布 Beta 环境的 APK 包

4. Lane do_publish_test
构建并发布测试环境的 APK 包

## Actions
1. [android_monkey.rb](https://github.com/thierryxing/Fastfiles/blob/master/fastlane/actions/android_monkey.rb "android_monkey.rb")
跑 Android Monkey 测试

2. [appium_execute_testcase.rb](https://github.com/thierryxing/Fastfiles/blob/master/fastlane/actions/appium_execute_testcase.rb "appium_execute_testcase.rb")
使用 Appium 执行 TestCase

3. [create_local_properties.rb](https://github.com/thierryxing/Fastfiles/blob/master/fastlane/actions/create_local_properties.rb "create_local_properties.rb")
创建本地 java properties 文件

4. [git_push.rb](https://github.com/thierryxing/Fastfiles/blob/master/fastlane/actions/git_push.rb "git_push.rb")
执行 Git Push 命令

5. [install_app_on_simulator.rb](https://github.com/thierryxing/Fastfiles/blob/master/fastlane/actions/install_app_on_simulator.rb "install_app_on_simulator.rb")
安装 App 到 iOS 模拟器

6. [update_app_to_bugly.rb](https://github.com/thierryxing/Fastfiles/blob/master/fastlane/actions/update_app_to_bugly.rb "update_app_to_bugly.rb")
上传 App 至 Bugly

7. [update_build_number.rb](https://github.com/thierryxing/Fastfiles/blob/master/fastlane/actions/update_build_number.rb "update_build_number.rb")
增加 iOS Build Number，封装 PlistBuddy 命令

