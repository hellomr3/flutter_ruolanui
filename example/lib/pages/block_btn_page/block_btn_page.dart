import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

class BlockBtnPage extends StatelessWidget {
  const BlockBtnPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'BlockBtn 组件测试'),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        children: [
          _section('基础用法'),
          BlockBtn(
            title: '仅标题',
            onTap: () => _showToast(context, '点击了仅标题'),
          ),
          BlockBtn(
            title: '标题 + 提示',
            hint: '这是提示文字',
            onTap: () => _showToast(context, '点击了标题+提示'),
          ),
          BlockBtn(
            title: '不可点击（无 onTap）',
            arrow: false,
          ),
          _section('前置图标'),
          BlockBtn(
            title: 'leading 图标',
            leading: Icons.settings,
            onTap: () => _showToast(context, '设置'),
          ),
          BlockBtn(
            title: 'leadingWidget 自定义',
            leadingWidget: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: const Text('A', style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
            onTap: () => _showToast(context, '自定义前置'),
          ),
          _section('后置组件'),
          BlockBtn(
            title: '自定义 trailing',
            trailing: Text('已开启', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 13)),
            onTap: () => _showToast(context, 'trailing'),
          ),
          BlockBtn(
            title: 'trailing + 隐藏箭头',
            arrow: false,
            trailing: const Icon(Icons.check_circle, color: Colors.green, size: 20),
            onTap: () => _showToast(context, '隐藏箭头'),
          ),
          BlockBtn(
            title: 'trailing 文字超长',
            trailing: Text(
              '这是一段非常非常非常长的右侧文字用来测试溢出截断效果',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 13),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            onTap: () => _showToast(context, '文字超长'),
          ),
          _section('禁用状态'),
          BlockBtn(
            title: '禁用状态',
            hint: 'disabled = true',
            leading: Icons.lock_outline,
            disabled: true,
            onTap: () => _showToast(context, '不会触发'),
          ),
          _section('分割线控制'),
          BlockBtn(
            title: '隐藏分割线',
            showDivider: false,
            onTap: () => _showToast(context, '无分割线'),
          ),
          BlockBtn(
            title: '自定义缩进',
            hint: 'indent: 48, endIndent: 48',
            indent: 48,
            endIndent: 48,
            onTap: () => _showToast(context, '自定义缩进'),
          ),
          _section('背景与圆角'),
          BlockBtn(
            title: '自定义背景色',
            backgroundColor: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            showDivider: false,
            onTap: () => _showToast(context, '自定义背景'),
          ),
          BlockBtn(
            title: '圆角卡片风格',
            hint: '带圆角和自定义颜色',
            backgroundColor: const Color(0xFFF3E5F5),
            borderRadius: BorderRadius.circular(16),
            showDivider: false,
            leading: Icons.card_giftcard,
            onTap: () => _showToast(context, '卡片风格'),
          ),
          _section('hint 展示位置'),
          BlockBtn(
            title: 'hint 在标题底部（默认）',
            hint: '这是底部提示文字',
            onTap: () => _showToast(context, '底部hint'),
          ),
          BlockBtn(
            title: 'hint 在右侧',
            hint: '这是右侧提示',
            hintPosition: BlockBtnHintPosition.trailing,
            onTap: () => _showToast(context, '右侧hint'),
          ),
          BlockBtn(
            title: 'hint 超长在右侧',
            hint: '这是一段非常非常非常长的右侧提示文字用来测试截断',
            hintPosition: BlockBtnHintPosition.trailing,
            onTap: () => _showToast(context, '右侧hint超长'),
          ),
          BlockBtn(
            title: '有 trailing 时忽略 hintPosition',
            hint: '这段 hint 仍在底部',
            hintPosition: BlockBtnHintPosition.trailing,
            trailing: Text('自定义', style: TextStyle(
              color: Theme.of(context).colorScheme.primary, fontSize: 13,
            )),
            onTap: () => _showToast(context, 'trailing优先'),
          ),
          _section('自定义内边距'),
          BlockBtn(
            title: '紧凑内边距',
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            onTap: () => _showToast(context, '紧凑'),
          ),
          BlockBtn(
            title: '宽松内边距',
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            onTap: () => _showToast(context, '宽松'),
          ),
          _section('组合场景'),
          // 设置列表组
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                BlockBtn(
                  title: '账户与安全',
                  leading: Icons.security,
                  onTap: () => _showToast(context, '账户与安全'),
                ),
                BlockBtn(
                  title: '消息通知',
                  leading: Icons.notifications_outlined,
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 11)),
                  ),
                  onTap: () => _showToast(context, '消息通知'),
                ),
                BlockBtn(
                  title: '隐私',
                  leading: Icons.privacy_tip_outlined,
                  onTap: () => _showToast(context, '隐私'),
                ),
                BlockBtn(
                  title: '关于',
                  hint: 'v1.1.0',
                  leading: Icons.info_outline,
                  showDivider: false,
                  onTap: () => _showToast(context, '关于'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // 无圆角组
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                BlockBtn(
                  title: '深色模式',
                  leading: Icons.dark_mode_outlined,
                  arrow: false,
                  trailing: Switch(
                    value: false,
                    onChanged: (_) => _showToast(context, '切换深色模式'),
                  ),
                  onTap: () => _showToast(context, '深色模式'),
                ),
                BlockBtn(
                  title: '语言',
                  leading: Icons.language,
                  arrow: false,
                  trailing: Text('简体中文', style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  )),
                  showDivider: false,
                  onTap: () => _showToast(context, '语言'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showToast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(milliseconds: 800)),
    );
  }
}
