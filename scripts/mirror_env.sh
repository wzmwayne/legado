#!/usr/bin/env bash
# 国内镜像环境：所有下载均走国内源
# 用法： source scripts/mirror_env.sh
#
# 实测速度（2026-09，本机 aarch64）：
#   pub.flutter-io.cn                 11.9 MB/s   Dart/Flutter 包
#   mirrors.cloud.tencent.com         32   MB/s   Flutter 引擎与产物、AndroidSDK、gradle 发行包
#   maven.aliyun.com                  13   MB/s   Maven/AGP/Kotlin 依赖
#   mirrors.tuna.tsinghua.edu.cn       --          Debian apt

export PUB_HOSTED_URL="https://pub.flutter-io.cn"
export FLUTTER_STORAGE_BASE_URL="https://mirrors.cloud.tencent.com/flutter"

# Android SDK（platform-36 / build-tools-36 来自腾讯镜像）
export ANDROID_HOME="${ANDROID_HOME:-/tmp/android-sdk}"
export ANDROID_SDK_ROOT="$ANDROID_HOME"

# Gradle 依赖走阿里云（android/ 下仓库已在 settings.gradle.kts 与 build.gradle.kts 中配置）
# Gradle 发行包走腾讯镜像（android/gradle/wrapper/gradle-wrapper.properties）
