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

## Claude Code Skills

本项目内置了 Claude Code Skills，帮助依赖方在使用 AI 辅助编码时正确使用 ruolanui 组件。

### 包含的 Skills（3 个）

| Skill | 说明 |
|-------|------|
| `ruolanui-components` | 按钮、输入框、导航栏、工具组件的使用方式和参数 |
| `ruolanui-dialogs` | 对话框、选择器、日期/时间/日历选择器、多行编辑器 |
| `ruolanui-patterns` | 事件驱动模式（EventStateMixin + EventHandlerMixin）、Result 类型、AutoDisposeMixin、页面模板 |

### 如何使用

在你的项目 `CLAUDE.md` 中添加以下 import：

**Path 依赖方式：**

```markdown
@../ruolanui/.claude/skills/ruolanui-components/SKILL.md
@../ruolanui/.claude/skills/ruolanui-dialogs/SKILL.md
@../ruolanui/.claude/skills/ruolanui-patterns/SKILL.md
```

**Git 依赖方式：**

```markdown
@~/.pub-cache/git/ruolanui*/.claude/skills/ruolanui-components/SKILL.md
@~/.pub-cache/git/ruolanui*/.claude/skills/ruolanui-dialogs/SKILL.md
@~/.pub-cache/git/ruolanui*/.claude/skills/ruolanui-patterns/SKILL.md
```

> 也可只 import 需要的 skill，不必全部引入。

## 许可证

[LICENSE](LICENSE)
