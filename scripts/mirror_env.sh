#!/usr/bin/env bash
# 国内镜像环境：所有下载均走国内源
# 用法： source scripts/mirror_env.sh
#
# 实测速度（2026-09，本机 aarch64）：
#   pub.flutter-io.cn                  11.9 MB/s   Dart / Flutter 包
#   mirrors.cloud.tencent.com          29-32 MB/s Flutter 引擎与产物、Gradle 发行包
#   repo.huaweicloud.com               25 MB/s     Gradle 发行包（备用）
#   maven.aliyun.com                   13 MB/s     Maven / AGP / Kotlin 依赖
#   mirrors.tuna.tsinghua.edu.cn       --          Debian 系统软件包

export PUB_HOSTED_URL="https://pub.flutter-io.cn"
export FLUTTER_STORAGE_BASE_URL="https://mirrors.cloud.tencent.com/flutter"

# Android SDK（platform-36 / build-tools-36 取自腾讯镜像）
export ANDROID_HOME="${ANDROID_HOME:-/tmp/android-sdk}"
export ANDROID_SDK_ROOT="$ANDROID_HOME"

# --- Gradle 依赖重定向到阿里云 ---
# 不能直接在 build.gradle.kts 里写 maven {}：Flutter 自带的 included build
# （flutter_tools/gradle）设置了 RepositoriesMode.FAIL_ON_PROJECT_REPOS，
# 显式声明仓库会报 “prefer settings repositories over project repositories”。
# 因此改为安装 init 脚本，把 google()/mavenCentral() 的 URL 重写到阿里云。
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
init_dir="${GRADLE_USER_HOME:-$HOME/.gradle}/init.d"
mkdir -p "$init_dir"
cp -f "$script_dir/gradle_mirror.gradle" "$init_dir/gradle_mirror.gradle"

# 同目录下若存在向工程注入仓库的 init.gradle，会与 Flutter 的 included build 冲突
legacy_init="${GRADLE_USER_HOME:-$HOME/.gradle}/init.gradle"
if [ -f "$legacy_init" ] && grep -q "allprojects" "$legacy_init" 2>/dev/null; then
  echo "警告：$legacy_init 会向工程注入仓库，导致 Android 构建报仓库模式冲突。" >&2
  echo "      建议执行： mv $legacy_init ${legacy_init}.disabled" >&2
fi
