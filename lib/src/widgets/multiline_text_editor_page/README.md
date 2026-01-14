# 多行文本编辑器 (MultilineTextEditorPage)

功能完整的多行文本编辑页面，支持有序列表（1、2、3、）和无序列表（●）功能，底部工具栏可切换列表模式，显示字数统计。

## 功能特性

- 支持有序列表（1、2、3、）和无序列表（●）
- 自动延续序号：换行时自动添加下一行序号
- 智能删除：在序号后删除会整体删除序号
- 序号自动重算：删除/修改时自动重新计算有序列表序号
- 字数统计：实时显示当前字数和最大字数
- 清空功能：一键清空所有内容
- 主题定制：支持完整的主题配置
- 自动弹出键盘：进入页面自动聚焦

## 目录结构

```
lib/src/widgets/multiline_text_editor_page/
├── multiline_text_editor_page.dart  # 主页面组件
├── mixin/
│   └── list_editor_mixin.dart       # 列表编辑核心逻辑
├── widget/
│   ├── list_editor_widget.dart      # 编辑器组件
│   ├── list_toolbar.dart            # 底部工具栏
│   └── word_count_indicator.dart    # 字数统计组件
└── README.md                         # 使用文档
```

## 快速开始

### 1. 导入组件

```dart
import 'package:ruolanui/ruolanui.dart';
```

### 2. 基础使用

```dart
// 跳转到编辑页面
final result = await Navigator.push<String>(
  context,
  CupertinoPageRoute(
    builder: (context) => MultilineTextEditorPage(
      title: '编辑内容',
      initialText: '这是初始内容',
      placeholder: '请输入内容...',
      maxInputCount: 500,
    ),
  ),
);

if (result != null) {
  print('用户输入的内容: $result');
}
```

### 3. 封装跳转方法

```dart
/// 封装的文本编辑跳转方法
Future<String?> openTextEdit(
  BuildContext context, {
  required String initialText,
  String title = '编辑文本',
  String? hintText,
  int maxLength = 500,
}) {
  return Navigator.push<String?>(
    context,
    CupertinoPageRoute(
      builder: (context) => MultilineTextEditorPage(
        title: title,
        initialText: initialText,
        placeholder: hintText ?? '请输入内容...',
        maxInputCount: maxLength > 0 ? maxLength : 500,
      ),
    ),
  );
}

// 使用
final editedText = await openTextEdit(
  context,
  initialText: _currentText,
  title: '编辑备注',
  hintText: '请输入备注信息',
  maxLength: 200,
);
```

## API 文档

### MultilineTextEditorPage

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `title` | `String` | `'编辑内容'` | 页面标题 |
| `subTitle` | `String?` | `null` | 副标题（显示在标题下方） |
| `placeholder` | `String` | `'请输入内容...'` | 输入框占位符 |
| `maxInputCount` | `int` | `500` | 最大输入字数 |
| `initialText` | `String` | `''` | 初始文本内容 |
| `theme` | `MultilineEditorTheme` | `defaultTheme()` | 主题配置 |

### MultilineEditorTheme

主题配置类，用于自定义编辑器样式。

| 属性 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `backgroundColor` | `Color` | `Colors.white` | 页面背景色 |
| `appBarBackgroundColor` | `Color` | `Colors.white` | AppBar 背景色 |
| `titleColor` | `Color` | `Color(0xFF424242)` | 标题颜色 |
| `subTitleColor` | `Color` | `Color(0xFF787878)` | 副标题颜色 |
| `backIconColor` | `Color` | `Color(0xFF424242)` | 返回按钮颜色 |
| `confirmButtonColor` | `Color` | `Color(0xFF0052D9)` | 确定按钮颜色 |
| `confirmButtonDisabledColor` | `Color` | `Color(0xFFBBBBBB)` | 确定按钮禁用颜色 |
| `toolbarBackgroundColor` | `Color` | `Colors.white` | 底部工具栏背景色 |
| `clearButtonColor` | `Color` | `Color(0xFF0052D9)` | 清空按钮颜色 |
| `clearButtonDisabledColor` | `Color` | `Color(0xFFBBBBBB)` | 清空按钮禁用颜色 |

### 主题定制示例

```dart
MultilineTextEditorPage(
  title: '编辑内容',
  initialText: _content,
  theme: MultilineEditorTheme(
    backgroundColor: Colors.grey[50],
    appBarBackgroundColor: Colors.blue[50],
    titleColor: Colors.blue[900],
    confirmButtonColor: Colors.blue[700],
    toolbarBackgroundColor: Colors.grey[100],
  ),
)
```

## 列表功能详解

### 有序列表（1、2、3、）

- 点击工具栏的有序列表按钮，在当前行开头添加序号
- 换行时自动延续序号：1、2、3、...
- 删除某行序号后，后续序号自动重算
- 支持全角数字（０-９）自动转换为半角

### 无序列表（●）

- 点击工具栏的无序列表按钮，在当前行开头添加 ●
- 换行时自动延续无序列表符号
- 支持与有序列表互相切换

### 列表切换逻辑

1. **单行操作**：在光标所在行切换列表格式
2. **多行操作**：选中多行文本时，批量添加/移除列表格式
3. **格式替换**：有序列表和无序列表可以互相替换
4. **智能删除**：在序号后按删除键，会整体删除序号

### 列表使用示例

```
输入内容并点击有序列表按钮：

1、第一项内容
2、第二项内容
3、第三项内容

切换为无序列表：

● 第一项内容
● 第二项内容
● 第三项内容
```

## 核心组件

### ListEditorWidget

独立的列表编辑器组件，可单独使用。

```dart
ListEditorWidget(
  text: '初始文本',
  placeholder: '请输入...',
  focusNode: _focusNode,
  maxInputCount: 500,
  enableList: true,
  onChanged: (text) {
    // 文本变化回调
  },
  onListStateChanged: (isOrdered, isUnordered) {
    // 列表状态变化回调（用于更新工具栏）
  },
  onTapOutside: (event) {
    // 点击外部区域回调
  },
)
```

### ListToolbar

列表工具栏组件，可单独使用。

```dart
ListToolbar(
  showOrdered: true,
  showUnordered: true,
  isOrderedActive: _isOrderedActive,
  isUnorderedActive: _isUnorderedActive,
  onOrderedListToggle: () {
    // 有序列表点击回调
  },
  onUnorderedListToggle: () {
    // 无序列表点击回调
  },
)
```

### WordCountIndicator

字数统计组件，可单独使用。

```dart
WordCountIndicator(
  currentLength: _text.length,
  maxLength: 500,
)
```

## 注意事项

1. **返回值**：用户点击返回或确定按钮都会返回当前文本内容
2. **空值处理**：用户取消操作（返回）会返回当前文本，不会返回 null
3. **字数限制**：达到最大字数后，系统会限制继续输入
4. **列表格式**：列表符号占用字数不计入内容统计
5. **iOS 兼容**：组件针对 iOS 的全选行为做了特殊处理
6. **换行符**：统一使用 LF (\n)，CRLF (\r\n) 会被自动转换
