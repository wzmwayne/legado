# 阅读

多平台小说阅读器，使用 Flutter 重写。Android 与 Linux 桌面共用一套自适应界面，
阅读器排版与交互尽量贴近原版体验，其余界面做简化还原。

## 功能状态

已实现：

- **书架**：网格 / 列表切换、每行列数、按最近阅读 / 书名 / 作者 / 加入时间排序、书名作者搜索、长按操作菜单
- **本地导入**：TXT 导入，UTF-8 / UTF-8 BOM / GBK 自动识别，按章节标题自动切分（会过滤正文中误匹配的句子）
- **阅读器**：覆盖 / 滑动 / 滚动 / 无动画四种翻页方式；点击左右三分之一翻页、中间呼出菜单
- **排版**：字号、行距、字距、段距、加粗可按需调整；内置 6 套排版预设（数值取自原版默认数据）
- **阅读设置**：夜间模式、亮度调节、页眉页脚内容自由组合（无 / 书名 / 章节名 / 页码 / 进度 / 时间）
- **目录与进度**：左侧目录抽屉、章节滑块、阅读进度自动保存
- **整体配色**：默认 / 典雅蓝 / 黑白 / A屏黑 四套主题
- **数据备份**：导出为单个 zip 备份包、从备份包恢复
- **WebDAV 同步**：以单个备份包为同步单位，支持测试连接、上传、从云端恢复

暂未实现（后续里程碑）：

- 书源规则解析与在线搜索、下载（JS / CSS / XPath / JSONPath 规则引擎）
- 仿真翻页动画、朗读、RSS、字典查询、正文替换净化
- EPUB / UMD 等其它格式解析
- 页脚电量显示、屏幕常亮

## 数据格式

自定义格式，全部保存在应用私有目录（Linux 下为 `~/.local/share/wzmwayne.reader/reader`）：

```
library.json                    书架索引（含 format 与 version 字段）
settings.json                   应用设置
reader_settings.json            阅读设置
webdav.json                     WebDAV 配置
books/<bookId>/chapters.json    章节目录（按字符区间定位）
books/<bookId>/content.txt      书籍正文
```

备份包为 zip，内含 `manifest.json` 与上述数据文件；WebDAV 密码不会写入备份。

## 构建

环境要求：Flutter 3.47 stable、JDK 17+；Linux 桌面另需 `clang cmake ninja-build pkg-config libgtk-3-dev`
以及中文字体（如 `fonts-noto-cjk`）；Android 需 Android SDK Platform 36 与 Build-Tools 36。

所有依赖均走国内镜像，构建前先加载环境变量：

```bash
source scripts/mirror_env.sh
```

| 用途 | 镜像 | 实测速度 |
| --- | --- | --- |
| Dart / Flutter 包 | `pub.flutter-io.cn` | 11.9 MB/s |
| Flutter 引擎与产物 | `mirrors.cloud.tencent.com/flutter` | 32 MB/s |
| Maven / AGP / Kotlin | `maven.aliyun.com` | 13 MB/s |
| Android SDK / Gradle 发行包 | `mirrors.cloud.tencent.com` | — |
| 系统软件包 | `mirrors.tuna.tsinghua.edu.cn` | — |

构建命令：

```bash
flutter pub get
flutter test                      # 单元测试
flutter build linux --release     # Linux 桌面
flutter build apk --release       # Android
```

Android 构建说明：Android 构建工具链里的 `aapt2` 官方只提供 x86-64 版本，
在 aarch64 主机上需要 `binfmt_misc` + qemu 才能执行；x86-64 主机无此限制。

## 目录结构

```
lib/
  main.dart                 应用入口与主题装配
  models/                   数据模型（书籍、章节、阅读设置、应用设置）
  services/                 存储、导入、备份、WebDAV、同步
  state/                    全局状态（书架、设置、同步）
  reader/                   阅读器界面与分页引擎
  pages/                    书架页、设置页、WebDAV 页
  widgets/                  通用组件
  theme/                    主题配色与中文字形回退
test/                       单元测试（导入切分、分页、备份往返）
scripts/mirror_env.sh       国内镜像环境变量
```

## 许可证

GPL-3.0。界面设计与排版参数参考自原 Legado 项目，按其开源许可保留原始版权声明，
详见 [LICENSE](LICENSE)。
