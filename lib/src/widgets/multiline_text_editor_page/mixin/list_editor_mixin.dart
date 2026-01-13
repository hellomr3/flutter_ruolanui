import 'dart:developer' as developer;

import 'package:flutter/material.dart';

/// 列表编辑器调试日志标识
const _kListEditorDebugTag = '[ListEditor]';

/// 有序列表正则：匹配 "1、" "2、" 等格式（仅行首）
final _orderedPattern = RegExp(r'^([0-9０-９]+)、');

/// 无序列表正则：匹配 "● " 格式（带空格，仅行首）
final _unorderedPattern = RegExp(r'^● ');

/// 行信息（mixin 内部使用）
class _ListLineInfo {
  final int lineStart;
  final int lineEnd;
  final String lineContent;

  _ListLineInfo({
    required this.lineStart,
    required this.lineEnd,
    required this.lineContent,
  });
}

/// 列表编辑器 Mixin
///
/// 为 TextField 提供有序列表（1、2、3、）和无序列表（●）功能。
///
/// 使用方式：
/// ```dart
/// class _MyWidgetState extends State<MyWidget> with ListEditorMixin {
///   late TextEditingController _controller;
///
///   @override
///   TextEditingController get listController => _controller;
///
///   @override
///   void onListStateChanged(bool isOrdered, bool isUnordered) {
///     // 通知外部更新工具栏状态
///     setState(() {});
///   }
///
///   @override
///   void initState() {
///     super.initState();
///     _controller = TextEditingController();
///     initListEditor();
///   }
///
///   @override
///   void dispose() {
///     disposeListEditor();
///     _controller.dispose();
///     super.dispose();
///   }
/// }
/// ```
mixin ListEditorMixin<T extends StatefulWidget> on State<T> {
  // ============ 子类必须实现 ============

  /// 子类必须实现：提供要操作的 TextEditingController
  TextEditingController get listController;

  // ============ 子类可覆盖 ============

  /// 子类可覆盖：列表状态变化时调用（默认空实现）
  ///
  /// [isOrdered] 当前行是否是有序列表
  /// [isUnordered] 当前行是否是无序列表
  void onListStateChanged(bool isOrdered, bool isUnordered) {}

  // ============ 内部状态 ============

  String _listPreviousText = '';
  bool _wasSelectAll = false;

  // ============ 对外 getter ============

  /// 当前行是否是有序列表
  bool get isCurrentLineOrdered {
    final lineInfo = _getCurrentLineInfo();
    return _orderedPattern.hasMatch(lineInfo.lineContent);
  }

  /// 当前行是否是无序列表
  bool get isCurrentLineUnordered {
    final lineInfo = _getCurrentLineInfo();
    return _unorderedPattern.hasMatch(lineInfo.lineContent);
  }

  // ============ 生命周期 ============

  /// 初始化列表编辑器，需要在 initState 中调用
  void initListEditor() {
    _listPreviousText = listController.text;
    _wasSelectAll = false;
    listController.addListener(_onListSelectionChanged);
    // 初始状态同步
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        onListStateChanged(isCurrentLineOrdered, isCurrentLineUnordered);
      }
    });
  }

  /// 清理列表编辑器，需要在 dispose 中调用
  void disposeListEditor() {
    listController.removeListener(_onListSelectionChanged);
  }

  /// 更新 previousText（用于外部设置文本时同步）
  void updateListPreviousText(String text) {
    _listPreviousText = text;
  }

  // ============ 对外方法 ============

  /// 切换有序列表
  void toggleOrderedList() {
    _toggleList(isOrdered: true);
  }

  /// 切换无序列表
  void toggleUnorderedList() {
    _toggleList(isOrdered: false);
  }

  /// 处理文本变化（需要接入 TextField 的 onChanged）
  ///
  /// 返回处理后的文本
  String handleListTextChanged(String newText) {
    // 统一换行符：将 CRLF (\r\n) 转换为 LF (\n)
    if (newText.contains('\r\n')) {
      newText = newText.replaceAll('\r\n', '\n');
      listController.text = newText;
      final cursorPos = listController.selection.baseOffset;
      if (cursorPos > newText.length) {
        listController.selection =
            TextSelection.collapsed(offset: newText.length);
      }
    }

    // 检测是否是换行操作
    if (_isNewlineInserted(newText)) {
      return _handleNewline(newText);
    } else if (_isBackspaceAtPrefixEnd(newText)) {
      // 检测是否在序号后面删除（整体删除序号）
      return _handlePrefixBackspace();
    } else if (_isBackspaceAtLineStart(newText)) {
      // 检测是否在行首删除（可能需要重算序号）
      return _handleBackspace(newText);
    } else {
      _listPreviousText = newText;
      return newText;
    }
  }

  // ============ 内部方法 ============

  /// 选区变化时通知状态
  void _onListSelectionChanged() {
    // 记录是否为全选状态
    final selection = listController.selection;
    final text = listController.text;
    if (selection.isValid && text.isNotEmpty) {
      final isSelectAll = selection.start == 0 && selection.end == text.length;
      _wasSelectAll = isSelectAll;
      if (isSelectAll) {
        developer.log(
          '$_kListEditorDebugTag 检测到全选, '
          'textLen=${text.length}, selection=(${selection.start}, ${selection.end})',
        );
      }
    }

    // 延迟调用回调，避免在 build 过程中触发 setState
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        onListStateChanged(isCurrentLineOrdered, isCurrentLineUnordered);
      }
    });
  }

  /// 切换列表格式
  void _toggleList({required bool isOrdered}) {
    final currentText = listController.text;
    if (currentText.isEmpty) return;

    // 优先使用当前选区
    TextSelection selection = listController.selection;

    // iOS 特殊处理：如果之前记录了全选状态，优先使用全选
    if (_wasSelectAll) {
      selection = TextSelection(
        baseOffset: 0,
        extentOffset: currentText.length,
      );
      listController.selection = selection;
    } else if (!selection.isValid || selection.baseOffset < 0) {
      return;
    }

    // 获取选中的文本，判断是否跨行
    final selectedText = selection.isCollapsed
        ? ''
        : currentText.substring(selection.start, selection.end);
    final isMultiLine = selectedText.contains('\n');

    // 判断是单行还是多行操作
    if (selection.isCollapsed || !isMultiLine) {
      _toggleSingleLine(isOrdered: isOrdered);
    } else {
      _toggleMultiLine(isOrdered: isOrdered);
    }
  }

  /// 单行列表切换
  void _toggleSingleLine({required bool isOrdered}) {
    try {
      final text = listController.text;
      final selection = listController.selection;

      // 边界检查
      if (text.isEmpty) return;
      if (!selection.isValid ||
          selection.baseOffset < 0 ||
          selection.baseOffset > text.length) {
        return;
      }

      final lineInfo = _getCurrentLineInfo();
      final lineStart = lineInfo.lineStart;
      final lineContent = lineInfo.lineContent;

      // 边界检查
      if (lineStart < 0 || lineStart > text.length) return;

      String newText;
      int newCursorOffset;

      if (isOrdered) {
        // 切换有序列表
        if (_orderedPattern.hasMatch(lineContent)) {
          // 已经是有序列表，移除序号
          final match = _orderedPattern.firstMatch(lineContent)!;
          newText = text.replaceRange(lineStart, lineStart + match.end, '');
          newCursorOffset = selection.baseOffset - match.end;
        } else if (_unorderedPattern.hasMatch(lineContent)) {
          // 是无序列表，替换为有序列表
          final nextNumber = _getNextOrderedNumber(lineStart);
          final prefix = '$nextNumber、';
          newText = text.replaceRange(lineStart, lineStart + 2, prefix);
          newCursorOffset = selection.baseOffset + prefix.length - 2;
        } else {
          // 普通文本，添加有序序号
          final nextNumber = _getNextOrderedNumber(lineStart);
          final prefix = '$nextNumber、';
          newText = text.replaceRange(lineStart, lineStart, prefix);
          newCursorOffset = selection.baseOffset + prefix.length;
        }
      } else {
        // 切换无序列表
        if (_unorderedPattern.hasMatch(lineContent)) {
          // 已经是无序列表，移除序号
          newText = text.replaceRange(lineStart, lineStart + 2, '');
          newCursorOffset = selection.baseOffset - 2;
        } else if (_orderedPattern.hasMatch(lineContent)) {
          // 是有序列表，替换为无序列表
          final match = _orderedPattern.firstMatch(lineContent)!;
          newText = text.replaceRange(lineStart, lineStart + match.end, '● ');
          newCursorOffset = selection.baseOffset - match.end + 2;
        } else {
          // 普通文本，添加无序序号
          newText = text.replaceRange(lineStart, lineStart, '● ');
          newCursorOffset = selection.baseOffset + 2;
        }
      }

      // 更新文本和光标位置
      listController.text = newText;
      listController.selection = TextSelection.collapsed(
        offset: newCursorOffset.clamp(0, newText.length),
      );
      _listPreviousText = newText;

      // 如果是有序列表操作，需要重算后续序号
      if (isOrdered || _orderedPattern.hasMatch(lineContent)) {
        _recalculateOrderedNumbers();
      }

      // 重置全选标志
      _wasSelectAll = false;
      _onListSelectionChanged();
    } catch (e, stack) {
      debugPrint('$_kListEditorDebugTag _toggleSingleLine 异常: $e\n$stack');
    }
  }

  /// 多行列表切换
  void _toggleMultiLine({required bool isOrdered}) {
    try {
      final text = listController.text;
      final selection = listController.selection;

      // 边界检查
      if (text.isEmpty) return;
      if (!selection.isValid) return;

      // 获取选中范围内的所有行
      final startPos = selection.start.clamp(0, text.length);
      final endPos = selection.end.clamp(0, text.length);

      if (startPos > endPos) return;

      // 找到第一行的起始位置
      int firstLineStart;
      if (startPos == 0) {
        firstLineStart = 0;
      } else {
        firstLineStart = text.lastIndexOf('\n', startPos - 1);
        firstLineStart = firstLineStart == -1 ? 0 : firstLineStart + 1;
      }

      // 找到最后一行的结束位置
      int lastLineEnd = text.indexOf('\n', endPos);
      lastLineEnd = lastLineEnd == -1 ? text.length : lastLineEnd;

      // 边界检查
      if (firstLineStart < 0 ||
          lastLineEnd > text.length ||
          firstLineStart > lastLineEnd) {
        return;
      }

      // 获取选中区域的文本
      final selectedText = text.substring(firstLineStart, lastLineEnd);
      final lines = selectedText.split('\n');

      if (lines.isEmpty) return;

      // 判断是否所有行都已经是目标格式
      final allHaveFormat = lines.every((line) {
        if (isOrdered) {
          return _orderedPattern.hasMatch(line);
        } else {
          return _unorderedPattern.hasMatch(line);
        }
      });

      // 获取起始序号
      final int startNumber = _getNextOrderedNumber(firstLineStart);

      // 处理每一行
      final newLines = <String>[];
      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];

        if (allHaveFormat) {
          // 所有行都有格式，移除格式
          if (isOrdered) {
            newLines.add(line.replaceFirst(_orderedPattern, ''));
          } else {
            newLines.add(line.replaceFirst(_unorderedPattern, ''));
          }
        } else {
          // 添加或替换格式
          String newLine;
          if (isOrdered) {
            newLine = line
                .replaceFirst(_orderedPattern, '')
                .replaceFirst(_unorderedPattern, '');
            newLine = '${startNumber + i}、$newLine';
          } else {
            newLine = line
                .replaceFirst(_orderedPattern, '')
                .replaceFirst(_unorderedPattern, '');
            newLine = '● $newLine';
          }
          newLines.add(newLine);
        }
      }

      // 构建新文本
      final newSelectedText = newLines.join('\n');
      final newText =
          text.replaceRange(firstLineStart, lastLineEnd, newSelectedText);

      // 计算新的选中范围
      final lengthDiff = newSelectedText.length - selectedText.length;
      final newEndPos = endPos + lengthDiff;

      // 更新文本和选中范围
      listController.text = newText;
      listController.selection = TextSelection(
        baseOffset: firstLineStart,
        extentOffset: newEndPos.clamp(0, newText.length),
      );
      _listPreviousText = newText;

      // 重算有序序号
      _recalculateOrderedNumbers();

      // 重置全选标志
      _wasSelectAll = false;
      _onListSelectionChanged();
    } catch (e, stack) {
      debugPrint('$_kListEditorDebugTag _toggleMultiLine 异常: $e\n$stack');
    }
  }

  /// 获取当前行信息
  _ListLineInfo _getCurrentLineInfo() {
    final text = listController.text;

    // 边界检查：空文本返回空行信息
    if (text.isEmpty) {
      return _ListLineInfo(lineStart: 0, lineEnd: 0, lineContent: '');
    }

    final cursorPos = listController.selection.baseOffset.clamp(0, text.length);

    // 找到当前行的起始位置
    int lineStart;
    if (cursorPos == 0) {
      lineStart = 0;
    } else {
      lineStart = text.lastIndexOf('\n', cursorPos - 1);
      lineStart = lineStart == -1 ? 0 : lineStart + 1;
    }

    // 找到当前行的结束位置
    int lineEnd = text.indexOf('\n', cursorPos);
    lineEnd = lineEnd == -1 ? text.length : lineEnd;

    // 边界检查
    lineStart = lineStart.clamp(0, text.length);
    lineEnd = lineEnd.clamp(lineStart, text.length);

    final lineContent = text.substring(lineStart, lineEnd);
    return _ListLineInfo(
        lineStart: lineStart, lineEnd: lineEnd, lineContent: lineContent);
  }

  /// 获取下一个有序序号（基于上一行）
  int _getNextOrderedNumber(int currentLineStart) {
    try {
      if (currentLineStart <= 0) return 1;

      final text = listController.text;
      if (text.isEmpty) return 1;

      // 找到上一行
      final int prevLineEnd = currentLineStart - 1;
      if (prevLineEnd < 0 || prevLineEnd >= text.length) return 1;

      int prevLineStart = text.lastIndexOf('\n', prevLineEnd - 1);
      prevLineStart = prevLineStart == -1 ? 0 : prevLineStart + 1;

      // 边界检查
      if (prevLineStart < 0 || prevLineStart > prevLineEnd) return 1;

      final prevLineContent = text.substring(prevLineStart, prevLineEnd);
      final match = _orderedPattern.firstMatch(prevLineContent);
      if (match != null) {
        final numberStr = match.group(1)!;
        return _parseNumber(numberStr) + 1;
      }
      return 1;
    } catch (e, stack) {
      debugPrint('$_kListEditorDebugTag _getNextOrderedNumber 异常: $e\n$stack');
      return 1;
    }
  }

  /// 解析数字字符串，支持半角和全角数字
  ///
  /// 将全角数字（０-９）转换为半角数字（0-9）后解析
  int _parseNumber(String numberStr) {
    final buffer = StringBuffer();
    for (final char in numberStr.runes) {
      if (char >= 0xFF10 && char <= 0xFF19) {
        // 全角数字 ０-９ (U+FF10 - U+FF19) 转换为半角
        buffer.writeCharCode(char - 0xFF10 + 0x30);
      } else {
        buffer.writeCharCode(char);
      }
    }
    return int.parse(buffer.toString());
  }

  /// 检测是否在行首序号后面删除
  bool _isBackspaceAtPrefixEnd(String newText) {
    // 必须是删除操作
    if (newText.length >= _listPreviousText.length) return false;

    final deletedCount = _listPreviousText.length - newText.length;
    if (deletedCount != 1) return false;

    // 找到删除位置
    int deletePos = 0;
    for (int i = 0; i < newText.length; i++) {
      if (i >= _listPreviousText.length || newText[i] != _listPreviousText[i]) {
        deletePos = i;
        break;
      }
      deletePos = i + 1;
    }

    // 边界检查
    if (deletePos == 0) return false;

    // 获取删除前该位置所在行的起始位置
    final lineStart = _listPreviousText.lastIndexOf('\n', deletePos - 1);
    final actualLineStart = lineStart == -1 ? 0 : lineStart + 1;

    // 获取行内容
    final lineEndIndex = _listPreviousText.indexOf('\n', actualLineStart);
    final lineContent = _listPreviousText.substring(
      actualLineStart,
      lineEndIndex == -1 ? _listPreviousText.length : lineEndIndex,
    );

    // 检查是否是有序列表行
    final orderedMatch = _orderedPattern.firstMatch(lineContent);
    if (orderedMatch != null) {
      final prefixEndInText = actualLineStart + orderedMatch.end;
      if (deletePos == prefixEndInText - 1) {
        return true;
      }
    }

    // 检查是否是无序列表行
    if (_unorderedPattern.hasMatch(lineContent)) {
      final prefixEndInText = actualLineStart + 2;
      if (deletePos == prefixEndInText - 1) {
        return true;
      }
    }

    return false;
  }

  /// 处理序号后面的删除：整体删除序号
  String _handlePrefixBackspace() {
    try {
      final text = _listPreviousText;
      final cursorPos = listController.selection.baseOffset;

      // 边界检查
      if (cursorPos <= 0 || cursorPos > text.length) return text;
      if (text.isEmpty) return text;

      // 获取当前行信息
      final lineStart = text.lastIndexOf('\n', cursorPos - 1);
      final actualLineStart = lineStart == -1 ? 0 : lineStart + 1;
      final lineEnd = text.indexOf('\n', cursorPos);
      final actualLineEnd = lineEnd == -1 ? text.length : lineEnd;

      // 边界检查
      if (actualLineStart < 0 ||
          actualLineEnd > text.length ||
          actualLineStart > actualLineEnd) {
        return text;
      }

      final lineContent = text.substring(actualLineStart, actualLineEnd);

      // 确定要删除的序号长度
      int prefixLength = 0;
      final orderedMatch = _orderedPattern.firstMatch(lineContent);
      if (orderedMatch != null) {
        prefixLength = orderedMatch.end;
      } else if (_unorderedPattern.hasMatch(lineContent)) {
        prefixLength = 2;
      }

      if (prefixLength > 0 && actualLineStart + prefixLength <= text.length) {
        // 删除整个序号
        final newText =
            text.replaceRange(actualLineStart, actualLineStart + prefixLength, '');
        listController.text = newText;
        listController.selection = TextSelection.collapsed(
            offset: actualLineStart.clamp(0, newText.length));
        _listPreviousText = newText;

        // 重算有序序号
        _recalculateOrderedNumbers();
        _onListSelectionChanged();
        return listController.text;
      }
      return text;
    } catch (e, stack) {
      debugPrint('$_kListEditorDebugTag _handlePrefixBackspace 异常: $e\n$stack');
      return _listPreviousText;
    }
  }

  /// 检测是否插入了换行符
  bool _isNewlineInserted(String newText) {
    return newText.length == _listPreviousText.length + 1 &&
        newText.contains('\n') &&
        (newText.split('\n').length > _listPreviousText.split('\n').length);
  }

  /// 检测是否在行首删除
  bool _isBackspaceAtLineStart(String newText) {
    return newText.length < _listPreviousText.length &&
        _listPreviousText.split('\n').length > newText.split('\n').length;
  }

  /// 处理换行：自动延续序号
  String _handleNewline(String newText) {
    try {
      final cursorPos = listController.selection.baseOffset;

      // 边界检查
      if (newText.isEmpty || cursorPos < 0 || cursorPos > newText.length) {
        _listPreviousText = newText;
        return newText;
      }

      final newLineStart = cursorPos;

      // 边界检查
      if (newLineStart < 2) {
        _listPreviousText = newText;
        return newText;
      }

      // 找到上一行的内容
      int prevLineStart = newText.lastIndexOf('\n', newLineStart - 2);
      prevLineStart = prevLineStart == -1 ? 0 : prevLineStart + 1;
      final int prevLineEnd = newLineStart - 1;

      // 边界检查
      if (prevLineStart < 0 ||
          prevLineEnd < 0 ||
          prevLineStart > prevLineEnd ||
          prevLineEnd > newText.length) {
        _listPreviousText = newText;
        return newText;
      }

      final prevLineContent = newText.substring(prevLineStart, prevLineEnd);

      String? prefixToInsert;

      // 检查上一行是否是有序列表
      final orderedMatch = _orderedPattern.firstMatch(prevLineContent);
      if (orderedMatch != null) {
        final contentAfterPrefix = prevLineContent.substring(orderedMatch.end);
        if (contentAfterPrefix.trim().isEmpty) {
          // 上一行只有序号，移除序号并不延续
          final updatedText =
              newText.replaceRange(prevLineStart, prevLineEnd + 1, '');
          listController.text = updatedText;
          listController.selection = TextSelection.collapsed(
              offset: prevLineStart.clamp(0, updatedText.length));
          _listPreviousText = updatedText;
          return updatedText;
        }
        final nextNumber = int.parse(orderedMatch.group(1)!) + 1;
        prefixToInsert = '$nextNumber、';
      }

      // 检查上一行是否是无序列表
      if (prefixToInsert == null &&
          _unorderedPattern.hasMatch(prevLineContent)) {
        if (prevLineContent.length >= 2) {
          final contentAfterPrefix = prevLineContent.substring(2);
          if (contentAfterPrefix.trim().isEmpty) {
            // 上一行只有序号，移除序号并不延续
            final updatedText =
                newText.replaceRange(prevLineStart, prevLineEnd + 1, '');
            listController.text = updatedText;
            listController.selection = TextSelection.collapsed(
                offset: prevLineStart.clamp(0, updatedText.length));
            _listPreviousText = updatedText;
            return updatedText;
          }
        }
        prefixToInsert = '● ';
      }

      if (prefixToInsert != null && newLineStart <= newText.length) {
        // 在新行插入序号
        final updatedText =
            newText.replaceRange(newLineStart, newLineStart, prefixToInsert);
        listController.text = updatedText;
        listController.selection = TextSelection.collapsed(
          offset: (newLineStart + prefixToInsert.length).clamp(0, updatedText.length),
        );
        _listPreviousText = updatedText;
        return updatedText;
      } else {
        _listPreviousText = newText;
        return newText;
      }
    } catch (e, stack) {
      debugPrint('$_kListEditorDebugTag _handleNewline 异常: $e\n$stack');
      _listPreviousText = newText;
      return newText;
    }
  }

  /// 处理删除：重算序号
  String _handleBackspace(String newText) {
    _listPreviousText = newText;
    listController.text = newText;
    _recalculateOrderedNumbers();
    return listController.text;
  }

  /// 重新计算所有有序列表的序号
  void _recalculateOrderedNumbers() {
    try {
      final text = listController.text;
      if (text.isEmpty) return;

      final lines = text.split('\n');
      final cursorPos =
          listController.selection.baseOffset.clamp(0, text.length);

      int currentNumber = 0;
      bool inOrderedList = false;
      final newLines = <String>[];
      int cursorOffset = 0;
      int processedLength = 0;

      for (int i = 0; i < lines.length; i++) {
        final line = lines[i];
        final orderedMatch = _orderedPattern.firstMatch(line);

        if (orderedMatch != null) {
          if (!inOrderedList) {
            currentNumber = 1;
            inOrderedList = true;
          } else {
            currentNumber++;
          }

          final oldPrefix = orderedMatch.group(0)!;
          final newPrefix = '$currentNumber、';
          final newLine = line.replaceFirst(_orderedPattern, newPrefix);
          newLines.add(newLine);

          // 调整光标位置
          if (cursorPos > processedLength &&
              cursorPos <= processedLength + line.length) {
            cursorOffset += newPrefix.length - oldPrefix.length;
          }
        } else {
          if (!_unorderedPattern.hasMatch(line)) {
            inOrderedList = false;
            currentNumber = 0;
          }
          newLines.add(line);
        }

        processedLength += line.length + 1;
      }

      final newText = newLines.join('\n');
      if (newText != text) {
        listController.text = newText;
        listController.selection = TextSelection.collapsed(
          offset: (cursorPos + cursorOffset).clamp(0, newText.length),
        );
        _listPreviousText = newText;
      }
    } catch (e, stack) {
      debugPrint('$_kListEditorDebugTag _recalculateOrderedNumbers 异常: $e\n$stack');
    }
  }
}
