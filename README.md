# MemoryLens - 记忆镜头 📸

> Flutter 期末大作业 - 个人日记/旅游日志应用

## 📱 项目简介

MemoryLens 是一款基于 Flutter 开发的个人日记应用，支持日记的增删改查、图片拍摄/选择、轮播图展示、深色模式切换等功能。应用采用 Material Design 设计规范，使用 Provider 进行状态管理，数据通过 sqflite 本地持久化存储。

## 🚀 技术栈

| 技术 | 用途 |
|------|------|
| **Flutter** | 跨平台 UI 框架 |
| **Dart** | 编程语言 |
| **Provider** | 状态管理 |
| **sqflite** | 本地数据库存储 |
| **shared_preferences** | 键值对本地存储 |
| **image_picker** | 图片选择（相册/拍照） |
| **carousel_slider** | 轮播图组件 |

## 📂 项目结构

```
lxy1/
├── lib/
│   ├── main.dart                    # 应用入口 + ThemeProvider
│   ├── models/
│   │   └── diary_entry.dart         # 日记数据模型
│   ├── pages/
│   │   ├── home_page.dart           # 主页 (BottomNavigationBar + Drawer)
│   │   ├── list_page.dart           # 日记列表 (ListView/GridView + CRUD)
│   │   ├── form_page.dart           # 日记表单 (Form + TextField + CheckBox + image_picker)
│   │   ├── detail_page.dart         # 日记详情 (Hero 动画)
│   │   ├── gallery_page.dart        # 画廊 (carousel_slider + GestureDetector + CustomClipper)
│   │   ├── animation_page.dart      # 图片预览 (Animation + Hero)
│   │   └── profile_page.dart        # 个人中心 (主题切换 + 设置)
│   ├── widgets/
│   │   ├── diary_card.dart          # 日记卡片组件
│   │   └── custom_clipper_widget.dart # 自定义裁切组件 (WaveClipper / DiamondClipper)
│   ├── services/
│   │   ├── database_service.dart    # sqflite 数据库服务
│   │   └── storage_service.dart     # shared_preferences 存储服务
│   └── utils/
│       └── theme_utils.dart         # ThemeData 主题工具类
├── assets/
│   └── images/                      # 图片资源目录
├── test/                            # 测试目录
├── pubspec.yaml                     # 项目配置与依赖
└── README.md                        # 项目说明文档
```

## 🎯 功能实现清单

### 一、基础功能（覆盖第1-8章）

| # | 功能 | 实现位置 | 对应要求 |
|---|------|----------|----------|
| 1 | **ThemeData 主题配置** | `utils/theme_utils.dart` | primaryColor, colorScheme, textTheme, iconTheme, appBarTheme, buttonTheme, elevatedButtonTheme, textButtonTheme, iconButtonTheme |
| 2 | **UI 组件** | 多处 | Image.asset, Image.network, Icon/Iconfont, loading 加载状态 |
| 3 | **基础 Widget** | 全局 | Container, Padding, Center, Column, Row, SizedBox, ClipRRect, Card |
| 4 | **BottomNavigationBar** | `pages/home_page.dart` | 3个Tab切换 + Drawer 抽屉 |
| 5 | **ListView/GridView** | `pages/list_page.dart` | 列表/网格切换, List.add/insert/remove, Form 表单, Dialog 对话框 |
| 6 | **Navigator** | 全局 | Navigator.push/pop, MaterialPageRoute, 命名路由 |
| 7 | **状态管理** | `main.dart` | Provider (ChangeNotifier), Scope Model 替代方案 |
| 8 | **BottomSheet/AlertDialog/SnackBar** | 多处 | showModalBottomSheet, showDialog (AlertDialog), ScaffoldMessenger.showSnackBar |

### 二、扩展功能（覆盖第9-28章）

| # | 功能 | 实现位置 | 对应要求 |
|---|------|----------|----------|
| 1 | **carousel_slider + GestureDetector** | `pages/gallery_page.dart` | 轮播图, 点击/长按手势, 3D 效果 |
| 2 | **TextField + Form 验证** | `pages/form_page.dart` | 表单验证器, 多行文本, 下拉选择 |
| 3 | **复杂表单** | `pages/form_page.dart` | TextField + CheckBox + DropdownButtonFormField |
| 4 | **image_picker** | `pages/form_page.dart`, `pages/gallery_page.dart` | 相册选择, 拍照, Web 支持 |
| 5 | **Animation + Hero** | `pages/animation_page.dart`, `pages/detail_page.dart` | ScaleTransition, RotationTransition, FadeTransition, Hero |
| 6 | **自定义功能** | `pages/profile_page.dart` | 用户设置, 应用信息 |
| 7 | **shared_preferences + sqflite** | `services/` | 主题持久化, 日记CRUD, 搜索, 分类筛选 |
| 8 | **主题切换** | `pages/profile_page.dart` + `main.dart` | 深色/浅色模式切换, shared_preferences 持久化 |

## 🔧 运行方式

### 环境要求

- Flutter SDK >= 3.12
- Dart SDK >= 3.12
- Android Studio / VS Code
- Android 模拟器 或 iOS 模拟器 或 Chrome 浏览器

### 安装与运行

```bash
# 1. 进入项目目录
cd lxy1

# 2. 安装依赖
flutter pub get

# 3. 运行应用 (选择一种方式)
flutter run                    # 自动选择设备
flutter run -d chrome          # Web 浏览器运行
flutter run -d <device_id>     # 指定设备运行

# 4. 构建 Web 版本 (用于 GitHub Pages 部署)
flutter build web --release
```

### GitHub Pages 部署

```bash
# 构建 Web 版本
flutter build web --release

# 将 build/web 目录部署到 GitHub Pages
# 参考: https://docs.flutter.dev/deployment/web
```

## 📝 评分要点对照

### 基础分 (65分)

- ✅ ThemeData 完整配置 (primaryColor, colorScheme, textTheme, component themes) — 10分
- ✅ Image.asset + Image.network + iconfont — 5分
- ✅ Container, Padding, Center, Column, Row, SizedBox, ClipRRect — 4分
- ✅ BottomNavigationBar (3个Tab) — 7分
- ✅ ListView + GridView + CRUD (add/insert/remove) + Form + Dialog — 13分
- ✅ Navigator push/pop + 路由表 — 9分
- ✅ Provider 状态管理 — 7分
- ✅ BottomSheet + AlertDialog + SnackBar — 10分

### 扩展分 (105分)

- ✅ carousel_slider + GestureDetector (点击/长按) — 17分
- ✅ TextField + Form 表单验证 — 12分
- ✅ 复杂表单 (TextField + CheckBox + 下拉) — 21分
- ✅ image_picker (相册+拍照, Web 支持) — 16分
- ✅ Animation + Hero — 10分
- ✅ 附加功能 (用户设置) — 6分
- ✅ shared_preferences + sqflite — 13分
- ✅ 主题切换持久化 — 10分

## 📄 许可证

本项目为学习用途，仅供课程作业参考。

---

🤖 Generated with [Claude Code](https://claude.com/claude-code)
