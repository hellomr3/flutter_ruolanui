# RuolanUI

Flutter 版本自用 UI 库，提供常用的通用组件。

## 组件列表

### 按钮组件
- `PrimaryBtn` - 主要按钮
- `NormalBtn` - 普通按钮
- `TextBtn` - 文本按钮
- `ErrorBtn` - 错误按钮
- `BlockBtn` - 列表块按钮，支持前置图标、副标题、尾部箭头和分割线
- `BaseBtn` - 基础按钮，可自定义背景色和文本色，其他按钮的底层实现

### 输入组件
- `AppTextField` - 通用输入框
- `ClearInputTextField` - 带清除功能的输入框
- `ObservableTextController` - 响应式文本控制器

### 标签组件
- `TextTag` - 文本标签，支持选中/未选中状态切换，背景、文本样式、圆角均可配置
- `TextTagGroup` - 标签组，支持单选和多选模式

### 容器组件
- `KeyboardDismiss` - 点击空白处关闭键盘
- `SwipeBackListener` - 自定义侧滑返回监听器，iOS 端手势判定 + Android 端物理返回键拦截

### 网格组件
- `ActionGrid` - 操作网格，以宫格形式展示图标+文字的操作入口，支持自定义列数和间距

### 选择器组件
- **[TwoPaneSelector](lib/src/dialog/two_pane_selector/README.md)** - 通用的双栏选择器
  - 支持单选/多选模式
  - 支持扁平结构和嵌套结构数据
  - 内置父子联动选择逻辑

### 对话框组件
- `ConfirmDialog` / `showConfirmDialog` - 确认对话框
- `OptionsDialog` / `showOptionsDialog` / `showSampleOptionsDialog` - 选项对话框
- `showBottomInputDialog` - 底部输入对话框，弹出时自动拉起键盘
- `WrapOptionsDialog` / `showWrapOptionsDialog` - Wrap 换行布局选项弹窗，支持泛型数据和自定义 Item
- `showTextWrapOptionsDialog` - 纯文本标签选项弹窗（基于 TextTag）
- `showIconTextWrapOptionsDialog` - 图标+文本选项弹窗（基于 IconTextOption）
- `AdaptiveDialogPage` - 自适应对话框页面，适用于 Navigator 2.0 路由

### 日期与时间选择器
- `showRLCalendarPicker` / `CalendarPickerWidget` - 日历选择器，支持快捷时间段选项、日期范围限制、日历/滚轮双模式切换
- `showRLDatePicker` / `DatePickerWidget` - 日期滚轮选择器，支持年月 / 年月日模式
- `showTimePicker24` / `TimePickerWidget` - 24 小时制时间选择器，支持时分 / 时分秒模式

### 其他组件
- `CommonAppBar` - 通用应用栏
- `ConditionalBuilder` - 条件构建器
- `BottomSheetHeader` - 底部弹窗通用头部栏（取消/标题/确定）
- **[MultilineTextEditorPage](lib/src/widgets/multiline_text_editor_page/README.md)** - 多行文本编辑器
  - 支持有序列表（1、2、3、）和无序列表（●）
  - 自动延续序号和智能重算
  - 字数统计和清空功能

### 核心工具

#### Result 类型
- `Result<T>` - 统一的结果封装，区分成功/失败，支持链式调用 `onSuccess` / `onError` / `map`

#### 事件驱动
- `EventStateMixin` - 混入到 Store/ViewModel，提供 `emitEvent` 发送事件
- `EventHandlerMixin` - 混入到 State，自动监听并处理事件流
- `UiEventBus` - 轻量级事件总线，基于 `StreamController.broadcast`

#### Mixin
- `AutoDisposeMixin` - 自动资源清理，支持 `autoDispose`（ChangeNotifier）和 `autoCancel`（StreamSubscription）

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

// 使用列表块按钮
BlockBtn(
  title: "个人信息",
  hint: "点击查看详情",
  leading: Icons.person,
  onTap: () {},
)

// 使用标签组
TextTagGroup(
  labels: ["标签1", "标签2", "标签3"],
  selectedIndices: {0},
  onChanged: (indices) {},
)

// 使用日历选择器
final result = await showRLCalendarPicker(context);
result?.onSuccess((date) {
  print("选中日期: $date");
});

// 使用时间选择器
final timeResult = await showTimePicker24(context);
timeResult?.onSuccess((time) {
  print("选中时间: $time");
});

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

// 使用 Wrap 选项弹窗
final selected = await showTextWrapOptionsDialog(
  context: context,
  title: "选择标签",
  options: ["选项A", "选项B", "选项C"],
  multiSelect: true,
);
```

## 文档

- [双栏选择器使用文档](lib/src/dialog/two_pane_selector/README.md)
- [多行文本编辑器使用文档](lib/src/widgets/multiline_text_editor_page/README.md)

## Claude Code Skills

本项目内置了 Claude Code Skill，帮助依赖方在使用 AI 辅助编码时正确使用 ruolanui 组件。

### 包含的 Skill

| Skill | 说明 |
|-------|------|
| `ruolanui` | 完整使用规范：按钮、输入框、标签、网格、导航栏、对话框、选择器、日期/时间/日历选择器、多行编辑器、事件驱动模式、Result 类型、AutoDisposeMixin、页面模板 |

### 如何使用

在你的项目 `CLAUDE.md` 中添加以下 import：

**Path 依赖方式：**

```markdown
@../ruolanui/.claude/skills/ruolanui/SKILL.md
```

**Git 依赖方式：**

```markdown
@~/.pub-cache/git/ruolanui*/.claude/skills/ruolanui/SKILL.md
```

## 许可证

[LICENSE](LICENSE)
