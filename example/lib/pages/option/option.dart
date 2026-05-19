import 'package:flutter/material.dart';
import 'package:ruolanui/ruolanui.dart';

class Option extends StatefulWidget {
  const Option({super.key});

  @override
  State<Option> createState() => _OptionState();
}

class _OptionState extends State<Option> {
  Set<int> _selected = {};
  Set<int> _selectedIcons = {};
  Set<int> _selectedRightAlign = {};

  final List<String> _tags = [
    "Flutter",
    "Dart",
    "iOS",
    "Android",
    "React Native",
    "SwiftUI",
    "Kotlin",
    "Java",
    "TypeScript",
    "Python",
    "Rust",
    "Go",
    "Vue",
    "React",
    "Angular",
    "Node.js",
    "Docker",
    "Kubernetes",
    "GraphQL",
    "REST API",
    "Firebase",
    "AWS",
    "GCP",
    "Azure",
    "MongoDB",
    "PostgreSQL",
    "Redis",
    "Nginx",
    "CI/CD",
    "Git",
  ];

  final List<IconOptionItem> _iconOptions = const [
    IconOptionItem(icon: Icons.camera_alt_outlined, label: "拍照"),
    IconOptionItem(icon: Icons.photo_library_outlined, label: "相册"),
    IconOptionItem(icon: Icons.videocam_outlined, label: "录像"),
    IconOptionItem(icon: Icons.insert_drive_file_outlined, label: "文件"),
    IconOptionItem(icon: Icons.location_on_outlined, label: "位置"),
    IconOptionItem(icon: Icons.contact_phone_outlined, label: "联系人"),
    IconOptionItem(icon: Icons.music_note_outlined, label: "音乐"),
    IconOptionItem(icon: Icons.link_outlined, label: "链接"),
    IconOptionItem(icon: Icons.qr_code, label: "扫码"),
    IconOptionItem(icon: Icons.wallet_outlined, label: "钱包"),
    IconOptionItem(icon: Icons.favorite_outline, label: "收藏"),
    IconOptionItem(icon: Icons.star_outline, label: "星标"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("选项弹窗示例")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle("基础弹窗"),
              PrimaryBtn(
                label: "显示选项（单列）",
                onPressed: () {
                  showSampleOptionsDialog(
                      options: ["拍照", "摄像"], context: context);
                },
              ),
              const SizedBox(height: 8),
              PrimaryBtn(
                label: "确认弹窗",
                onPressed: () {
                  showConfirmDialog(
                      context: context, title: "提示", content: "确定要删除吗？");
                },
              ),

              const SizedBox(height: 24),
              _buildSectionTitle("多选弹窗（左上角对齐）"),
              PrimaryBtn(
                label: "多选 - 纯文本标签（右对齐）",
                onPressed: () async {
                  final result = await showTextWrapOptionsDialog(
                    context: context,
                    title: "选择技术栈",
                    initialSelected: _selected,
                    options: _tags,
                  );
                  result.onSuccess((data) {
                    if (data != null) {
                      setState(() => _selected = data);
                    }
                  });
                },
              ),
              // 展示纯文本已选结果
              if (_selected.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selected
                        .map((i) => TextTag(label: _tags[i], selected: true))
                        .toList(),
                  ),
                ),
              const SizedBox(height: 8),
              PrimaryBtn(
                label: "多选 - 图标+文本（右对齐）",
                onPressed: () async {
                  final result = await showIconTextWrapOptionsDialog(
                    context: context,
                    title: "选择功能",
                    initialSelected: _selectedIcons,
                    options: _iconOptions,
                  );
                  result.onSuccess((data) {
                    if (data != null) {
                      setState(() => _selectedIcons = data);
                    }
                  });
                },
              ),
              // 展示图标已选结果
              if (_selectedIcons.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedIcons
                        .map((i) => TextTag(
                              selected: true,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(_iconOptions[i].icon, size: 14),
                                  const SizedBox(width: 4),
                                  Text(_iconOptions[i].label),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),
              const SizedBox(height: 8),
              PrimaryBtn(
                label: "多选 - 显式指定左对齐",
                onPressed: () async {
                  final result = await showWrapOptionsDialog<String>(
                    context: context,
                    title: "选择标签（左对齐）",
                    options: _tags.sublist(0, 10),
                    initialSelected: _selectedRightAlign,
                    alignment: WrapAlignment.start,
                    itemBuilder: (item, index, isSelected, onTap) {
                      return TextTag(
                          label: item, selected: isSelected, onTap: onTap);
                    },
                  );
                  result.onSuccess((data) {
                    if (data != null) {
                      setState(() => _selectedRightAlign = data);
                    }
                  });
                },
              ),
              if (_selectedRightAlign.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _selectedRightAlign
                        .map((i) => TextTag(
                            label: _tags.sublist(0, 10)[i], selected: true))
                        .toList(),
                  ),
                ),

              const SizedBox(height: 24),
              _buildSectionTitle("多选 - 左对齐（显式指定）"),
              PrimaryBtn(
                label: "多选 - 左对齐",
                onPressed: () async {
                  final result = await showWrapOptionsDialog<String>(
                    context: context,
                    title: "选择标签（左对齐）",
                    options: _tags.sublist(0, 8),
                    alignment: WrapAlignment.start,
                    itemBuilder: (item, index, isSelected, onTap) {
                      return TextTag(
                          label: item, selected: isSelected, onTap: onTap);
                    },
                  );
                  result.onSuccess((data) {
                    if (data != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                "选择了: ${data.map((i) => _tags[i]).join(', ')}")),
                      );
                    }
                  });
                },
              ),

              const SizedBox(height: 24),
              _buildSectionTitle("空选项提示"),
              PrimaryBtn(
                label: "空选项 - 默认提示",
                onPressed: () async {
                  await showWrapOptionsDialog<String>(
                    context: context,
                    title: "选择标签",
                    options: const [],
                    itemBuilder: (item, index, isSelected, onTap) {
                      return TextTag(
                          label: item, selected: isSelected, onTap: onTap);
                    },
                  );
                },
              ),
              const SizedBox(height: 8),
              PrimaryBtn(
                label: "空选项 - 自定义提示Widget",
                onPressed: () async {
                  await showWrapOptionsDialog<String>(
                    context: context,
                    title: "选择收藏",
                    options: const [],
                    emptyWidget: const DefaultEmptyOptionsWidget(
                      text: "还没有收藏内容哦",
                      icon: Icons.favorite_border,
                    ),
                    itemBuilder: (item, index, isSelected, onTap) {
                      return TextTag(
                          label: item, selected: isSelected, onTap: onTap);
                    },
                  );
                },
              ),
              const SizedBox(height: 8),
              PrimaryBtn(
                label: "空选项 - 完全自定义Widget",
                onPressed: () async {
                  await showWrapOptionsDialog<String>(
                    context: context,
                    title: "选择文件",
                    options: const [],
                    emptyWidget: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/empty.png',
                          width: 120,
                          height: 120,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.folder_open_outlined,
                            size: 64,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "文件夹为空",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "请先上传文件后再选择",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                        .withValues(alpha: 0.6),
                                  ),
                        ),
                      ],
                    ),
                    itemBuilder: (item, index, isSelected, onTap) {
                      return TextTag(
                          label: item, selected: isSelected, onTap: onTap);
                    },
                  );
                },
              ),

              const SizedBox(height: 24),
              _buildSectionTitle("单选弹窗"),
              PrimaryBtn(
                label: "单选 - 自定义颜色Widget",
                onPressed: () async {
                  final colors = [
                    Colors.red,
                    Colors.orange,
                    Colors.amber,
                    Colors.green,
                    Colors.teal,
                    Colors.blue,
                    Colors.indigo,
                    Colors.purple,
                  ];
                  final labels = [
                    "红色",
                    "橙色",
                    "琥珀",
                    "绿色",
                    "青色",
                    "蓝色",
                    "靛蓝",
                    "紫色",
                  ];
                  final options = List.generate(
                    colors.length,
                    (i) =>
                        IconOptionItem(icon: Icons.circle, label: labels[i]),
                  );
                  final result = await showWrapOptionsDialog<IconOptionItem>(
                    context: context,
                    title: "选择颜色（单选）",
                    options: options,
                    multiSelect: false,
                    spacing: 16,
                    runSpacing: 16,
                    itemBuilder: (item, index, isSelected, onTap) {
                      return IconTextOption(
                        label: item.label,
                        isSelected: isSelected,
                        onTap: onTap,
                        iconBuilder: (selected, fgColor) {
                          return Container(
                            decoration: BoxDecoration(
                              color: colors[index],
                              shape: BoxShape.circle,
                            ),
                          );
                        },
                      );
                    },
                  );
                  result.onSuccess((data) {
                    if (data != null && data.isNotEmpty) {
                      final index = data.first;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("选择了: ${labels[index]}")),
                      );
                    }
                  });
                },
              ),
              const SizedBox(height: 8),
              PrimaryBtn(
                label: "单选 - 空选项",
                onPressed: () async {
                  await showWrapOptionsDialog<IconOptionItem>(
                    context: context,
                    title: "选择颜色（单选）",
                    options: const [],
                    multiSelect: false,
                    itemBuilder: (item, index, isSelected, onTap) {
                      return IconTextOption(
                        icon: item.icon,
                        label: item.label,
                        isSelected: isSelected,
                        onTap: onTap,
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 24),
              _buildSectionTitle("底部固定展示"),
              PrimaryBtn(
                label: "大量选项 - 底部按钮固定",
                onPressed: () async {
                  // 使用大量选项验证底部按钮固定在弹窗底部
                  final manyTags = List.generate(
                      50, (i) => "标签${i + 1}");
                  final result = await showWrapOptionsDialog<String>(
                    context: context,
                    title: "大量选项（底部固定）",
                    options: manyTags,
                    itemBuilder: (item, index, isSelected, onTap) {
                      return TextTag(
                          label: item, selected: isSelected, onTap: onTap);
                    },
                  );
                  result.onSuccess((data) {
                    if (data != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("选择了 ${data.length} 项")),
                      );
                    }
                  });
                },
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }
}
