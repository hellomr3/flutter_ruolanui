# RuolanUI

Flutter 版本自用 UI 库，提供常用的通用组件。

## 组件列表

### 按钮组件
- `PrimaryBtn` - 主要按钮
- `NormalBtn` - 普通按钮
- `TextBtn` - 文本按钮
- `ErrorBtn` - 错误按钮

### 输入组件
- `AppTextField` - 通用输入框
- `ClearInputTextField` - 带清除功能的输入框
- `ObservableTextController` - 响应式文本控制器

### 容器组件
- `KeyboardDismiss` - 点击空白处关闭键盘

### 选择器组件
- **[TwoPaneSelector](lib/src/dialog/two_pane_selector/README.md)** - 通用的双栏选择器
  - 支持单选/多选模式
  - 支持扁平结构和嵌套结构数据
  - 内置父子联动选择逻辑

### 对话框组件
- `ConfirmDialog` - 确认对话框
- `OptionsDialog` - 选项对话框
- `InputDialog` - 输入对话框

### 其他组件
- `CommonAppBar` - 通用应用栏
- `ConditionalBuilder` - 条件构建器
- **[MultilineTextEditorPage](lib/src/widgets/multiline_text_editor_page/README.md)** - 多行文本编辑器
  - 支持有序列表（1、2、3、）和无序列表（●）
  - 自动延续序号和智能重算
  - 字数统计和清空功能

## 安装

在 `pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  ruolanui:
    path: ../ruolanui
```

## 快速开始

```dart
import 'package:ruolanui/ruolanui.dart';

// 使用按钮
PrimaryBtn(
  label: "确定",
  onPressed: () {},
)

// 使用选择器
TwoPaneSelector<MyEntity, String>(
  title: "选择项目",
  idExtractor: (entity) => entity.id,
  parentIdExtractor: (entity) => entity.parentId,
  mode: SelectorMode.multiple,
  items: entities,
  parentItemBuilder: _buildParentItem,
  childItemBuilder: _buildChildItem,
  selectedItemBuilder: _buildSelectedItem,
  onConfirm: (selectedItems) {
    // 处理选中项目
  },
)
```

## 文档

- [双栏选择器使用文档](lib/src/dialog/two_pane_selector/README.md)
- [多行文本编辑器使用文档](lib/src/widgets/multiline_text_editor_page/README.md)

## 开发

```bash
# 运行示例
flutter run

# 运行测试
flutter test

# 代码生成
flutter pub run build_runner build
```

## 许可证

[LICENSE](LICENSE)
